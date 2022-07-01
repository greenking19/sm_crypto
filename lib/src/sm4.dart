import 'dart:convert';
import 'package:convert/convert.dart';

// decrypt flag decarpt
const DECRYPT = 0;

// decrypt flag encrypt
const ENCRYPT = 1;

/// SM4 ROUND
const ROUND = 32;

/// SM4 BLOCK
const BLOCK = 16;

/// sbox array
const List<int> SBox = [
  0xd6,
  0x90,
  0xe9,
  0xfe,
  0xcc,
  0xe1,
  0x3d,
  0xb7,
  0x16,
  0xb6,
  0x14,
  0xc2,
  0x28,
  0xfb,
  0x2c,
  0x05,
  0x2b,
  0x67,
  0x9a,
  0x76,
  0x2a,
  0xbe,
  0x04,
  0xc3,
  0xaa,
  0x44,
  0x13,
  0x26,
  0x49,
  0x86,
  0x06,
  0x99,
  0x9c,
  0x42,
  0x50,
  0xf4,
  0x91,
  0xef,
  0x98,
  0x7a,
  0x33,
  0x54,
  0x0b,
  0x43,
  0xed,
  0xcf,
  0xac,
  0x62,
  0xe4,
  0xb3,
  0x1c,
  0xa9,
  0xc9,
  0x08,
  0xe8,
  0x95,
  0x80,
  0xdf,
  0x94,
  0xfa,
  0x75,
  0x8f,
  0x3f,
  0xa6,
  0x47,
  0x07,
  0xa7,
  0xfc,
  0xf3,
  0x73,
  0x17,
  0xba,
  0x83,
  0x59,
  0x3c,
  0x19,
  0xe6,
  0x85,
  0x4f,
  0xa8,
  0x68,
  0x6b,
  0x81,
  0xb2,
  0x71,
  0x64,
  0xda,
  0x8b,
  0xf8,
  0xeb,
  0x0f,
  0x4b,
  0x70,
  0x56,
  0x9d,
  0x35,
  0x1e,
  0x24,
  0x0e,
  0x5e,
  0x63,
  0x58,
  0xd1,
  0xa2,
  0x25,
  0x22,
  0x7c,
  0x3b,
  0x01,
  0x21,
  0x78,
  0x87,
  0xd4,
  0x00,
  0x46,
  0x57,
  0x9f,
  0xd3,
  0x27,
  0x52,
  0x4c,
  0x36,
  0x02,
  0xe7,
  0xa0,
  0xc4,
  0xc8,
  0x9e,
  0xea,
  0xbf,
  0x8a,
  0xd2,
  0x40,
  0xc7,
  0x38,
  0xb5,
  0xa3,
  0xf7,
  0xf2,
  0xce,
  0xf9,
  0x61,
  0x15,
  0xa1,
  0xe0,
  0xae,
  0x5d,
  0xa4,
  0x9b,
  0x34,
  0x1a,
  0x55,
  0xad,
  0x93,
  0x32,
  0x30,
  0xf5,
  0x8c,
  0xb1,
  0xe3,
  0x1d,
  0xf6,
  0xe2,
  0x2e,
  0x82,
  0x66,
  0xca,
  0x60,
  0xc0,
  0x29,
  0x23,
  0xab,
  0x0d,
  0x53,
  0x4e,
  0x6f,
  0xd5,
  0xdb,
  0x37,
  0x45,
  0xde,
  0xfd,
  0x8e,
  0x2f,
  0x03,
  0xff,
  0x6a,
  0x72,
  0x6d,
  0x6c,
  0x5b,
  0x51,
  0x8d,
  0x1b,
  0xaf,
  0x92,
  0xbb,
  0xdd,
  0xbc,
  0x7f,
  0x11,
  0xd9,
  0x5c,
  0x41,
  0x1f,
  0x10,
  0x5a,
  0xd8,
  0x0a,
  0xc1,
  0x31,
  0x88,
  0xa5,
  0xcd,
  0x7b,
  0xbd,
  0x2d,
  0x74,
  0xd0,
  0x12,
  0xb8,
  0xe5,
  0xb4,
  0xb0,
  0x89,
  0x69,
  0x97,
  0x4a,
  0x0c,
  0x96,
  0x77,
  0x7e,
  0x65,
  0xb9,
  0xf1,
  0x09,
  0xc5,
  0x6e,
  0xc6,
  0x84,
  0x18,
  0xf0,
  0x7d,
  0xec,
  0x3a,
  0xdc,
  0x4d,
  0x20,
  0x79,
  0xee,
  0x5f,
  0x3e,
  0xd7,
  0xcb,
  0x39,
  0x48
];

