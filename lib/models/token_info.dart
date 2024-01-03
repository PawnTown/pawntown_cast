class PawnTownTokenInfo {
  String token;
  bool valid;
  String streamId;

  PawnTownTokenInfo(this.token, this.valid, this.streamId);

  factory PawnTownTokenInfo.fromJSON(Map<String, dynamic> json) {
    return PawnTownTokenInfo(
      json['token'],
      json['valid'],
      json['streamId'],
    );
  }
}
