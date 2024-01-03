library pawntown_cast;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:go_pts_client/go_pts_client.dart';
import 'package:pawntown_cast/models/pawntown_cast_options.dart';
import 'package:pawntown_cast/models/pawntown_cast_state.dart';
import 'package:pawntown_cast/models/pawntown_livestream_options.dart';
import 'package:pawntown_cast/models/token_info.dart';
import 'package:pawntown_cast/services/pawntown_livestream.dart';

class PawnTownService {
  final HttpClient _httpClient;
  final GoPTSClient _ptsClient;
  final PawnTownCastOptions _options;
  final StreamController<PawnTownCastState> _controller = StreamController<PawnTownCastState>.broadcast();

  Stream<PawnTownCastState> get stream => _controller.stream;
  PawnTownCastState _state = PawnTownCastState();
  PawnTownCastState get state => _state;

  PawnTownService(this._options) : _httpClient = HttpClient(), _ptsClient = GoPTSClient(GoPTSClientConfig(uri: Uri.parse(_options.liveUrl))) {
    _ptsClient.connect();
  }

  void _addState(PawnTownCastState newState) {
    _state = newState.copyWith();
    _controller.add(newState);
  }

  Future<PawnTownTokenInfo> fetchTokenInfo(String token) async {
    HttpClientRequest request = await _httpClient.getUrl(Uri.parse("${_options.apiBaseUrl}/token/$token"));
    request.headers.contentType = ContentType("application", "json", charset: "utf-8");
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    Map<String, dynamic> data = jsonDecode(reply);
    return PawnTownTokenInfo.fromJSON(data);
  }

  PawnTownLivestream? getLivestream(String streamId) {
    return _state.livestreams.where((element) => element.state.id == streamId).firstOrNull;
  }
  
  Future<PawnTownLivestream> createLivestream(PawnTownLivestreamOptions options) async {
    final tokenInfo = await fetchTokenInfo(options.token);
    if (!tokenInfo.valid) {
      throw Exception("Invalid token");
    }

    final existing = getLivestream(tokenInfo.streamId);
    if (existing != null) {
      if (!existing.state.connected) {
        existing.connect();
      }
      return existing;
    }

    final livestream = PawnTownLivestream(_ptsClient, _options.publicUrl, options);
    await livestream.connect();

    _addState(_state.copyWith(livestreams: [..._state.livestreams, livestream]));
    livestream.stream.listen((event) {
      _addState(_state.copyWith());
    });

    return livestream;
  }

  void dispose() {
    _ptsClient.dispose();
  }
}
