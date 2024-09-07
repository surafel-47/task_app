import 'dart:math';

class Utils {
  static String generateRandomId(int length) {
    const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();

    return List.generate(length, (index) {
      return characters[random.nextInt(characters.length)];
    }).join();
  }
}
