import 'package:sm_crypto/sm_crypto.dart';

void sm3Example() {
  String data = 'Hello! SM-CRYPTO @Greenking19';
  String sm3Encrypt = SM3.encryptString(data);
  print('👇 SM3 Encrypt Data:');
  print(sm3Encrypt);
}

void sm4Example() {
  String key = SM4.createHexKey(key: '1234567890987654');
  String data = 'Hello! SM-CRYPTO @Greenking19';
  print('👇 ECB Encrypt Mode');
  String ebcEncryptData = SM4.encrypt(data: data, key: key);
  print('🔒 EBC EncryptptData:\n $ebcEncryptData');
  String ebcDecryptData = SM4.decrypt(data: ebcEncryptData, key: key);
  print('🔑 EBC DecryptData:\n $ebcDecryptData');

  print('👇 CBC Encrypt Mode');
  String iv = SM4.createHexKey(key: '1234567890987654');
  String cbcEncryptData = SM4.encrypt(
    data: data,
    key: key,
    mode: SM4CryptoMode.CBC,
    iv: iv,
  );
  print('🔒 CBC EncryptptData:\n $cbcEncryptData');
  String cbcDecryptData = SM4.decrypt(
    data: cbcEncryptData,
    key: key,
    mode: SM4CryptoMode.CBC,
    iv: iv,
  );
  print('🔑 CBC DecryptData:\n $cbcDecryptData');
}

void main() {
  sm3Example();
  sm4Example();
}
