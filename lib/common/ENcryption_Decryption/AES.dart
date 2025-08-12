import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';

/// Convert Base64 to Uint8List
Uint8List base64ToBytes(String base64Str) => base64.decode(base64Str);

/// Convert Uint8List to Base64 string
String bytesToBase64(Uint8List bytes) => base64.encode(bytes);

/// PKCS7 padding
Uint8List pkcs7Pad(Uint8List data, int blockSize) {
  final pad = blockSize - (data.length % blockSize);
  final padded = Uint8List(data.length + pad)..setAll(0, data);
  for (int i = data.length; i < padded.length; i++) {
    padded[i] = pad;
  }
  return padded;
}

/// Remove PKCS7 padding
Uint8List pkcs7Unpad(Uint8List padded) {
  final pad = padded.last;
  if (pad < 1 || pad > 16) {
    throw ArgumentError('Invalid PKCS7 padding');
  }
  return padded.sublist(0, padded.length - pad);
}

/// AES-CBC encrypt with PKCS7 padding
Uint8List aesCbcEncrypt(Uint8List plainData, Uint8List key, Uint8List iv) {
  final cipher = CBCBlockCipher(AESFastEngine());
  final params = ParametersWithIV(KeyParameter(key), iv);
  cipher.init(true, params);

  final padded = pkcs7Pad(plainData, cipher.blockSize);

  final output = Uint8List(padded.length);
  for (int offset = 0; offset < padded.length; offset += cipher.blockSize) {
    cipher.processBlock(padded, offset, output, offset);
  }
  return output;
}

/// AES-CBC decrypt with PKCS7 unpadding
Uint8List aesCbcDecrypt(Uint8List cipherData, Uint8List key, Uint8List iv) {
  final cipher = CBCBlockCipher(AESFastEngine());
  final params = ParametersWithIV(KeyParameter(key), iv);
  cipher.init(false, params);

  final output = Uint8List(cipherData.length);
  for (int offset = 0; offset < cipherData.length; offset += cipher.blockSize) {
    cipher.processBlock(cipherData, offset, output, offset);
  }

  return pkcs7Unpad(output);
}

/// RSA-OAEP encrypt with SHA-1
Uint8List rsaOaepEncrypt(Uint8List data, RSAPublicKey publicKey) {
  final encryptor = OAEPEncoding(RSAEngine())..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

  final inputBlockSize = encryptor.inputBlockSize;
  final output = BytesBuilder();

  for (int offset = 0; offset < data.length; offset += inputBlockSize) {
    final end = (offset + inputBlockSize).clamp(0, data.length);
    final block = data.sublist(offset, end);
    output.add(encryptor.process(block));
  }

  return output.toBytes();
}

/// RSA-OAEP decrypt with SHA-1
Uint8List rsaOaepDecrypt(Uint8List data, RSAPrivateKey privateKey) {
  final decryptor = OAEPEncoding(RSAEngine())..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

  final keySize = (privateKey.n!.bitLength + 7) ~/ 8; // key size in bytes
  final output = BytesBuilder();

  for (int offset = 0; offset < data.length; offset += keySize) {
    final end = (offset + keySize).clamp(0, data.length);
    final block = data.sublist(offset, end);
    output.add(decryptor.process(block));
  }

  return output.toBytes();
}

Uint8List generateRandomBytes(int length) {
  final secureRandom = FortunaRandom();
  final seed = Uint8List.fromList(List<int>.generate(32, (i) => DateTime.now().microsecondsSinceEpoch.remainder(256)));
  secureRandom.seed(KeyParameter(seed));
  return secureRandom.nextBytes(length);
}

Uint8List generateAESKey() => generateRandomBytes(32);

Uint8List generateIV() => generateRandomBytes(16);

Future<Map<String, String>> encrypt({
  required dynamic data, // String or Map
  required String rsaPublicKeyPem,
}) async {
  final publicKey = CryptoUtils.rsaPublicKeyFromPem(rsaPublicKeyPem);

  final aesKey = generateAESKey();
  final iv = generateIV();

  final plainBytes = utf8.encode(data is String ? data : jsonEncode(data));

  final encryptedData = aesCbcEncrypt(Uint8List.fromList(plainBytes), aesKey, iv);

  final encryptedAESKey = rsaOaepEncrypt(aesKey, publicKey);

  return {
    'EncryptedAESKey': bytesToBase64(encryptedAESKey),
    'EncryptedData': bytesToBase64(encryptedData),
    'IV': bytesToBase64(iv),
  };
}

/// Decrypt data using RSA + AES-CBC
Future<String> decrypt({
  required String encryptedAESKeyBase64,
  required String encryptedDataBase64,
  required String ivBase64,
  required String rsaPrivateKeyPem,
}) async {
  final privateKey = CryptoUtils.rsaPrivateKeyFromPem(rsaPrivateKeyPem);

  final encryptedAESKeyBytes = base64ToBytes(encryptedAESKeyBase64);
  final encryptedDataBytes = base64ToBytes(encryptedDataBase64);
  final ivBytes = base64ToBytes(ivBase64);

  // RSA decrypt AES key
  final aesKeyBytes = rsaOaepDecrypt(encryptedAESKeyBytes, privateKey);

  // AES decrypt data
  final decryptedBytes = aesCbcDecrypt(encryptedDataBytes, aesKeyBytes, ivBytes);

  return utf8.decode(decryptedBytes);
}