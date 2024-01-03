library pawntown_cast;

import 'dart:async';
import 'package:go_pts_client/go_pts_client.dart';
import 'package:pawntown_cast/models/enums.dart';
import 'package:pawntown_cast/models/livestream_state.dart';
import 'package:pawntown_cast/models/pawntown_livestream_options.dart';
import 'package:pawntown_cast/models/publisher_message.dart';
import 'package:pawntown_cast/services/publisher.dart';

class PawnTownLivestream {
  final GoPTSClient _ptsClient;
  final String _publicUrl;
  final PawnTownLivestreamOptions _options;
  final StreamController<LivestreamState> _controller = StreamController<LivestreamState>.broadcast();
  final Publisher _publisher;

  Stream<LivestreamState> get stream => _controller.stream;
  StreamSubscription<dynamic>? _sub;
  LivestreamState _state = LivestreamState.initial();
  LivestreamState get state => _state;

  PawnTownLivestream(this._ptsClient, this._publicUrl, this._options): _publisher = Publisher(_ptsClient, "/stream/${_options.token}/admin");

  void _addState(LivestreamState newState) {
    _state = newState.copyWith();
    _controller.add(newState);
  }

  Future<void> connect() async {
    Completer completer = Completer();

    if (_sub != null) {
      throw Exception("Already running.");
    }

    final sub = _ptsClient.subscribeChannel("/stream/${_options.token}/admin").listen((event) {
        final state = _state.copyWith();
        if (!state.connected) {
          if (event['code'] != null && event['code'] >= errorStreamAlreadyOpen) {
            _sub!.cancel();
            completer.completeError(Exception(event['description']));
            return;
          }

          if (event['type'] == StreamEvent.start.index) {
            final streamId = event['streamId'];
            _addState(state.copyWith(
              connected: true,
              token: _options.token,
              id: streamId,
              link: "$_publicUrl/s/$streamId",
              viewers: 0,
            ));
            completer.complete();
            return;
          }

          /* This is wired, receiving information without any stream start */
          return;
        }
        
        /* handle messages if needed */
        if (event['type'] == StreamEvent.stats.index) {
          _addState(_state.copyWith(viewers: event['viewers']));
        }
    });

    sub.onDone(() {
      _sub = null;
      _addState(LivestreamState.initial());
    });

    _sub = sub;
    return completer.future;
  }

  Future<void> disconnect() async {
    final sub = _sub;
    if (sub != null) {
      await sub.cancel();
    }
  }

  void pauseScreen() {
    _publisher.publish(PublisherMessage(
      identifier: "pauseScreen".hashCode,
      payload: { "type": StreamEvent.pause.index },
    ));
  }

  void updatePosition({
    String? whiteDisplayName,
    String? blackDisplayName,
    String? whiteUsername,
    String? blackUsername,
    Duration? whiteTimeLeft,
    Duration? blackTimeLeft,
    bool? timeRunning,
    String? fen,
    List<String> moves = const [],
    StreamTurn turn = StreamTurn.none,
    StreamOrientation orientation = StreamOrientation.white,
    StreamWinner winner = StreamWinner.none,
    StreamRunType runType = StreamRunType.running,
    HardwareClockState hardwareClockState = HardwareClockState.none,
  }) {
    _publisher.publish(PublisherMessage(
      identifier: "updatePosition-$fen-${moves.join(",")}-$whiteDisplayName-$blackDisplayName-$whiteUsername-$blackUsername-${whiteTimeLeft?.inMilliseconds ?? 0}-${blackTimeLeft?.inMilliseconds ?? 0}-$timeRunning-${turn.index}-${orientation.index}-${winner.index}-${runType.index}-${hardwareClockState.index}".hashCode,
      payload: {
        "type": StreamEvent.position.index,
        "fen": fen,
        "moves": moves,
        "whiteDisplayName": whiteDisplayName,
        "blackDisplayName": blackDisplayName,
        "whiteUsername": whiteUsername,
        "blackUsername": blackUsername,
        "whiteTimeLeft": whiteTimeLeft?.inMilliseconds ?? 0,
        "blackTimeLeft": blackTimeLeft?.inMilliseconds ?? 0,
        "timeRunning": timeRunning,
        "turn": turn.index,
        "orientation": orientation.index,
        "winner": winner.index,
        "runType": runType.index,
        "hardwareClockState": hardwareClockState.index,
        "createdAt": "${DateTime.now().toIso8601String()}Z",
      },
    ));
  }
}
