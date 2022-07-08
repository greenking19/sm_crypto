import 'package:sm_crypto/src/sm_helper.dart';

/// Rotate left
List<int> _rotl(List<int> x, int n) {
  List<int> result = List.filled(x.length, 0);
  int a = n ~/ 8;
  int b = n % 8;
  for (int i = 0; i < x.length; i++) {
    int len = x.length;
    result[i] = ((x[(i + a) % len] << b) & 0xff) +
        ((x[(i + a + 1) % len] >>> (8 - b)) & 0xff);
  }
  return result;
}

/// binary XOR
List<int> _xor(List<int> x, List<int> y) {
  List<int> result = List.filled(x.length, 0);
  for (int i = x.length - 1; i >= 0; i--) {
    result[i] = (x[i] ^ y[i]) & 0xff;
  }
  return result;
}

/// binary AND operation
List<int> _and(List<int> x, List<int> y) {
  List<int> result = List.filled(x.length, 0);

  for (int i = x.length - 1; i >= 0; i--) {
    result[i] = x[i] & y[i] & 0xff;
  }
  return result;
}

/// binary OR operation
List<int> _or(List<int> x, List<int> y) {
  List<int> result = List.filled(x.length, 0);
  for (int i = x.length - 1; i >= 0; i--) {
    result[i] = (x[i] | y[i]) & 0xff;
  }
  return result;
}

/// binary ADD operation
List<int> _add(List<int> x, List<int> y) {
  List<int> result = List.filled(x.length, 0);
  int temp = 0;
  for (int i = x.length - 1; i >= 0; i--) {
    int sum = x[i] + y[i] + temp;
    if (sum > 0xff) {
      temp = 1;
      result[i] = sum & 0xff;
    } else {
      temp = 0;
      result[i] = sum & 0xff;
    }
  }
  return result;
}

/// binary NOT operation
List<int> _not(List<int> x) {
  List<int> result = List.filled(x.length, 0);
  for (int i = x.length - 1; i >= 0; i--) {
    result[i] = ~x[i] & 0xff;
  }
  return result;
}

// P1(X) = X xor (X <<< 9) xor (X <<< 17)
List<int> _P0(List<int> x) {
  return _xor(_xor(x, _rotl(x, 9)), _rotl(x, 17));
}

// P1(X) = X xor (X <<< 15) xor (X <<< 23)
List<int> _P1(List<int> x) {
  return _xor(_xor(x, _rotl(x, 15)), _rotl(x, 23));
}

/// bool FF operation
List<int> _FF(
  List<int> x,
  List<int> y,
  List<int> z,
  int j,
) {
  List<int> result = [];
  if (j >= 0 && j <= 15) {
    result = _xor(_xor(x, y), z);
  } else {
    result = _or(_or(_and(x, y), _and(x, z)), _and(y, z));
  }
  return result;
}

/// bool GG operation
List<int> _GG(
  List<int> x,
  List<int> y,
  List<int> z,
  int j,
) {
  List<int> result = [];
  if (j >= 0 && j <= 15) {
    result = _xor(_xor(x, y), z);
  } else {
    result = _or(_and(x, y), _and(_not(x), z));
  }
  return result;
}

