/// A controllable, deterministic clock for temporal simulations.
/// Replaces uncontrolled [DateTime.now()] with strictly manageable intervals.
class DeterministicClock {
  DateTime _current;

  DeterministicClock([DateTime? initialTime])
      : _current = initialTime ?? DateTime(2026, 9, 10, 8, 0, 0);

  DateTime get now => _current;

  void setTime(DateTime time) {
    _current = time;
  }

  void advance(Duration duration) {
    _current = _current.add(duration);
  }

  void advanceMinutes(int minutes) {
    advance(Duration(minutes: minutes));
  }

  void advanceHours(int hours) {
    advance(Duration(hours: hours));
  }

  void advanceDays(int days) {
    advance(Duration(days: days));
  }

  void advanceWeeks(int weeks) {
    advance(Duration(days: weeks * 7));
  }
}