/// ck array
const List<int> CK = [
  0x00070e15,
  0x1c232a31,
  0x383f464d,
  0x545b6269,
  0x70777e85,
  0x8c939aa1,
  0xa8afb6bd,
  0xc4cbd2d9,
  0xe0e7eef5,
  0xfc030a11,
  0x181f262d,
  0x343b4249,
  0x50575e65,
  0x6c737a81,
  0x888f969d,
  0xa4abb2b9,
  0xc0c7ced5,
  0xdce3eaf1,
  0xf8ff060d,
  0x141b2229,
  0x30373e45,
  0x4c535a61,
  0x686f767d,
  0x848b9299,
  0xa0a7aeb5,
  0xbcc3cad1,
  0xd8dfe6ed,
  0xf4fb0209,
  0x10171e25,
  0x2c333a41,
  0x484f565d,
  0x646b7279
];

/// sm4 crypto mode
/// [ECB,CBC]
class SM4CryptoMode {
  /// ECB mode
  static const String ECB = 'ecb';

  /// CBC mode
  static const String CBC = 'cbc';
}

/// sm4 padding mode
class SM4PaddingMode {
  static const String PKCS5 = 'pkcs#5';
  static const String PKCS7 = 'pkcs#7';
  static const String NONE = 'none';
}

/// sm4 output mode
class SM4OutputMode {
  static const Array = 'array';
  static const HexString = 'hex';
}

/// hex string to byte array
List<int> _hexToArray(String str) {
  List<int> intList = [];
  int len = str.length;

  for (int i = 0; i < len; i += 2) {
    int startIndex = i;
    int endIndex = i + 2;

    String strItem = str.substring(startIndex, endIndex);

    int? _hex = int.tryParse(strItem, radix: 16);

    if (_hex != null) {
      intList.add(_hex);
    }
  }
  return hex.decode(str);
}

/// hex byte array to hex string
String _arrayToHex(List<int> arr) {
  String hexString = arr
      .map((item) {
        String itemHexString = item.toRadixString(16);
        // The hexadecimal notation is 0123456789ABCDEF
        //if there is a single one, add 0
        if (itemHexString.length == 1) {
          return '0$itemHexString';
        } else {
          return itemHexString;
        }
      })
      .toList()
      .join('');

  return hexString;
}

/// Utf8 to byte array
List<int> _utf8ToArray(String str) {
  return utf8.encode(str);
}

/// Byte array to utf8 string
String _arrayToUtf8(List<int> arr) {
  return utf8.decode(arr);
}

/// 32-bit Rotate Left
int _rotl(int x, int y) {
  return (x << y) | ((x & 0xFFFFFFFF) >> (32 - y));
}

/// Linear transformation, for encryption/decryption
int _l1(b) {
  return b ^ _rotl(b, 2) ^ _rotl(b, 10) ^ _rotl(b, 18) ^ _rotl(b, 24);
}

/// Linear transformation, used to generate round keys
int _l2(b) {
  return b ^ _rotl(b, 13) ^ _rotl(b, 23);
}

/// Nonlinear transformation
int _byteSub(a) {
  return (((SBox[((a & 0xFFFFFFFF) >> 24) & 0xff] & 0xff) << 24) |
      ((SBox[((a & 0xFFFFFFFF) >> 16) & 0xff] & 0xff) << 16) |
      ((SBox[((a & 0xFFFFFFFF) >> 8) & 0xff] & 0xff) << 8) |
      (SBox[a & 0xff] & 0xff));
}

