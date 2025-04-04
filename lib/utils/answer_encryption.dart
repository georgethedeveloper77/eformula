import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutterquiz/features/quiz/models/correct_answer.dart';

class AnswerEncryption {
  static String decryptCorrectAnswer({
    required String rawKey,
    required CorrectAnswer correctAnswer,
  }) {
    try {
      final key = enc.Key.fromUtf8('${rawKey}0000');

      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

      final initializationVector = enc.IV.fromBase16(correctAnswer.iv);

      final decrypted = encrypter.decrypt(
        enc.Encrypted.fromBase64(correctAnswer.cipherText),
        iv: initializationVector,
      );

      return decrypted;
    } on Exception catch (_) {
      return '';
    }
  }
}
