const errorStreamAlreadyOpen = 101;
const errorStreamInvalidToken = 102;

enum StreamEvent {
  position,
  pause,
  ended,
  stats,
  start,
}

enum StreamOrientation {
  white,
  black,
}

enum StreamTurn {
  none,
  white,
  black,
}

enum StreamWinner {
  none,
  white,
  black,
  draw,
}

enum StreamRunType {
  running,
  aborted,
  checkmate,
  resign,
  draw,
  timeout,
}

enum HardwareClockState {
  none,
  whiteRunning,
  blackRunning,
}
