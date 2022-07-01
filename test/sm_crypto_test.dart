import 'package:sm_crypto/src/sm4.dart';

void testChangeParams(List value) {
  value[1] = 888;
}

void main(List<String> args) {
  String key = SM4.createHexKey(key: '1234567890987654');
  String data = 'Hello! SM-CRYPTO @Greenking19';

  String encryptData = SM4.encrypt(
    data: data,
    key: key,
  );
  print('🔐 encryptData data:\n${encryptData.toUpperCase()}');
  String decryptData = SM4.decrypt(
    data: encryptData,
    key: key,
  );
  print('🔑 decryptData data:\n${decryptData}');
}
