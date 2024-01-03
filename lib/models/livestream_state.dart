class LivestreamState {
  final bool connected;
  final String id;
  final String token;
  final String link;
  final int viewers;

  LivestreamState({required this.connected, required this.id, required this.token, required this.link, required this.viewers});

  factory LivestreamState.initial() {
    return LivestreamState(
      connected: false,
      id: "",
      token: "",
      link: "",
      viewers: 0,
    );
  }

  LivestreamState copyWith({bool? connected, String? id, String? token, String? link, int? viewers}) {
    return LivestreamState(
      connected: connected ?? this.connected,
      id: id ?? this.id,
      token: token ?? this.token,
      link: link ?? this.link,
      viewers: viewers ?? this.viewers,
    );
  }
} 