class TicketNumberGenerator {
  TicketNumberGenerator._();

  static String generate() {
    final now = DateTime.now();
    final datePart =
        '${now.year.toString().substring(2)}${_two(now.month)}${_two(now.day)}';
    final timePart = '${_two(now.hour)}${_two(now.minute)}${_two(now.second)}';
    return 'TCK-$datePart-$timePart';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