/// compression function
List<int> _CF(List<int> V, List<int> Bi) {
  // message extension
  List<List<int>> W = [];
  List<List<int>> M = [];

  // Group M is divided into 16, W0, W1, ..., W15
  for (int i = 0; i < 16; i++) {
    int start = i * 4;
    W.add(Bi.sublist(start, start + 4));
  }
  // W16 ～ W67：W[j] <- P1(W[j−16] xor W[j−9] xor (W[j−3] <<< 15)) xor (W[j−13] <<< 7) xor W[j−6]
  for (int j = 16; j < 68; j++) {
    List<int> _list = _xor(
        _xor(_P1(_xor(_xor(W[j - 16], W[j - 9]), _rotl(W[j - 3], 15))),
            _rotl(W[j - 13], 7)),
        W[j - 6]);
    W.add(_list);
  }

  // W′0 ～ W′63：W′[j] = W[j] xor W[j+4]
  for (int j = 0; j < 64; j++) {
    M.add(_xor(W[j], W[j + 4]));
  }

  // compression
  List<int> T1 = [0x79, 0xcc, 0x45, 0x19];
  List<int> T2 = [0x7a, 0x87, 0x9d, 0x8a];

  // byte register
  List<int> A = V.sublist(0, 4);
  List<int> B = V.sublist(4, 8);
  List<int> C = V.sublist(8, 12);
  List<int> D = V.sublist(12, 16);
  List<int> E = V.sublist(16, 20);
  List<int> F = V.sublist(20, 24);
  List<int> G = V.sublist(24, 28);
  List<int> H = V.sublist(28, 32);

  // Intermediate variables
  late List<int> SS1;
  late List<int> SS2;
  late List<int> TT1;
  late List<int> TT2;

  for (int j = 0; j < 64; j++) {
    List<int> T = j >= 0 && j <= 15 ? T1 : T2;
    SS1 = _rotl(_add(_add(_rotl(A, 12), E), _rotl(T, j)), 7);
    SS2 = _xor(SS1, _rotl(A, 12));

    TT1 = _add(_add(_add(_FF(A, B, C, j), D), SS2), M[j]);
    TT2 = _add(_add(_add(_GG(E, F, G, j), H), SS1), W[j]);

    D = C;
    C = _rotl(B, 9);
    B = A;
    A = TT1;
    H = G;
    G = _rotl(F, 19);
    F = E;
    E = _P0(TT2);
  }

  List<int> _containsList =
      [A, B, C, D, E, F, G, H].expand((element) => element).toList();

  List<int> result = _xor(_containsList, V);
  return result;
}

/// 🔒 encrypt
List<int> _encrypt(List<int> list) {
  /// filling
  int len = list.length * 8;

  int k = len % 512;
  k = k >= 448 ? 512 - (k % 448) - 1 : 448 - k - 1;

  // filling
  List<int> kArr = List.filled((k - 7) ~/ 8, 0);

  List<int> lenArr = List.filled(8, 0);

  String lenString = len.toRadixString(2);
  for (int i = 7; i >= 0; i--) {
    if (lenString.length > 8) {
      int start = lenString.length - 8;
      lenArr[i] = int.parse(lenString.substring(start), radix: 2);
      lenString = lenString.substring(0, start);
    } else if (lenString.length > 0) {
      lenArr[i] = int.parse(lenString, radix: 2);
      lenString = '';
    } else {
      lenArr[i] = 0;
    }
  }

  List<int> m = [
    list,
    [0x80],
    kArr,
    lenArr
  ].expand((element) => element).toList();

  int n = m.length ~/ 64;

  List<int> V = [
    0x73,
    0x80,
    0x16,
    0x6f,
    0x49,
    0x14,
    0xb2,
    0xb9,
    0x17,
    0x24,
    0x42,
    0xd7,
    0xda,
    0x8a,
    0x06,
    0x00,
    0xa9,
    0x6f,
    0x30,
    0xbc,
    0x16,
    0x31,
    0x38,
    0xaa,
    0xe3,
    0x8d,
    0xee,
    0x4d,
    0xb0,
    0xfb,
    0x0e,
    0x4e
  ];

  for (int i = 0; i < n; i++) {
    int start = 64 * i;
    List<int> B = m.sublist(start, start + 64);
    V = _CF(V, B);
  }

  return V;
}

class SM3 {
  /// encrypt data type of String, output hex string
  ///
  /// ```
  /// String encryptData = SM3.encryptString('@GreenKing19');
  /// ```
  static String encryptString(String data) {
    List<int> _utf8list = SmHelper.utf8ToBytes(data);
    List<int> _list = _encrypt(_utf8list);
    String result = SmHelper.bytesToHex(_list);
    return result.toUpperCase();
  }

  /// encrypt data type of List<int>, output hex string
  ///
  /// ```
  /// List<int> bytes = SmHelper.utf8ToBytes('@GreenKing19');
  /// String encryptData = SM3.encryptBytes(bytes);
  /// ```
  static String encryptBytes(List<int> data) {
    List<int> _list = _encrypt(data);
    String result = SmHelper.bytesToHex(_list);
    return result.toUpperCase();
  }
}