/// Encrypt/decrypt operations in a set of 128 bits
void _sms4Crypt(
  List<int> input,
  List<int> output,
  List<int> roundKey,
) {
  List<int> x = List.filled(4, 0);

  // 字节数组转成字数组（此处 1 字 = 32 比特）
  List<int> tmp = List.filled(4, 0);
  for (int i = 0; i < 4; i++) {
    tmp[0] = input[4 * i] & 0xff;
    tmp[1] = input[4 * i + 1] & 0xff;
    tmp[2] = input[4 * i + 2] & 0xff;
    tmp[3] = input[4 * i + 3] & 0xff;
    x[i] = (tmp[0] << 24) | (tmp[1] << 16) | (tmp[2] << 8) | tmp[3];
  }

  // x[i + 4] = x[i] ^ l1(byteSub(x[i + 1] ^ x[i + 2] ^ x[i + 3] ^ roundKey[i]))
  for (int r = 0, mid; r < 32; r += 4) {
    mid = x[1] ^ x[2] ^ x[3] ^ roundKey[r + 0];
    x[0] ^= _l1(_byteSub(mid)); // x[4]

    mid = x[2] ^ x[3] ^ x[0] ^ roundKey[r + 1];
    x[1] ^= _l1(_byteSub(mid)); // x[5]

    mid = x[3] ^ x[0] ^ x[1] ^ roundKey[r + 2];
    x[2] ^= _l1(_byteSub(mid)); // x[6]

    mid = x[0] ^ x[1] ^ x[2] ^ roundKey[r + 3];
    x[3] ^= _l1(_byteSub(mid)); // x[7]
  }

  // reverse order transformation
  for (int j = 0; j < 16; j += 4) {
    output[j] = (((x[(3 - j / 4).toInt()]) & 0xFFFFFFFF) >> 24) & 0xff;
    output[j + 1] = ((x[(3 - j / 4).toInt()] & 0xFFFFFFFF) >> 16) & 0xff;
    output[j + 2] = ((x[(3 - j / 4).toInt()] & 0xFFFFFFFF) >> 8) & 0xff;
    output[j + 3] = x[(3 - j / 4).toInt()] & 0xff;
  }
}

/// key expansion algorithm
void _sms4KeyExt(List<int> key, List<int> roundKey, int cryptFlag) {
  List<int> x = List.filled(4, 0);

  // Byte array to word array (here 1 word = 32 bits)
  List<int> tmp = List.filled(4, 0);
  for (int i = 0; i < 4; i++) {
    tmp[0] = key[0 + 4 * i] & 0xff;
    tmp[1] = key[1 + 4 * i] & 0xff;
    tmp[2] = key[2 + 4 * i] & 0xff;
    tmp[3] = key[3 + 4 * i] & 0xff;
    x[i] = (tmp[0] << 24) | (tmp[1] << 16) | (tmp[2] << 8) | tmp[3];
  }

  // XOR with system parameters
  x[0] ^= 0xa3b1bac6;
  x[1] ^= 0x56aa3350;
  x[2] ^= 0x677d9197;
  x[3] ^= 0xb27022dc;

  // roundKey[i] = x[i + 4] = x[i] ^ l2(byteSub(x[i + 1] ^ x[i + 2] ^ x[i + 3] ^ CK[i]))
  for (int r = 0, mid; r < 32; r += 4) {
    mid = x[1] ^ x[2] ^ x[3] ^ CK[r + 0];
    roundKey[r + 0] = x[0] ^= _l2(_byteSub(mid)); // x[4]

    mid = x[2] ^ x[3] ^ x[0] ^ CK[r + 1];
    roundKey[r + 1] = x[1] ^= _l2(_byteSub(mid)); // x[5]

    mid = x[3] ^ x[0] ^ x[1] ^ CK[r + 2];
    roundKey[r + 2] = x[2] ^= _l2(_byteSub(mid)); // x[6]

    mid = x[0] ^ x[1] ^ x[2] ^ CK[r + 3];
    roundKey[r + 3] = x[3] ^= _l2(_byteSub(mid)); // x[7]
  }

  // Use reversed round keys for decryption
  if (cryptFlag == DECRYPT) {
    for (int r = 0, mid; r < 16; r++) {
      mid = roundKey[r];
      roundKey[r] = roundKey[31 - r];
      roundKey[31 - r] = mid;
    }
  }
}

