class PawnTownCastOptions {
  final String apiBaseUrl;
  final String liveUrl;
  final String publicUrl;

  PawnTownCastOptions({
    this.apiBaseUrl = "https://api.pawn.town",
    this.liveUrl = "wss://live.pawn.town/connect",
    this.publicUrl = "https://pawn.town",
  });
}
