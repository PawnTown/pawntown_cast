# Pawntown Cast

This is a Dart package that provides various models and services for use with Pawntown.

## Usage

Import the package in your Dart file:

```yaml
dependencies:
  pawntown_cast: ^latest_version
```

Führen Sie dann `flutter pub get` aus.

## Usage

Import the package in your Dart file:

```dart
import 'package:pawntown_cast/pawntown_cast.dart';
```

```dart
import 'package:pawntown_cast/pawntown_cast.dart';
import 'package:pawntown_cast/models/pawntown_cast_options.dart';
import 'package:pawntown_cast/models/pawntown_livestream_options.dart';
import 'package:pawntown_cast/models/token_info.dart';

void main() async {
  final options = PawnTownCastOptions(
    // Set your options here
  );

  // Create a PawnTown Cast Instance
  final cast = PawnTownCast(options);

  // This is a token created at https://pawn.town/account/stream
  final token = "A_PAWN_TOWN_TOKEN";

  // Create Livestream Options
  final livestreamOptions = PawnTownLivestreamOptions(
    token: token
  );

  // Create a new Livestream
  final livestream = await cast.createLivestream(livestreamOptions);

  // Publish Positions
  livestream.updatePosition({ fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" })
}
```

## Package Contents

The package contains the following models and services:

- `enums.dart`
- `livestream_state.dart`
- `pawntown_cast_options.dart`
- `pawntown_cast_state.dart`
- `pawntown_livestream_options.dart`
- `token_info.dart`
- `pawntown_cast.dart`
- `pawntown_livestream.dart`

## Hinweis

Dieses Paket ist noch in Entwicklung. Es können noch Änderungen vorgenommen werden.