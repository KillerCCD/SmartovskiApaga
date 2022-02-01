import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class L10n {
  static final all = [
    const Locale('hy'),
    const Locale('ru'),
    const Locale('en'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'hy':
        return 'Hy';
        break;
      case 'ru':
        return 'Ru';
        break;
      case 'en':

      default:
        return 'En';
    }
  }
}
