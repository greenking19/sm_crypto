import 'dart:convert';
import 'package:convert/convert.dart';

/// SM Helper🔧
///
/// <li> utf8ToBytes
/// <li> bytesToHex
class SmHelper {
  /// Utf8 string to Bytes
  ///
  /// ```dart
  /// //Example
  ///  List<int> bytes = SmHelper.utf8ToBytes('@Greenking19');
  /// ```
  static List<int> utf8ToBytes(String string) {
    return utf8.encode(string);
  }

  /// Bytes To Utf8
  ///
  /// ```dart
  /// // Example
  /// List<int> bytes = SmHelper.utf8ToBytes('@Greenking19');
  /// String string = SmHelper.bytesToUtf8(bytes);
  /// ```
  static String bytesToUtf8(List<int> bytes) {
    return utf8.decode(bytes);
  }

  /// Bytes To Hex string
  ///
  /// ```dart
  /// //Example
  /// List<int> bytes = SmHelper.utf8ToBytes('@Greenking19');
  /// String hexString = SmHelper.bytesToHex(bytes);
  /// ```
  static String bytesToHex(List<int> list) {
    String hexString = list
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

  /// Hex String To  Hex Bytes
  ///
  /// ```dart
  /// List<int> bytes = SmHelper.hexToBytes(hexString);
  /// ```
  static List<int> hexToHexBytes(String string) {
    List<int> intList = [];
    int len = string.length;

    for (int i = 0; i < len; i += 2) {
      int startIndex = i;
      int endIndex = i + 2;

      String strItem = string.substring(startIndex, endIndex);

      int? _hex = int.tryParse(strItem, radix: 16);

      if (_hex != null) {
        intList.add(_hex);
      }
    }
    return hex.decode(string);
  }

  /// Hex Bytes to Hex String
  static String hexbytesToHexString(List<int> bytes) {
    String hexString = bytes
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
}
