import 'dart:math';

String generateDocReference() {
  final now = DateTime.now();
  final date = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  final timestamp = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  final randomString = List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();

  return '$date$timestamp$randomString';
}