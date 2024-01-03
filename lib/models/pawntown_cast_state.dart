import 'package:pawntown_cast/services/pawntown_livestream.dart';

class PawnTownCastState {
  final List<PawnTownLivestream> livestreams;

  PawnTownCastState({this.livestreams = const []});

  PawnTownCastState copyWith({List<PawnTownLivestream>? livestreams}) {
    return PawnTownCastState(livestreams: livestreams ?? this.livestreams);
  }
} 