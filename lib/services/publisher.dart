library pawntown_cast;

import 'package:go_pts_client/go_pts_client.dart';
import 'package:pawntown_cast/models/publisher_message.dart';

class Publisher {
  final String _channel;
  final GoPTSClient _ptsClient;
  final List<PublisherMessage> _history = <PublisherMessage>[];

  Publisher(this._ptsClient, this._channel);

  void publish(PublisherMessage message) {
    if (_history.isNotEmpty && _history.last.identifier == message.identifier) {
      return;
    }
    _history.add(message);
    _ptsClient.send(_channel, payload: message.payload);
  }
}
