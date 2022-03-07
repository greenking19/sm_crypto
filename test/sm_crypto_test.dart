import 'package:sm_crypto/src/sm4.dart';

void testChangeParams(List value) {
  value[1] = 888;
}

void main(List<String> args) {
  String msg = '林金智1234560000000000';

  String testKey = SM4.createHexKey(key: '1');

  String encryptData = SM4.encrypt(
    data: msg,
    key: testKey,
  );
  print('🔐 encryptData data:\n${encryptData.toUpperCase()}');
  String decryptData = SM4.decrypt(
    data: encryptData,
    key: testKey,
  );
  print('🔑 decryptData data:\n${decryptData}');
}