/// 🏭 sm4 factory
///
/// encrypto and decrypto
dynamic _sm4Factory({
  required List<int> data,
  required List<int> key,
  required int cryptFlag,
  String padding = SM4PaddingMode.PKCS7,
  String mode = SM4CryptoMode.ECB,
  List<int>? iv,
  String? outputType: SM4OutputMode.HexString,
}) {
  // expand operation
  data = [...data];

  // 新增填充，sm4 是 16 个字节一个分组，所以统一走到 pkcs#7
  if ((padding == 'pkcs#5' || padding == 'pkcs#7') && cryptFlag != DECRYPT) {
    int paddingCount = BLOCK - (data.length % BLOCK);
    for (int i = 0; i < paddingCount; i++) {
      data.add(paddingCount);
    }
  }

  // 生成轮密钥
  List<int> roundKey = List.filled(ROUND, 0);

  _sms4KeyExt(key, roundKey, cryptFlag);

  List<int> outArray = List.filled(32, 0);
  List<int>? lastVector = iv;
  int restLen = data.length;
  int point = 0;

  while (restLen >= BLOCK) {
    List<int> input = data.sublist(point, point + 16);

    List<int> outputArr = List.filled(16, 0);

    if (mode == 'cbc' && lastVector != null) {
      for (int i = 0; i < BLOCK; i++) {
        if (cryptFlag != DECRYPT) {
          // 加密过程在组加密前进行异或
          // The encryption process is XORed before group encryption
          input[i] ^= lastVector[i];
        }
      }
    }

    _sms4Crypt(input, outputArr, roundKey);

    for (int i = 0; i < BLOCK; i++) {
      if (mode == 'cbc') {
        if (cryptFlag == DECRYPT && lastVector != null) {
          // The decryption process XORs the group after decryption
          outputArr[i] ^= lastVector[i];
        }
      }
      int outArrayIndex = point + i;
      // Fix dart list problem
      if (outArrayIndex > outArray.length - 1) {
        outArray = [...outArray, outputArr[i]];
      } else {
        outArray[outArrayIndex] = outputArr[i];
      }
    }

    if (mode == 'cbc') {
      if (cryptFlag == ENCRYPT) {
        // Use last output as encrypted vector
        lastVector = outputArr;
      } else {
        // Use the last input as the decryption vector
        lastVector = input;
      }
    }
    if (mode == ENCRYPT) {
      int firstZero = outArray.indexOf(0);
      if (firstZero > 0) {
        outArray = outArray.sublist(0, firstZero);
      }
    }
    restLen -= BLOCK;
    point += BLOCK;
  }

  // remove padding, sm4 is a group of 16 bytes, so go to pkcs#7
  if ((padding == 'pkcs#5' || padding == 'pkcs#7') && cryptFlag == DECRYPT) {
    // remove padded 0
    int firstZero = outArray.indexOf(0);
    if (firstZero > 0) {
      outArray = outArray.sublist(0, firstZero);
    }
    int paddingCount = outArray[outArray.length - 1];
    int endIndex = outArray.length - paddingCount;
    if (endIndex > 0 && endIndex <= outArray.length - 1) {
      outArray = outArray.sublist(0, endIndex);
    }
  }

  // adjust output
  if (outputType != SM4OutputMode.Array) {
    if (cryptFlag != DECRYPT) {
      // encrypt, out hex string
      return _arrayToHex(outArray);
    } else {
      // decrypt, outpuy utf8 string
      return _arrayToUtf8(outArray);
    }
  } else {
    return outArray;
  }
}

/// 👮 Type Prosecutor
///
/// 🔍 Check incoming parameters in case of data errors
void _typeProsecutor({
  required String key,
  required String mode,
  String padding = SM4PaddingMode.PKCS7,
  dynamic iv,
}) {
  if (key.length != 32) {
    throw Exception('wrong key! nedd 128 bits. string length 32');
  }

  // only PKCS5, PKCS5, NONE
  if (padding != SM4PaddingMode.PKCS5 &&
      padding != SM4PaddingMode.PKCS7 &&
      padding != SM4PaddingMode.NONE) {
    throw Exception('wrong padding type');
  }

  // cbc mode need iv
  if (mode == SM4CryptoMode.CBC) {
    if (iv != null) {
      if (iv is! String && iv is! List<int>) {
        throw Exception('Wrong iv type, ! Expected String or List<int>');
      }
    } else {
      throw Exception('Using CBC mode, but IV is missing');
    }
  }
}

// /// auto add 0x00
List<int> _autoAddZero(List<int> list) {
  /// supplementary array
  List<int> supplementList = List.filled(16, 0x00);

  /// complete list
  List<int> completeList = [...list, ...supplementList].sublist(0, 16);
  return completeList;
}

