# SM_CRYPTO 国家加密算法Dart版本
### Multiple encryption: 
1. sm2 (coding)
2. sm3 (coding)
3. sm4

## Using
### SM4
```dart
void sm4Example() {
  String key = SM4.createHexKey(key: '1234567890987654');
  String data = 'Hello! SM-CRYPTO @greenking19';
  print('👇 ECB Encrypt Mode:');
  String ebcEncryptData = SM4.encrypt(data: data, key: key);
  print('🔒 EBC EncryptptData:\n $ebcEncryptData');
  String ebcDecryptData = SM4.decrypt(data: ebcEncryptData, key: key);
  print('🔑 EBC DecryptData:\n $ebcDecryptData');

  print('👇 CBC Encrypt Mode:');
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
  sm4Example();
}
```
## Installing
With Dart:
```shell
    dat pub add sm_crypto
```
With Flutter:
```shell
    flutter pub add sm_crypto
```
This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):
```yaml
dependencies:
  sm_crypto: ^1.0.0
```
## Import it

### Now in your Dart code, you can use:
```dart
import 'package:sm_crypto/sm_crypto.dart';
```