/// 🔐 Sm4 crypot
class SM4 {
  /// 🔑 create hex key
  ///
  /// If there are not enough 128 bits, it will be automatically added,
  /// and if it exceeds 128 bits, it will be cut
  static String createHexKey({
    required String key,
    autoPushZero = true,
  }) {
    List<int> keyList = _utf8ToArray(key);

    if (autoPushZero) {
      if (keyList.length < 128 / 8) {
        keyList = _autoAddZero(keyList);
      }
      if (keyList.length > 128 / 8) {
        keyList = keyList.sublist(0, 16);
      }
    }
    return _arrayToHex(keyList);
  }

  /// encrypt data, output hex string
  ///
  /// ```dart
  ///  // create hex key (string to hex list)
  ///  // If there are not enough 128 bits, it will be automatically added,
  ///  // and if it exceeds 128 bits, it will be cut
  ///  String key = SM4.createHexKey(key: '123456');
  ///  // base useing (defalut ECB)
  ///  String encryptData = Sm4.encrypt(data: data, key: key,);
  /// // CBC mode, need iv
  ///  String encryptData = Sm4.encrypt(
  ///     data: msg,
  ///     key: key,
  ///     mode: Sm4CryptoMode.CBC,
  ///     iv: 'fedcba98765432100123456789abcdef',
  ///  );
  /// ```
  static String encrypt({
    required String data,
    required String key,
    String mode = SM4CryptoMode.ECB,
    String padding = SM4PaddingMode.PKCS7,
    String? iv,
  }) {
    // Check out the parameters
    _typeProsecutor(
      key: key,
      mode: mode,
      padding: padding,
      iv: iv,
    );

    // hex data
    List<int> dataHexList = _utf8ToArray(data);
    List<int> keyHexList = _hexToArray(key);
    List<int>? ivHexList;

    if (iv != null) {
      ivHexList = _hexToArray(iv);
    }

    String cryptionData = _sm4Factory(
      data: dataHexList,
      key: keyHexList,
      mode: mode,
      padding: padding,
      iv: ivHexList,
      cryptFlag: ENCRYPT,
    );

    return cryptionData.toUpperCase();
  }

  /// encrypt data, output hex array
  ///
  /// ```dart
  /// // base useing (defalut ECB)
  /// List<int> encryptData = Sm4.encrypt(data: data, key: key);
  /// // CBC mode, need iv
  /// List<int> encryptData = Sm4.encrypt(
  ///     data: msg,
  ///     key: testKey,
  ///     mode: Sm4CryptoMode.CBC,
  ///     iv: 'fedcba98765432100123456789abcdef',
  /// );
  /// ```
  static List<int> encryptOutArray({
    required String data,
    required String key,
    String mode = SM4CryptoMode.ECB,
    String padding = SM4PaddingMode.PKCS7,
    String? iv,
  }) {
    // Check out the parameters
    _typeProsecutor(
      key: key,
      mode: mode,
      padding: padding,
      iv: iv,
    );

    // hex data
    List<int> dataHexList = _utf8ToArray(data);
    List<int> keyHexList = _hexToArray(key);
    List<int>? ivHexList;

    if (iv != null) {
      ivHexList = _hexToArray(iv);
    }

    List<int> encryptData = _sm4Factory(
      data: dataHexList,
      key: keyHexList,
      mode: mode,
      padding: padding,
      iv: ivHexList,
      cryptFlag: ENCRYPT,
      outputType: SM4OutputMode.Array,
    );

    return encryptData;
  }

  /// decrypt data, output string
  static String decrypt({
    required String data,
    required String key,
    String mode = SM4CryptoMode.ECB,
    String padding = SM4PaddingMode.PKCS7,
    String? iv,
  }) {
    // Check out the parameters
    _typeProsecutor(
      key: key,
      mode: mode,
      padding: padding,
      iv: iv,
    );

    List<int> dataHexList = _hexToArray(data);
    List<int> keyHexList = _hexToArray(key);
    List<int>? ivHexList;

    if (iv != null) {
      ivHexList = _hexToArray(iv);
    }

    String decryptData = _sm4Factory(
      data: dataHexList,
      key: keyHexList,
      mode: mode,
      padding: padding,
      iv: ivHexList,
      cryptFlag: DECRYPT,
    );

    return decryptData;
  }

  /// decrypt data, output hex array
  static List<int> decryptOutArray() {
    return [1];
  }
}
