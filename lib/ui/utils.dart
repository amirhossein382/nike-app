import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();

extension PriceLabel on int {
  String get withPriceLabel => '$seperateByComma تومان ';
  String get seperateByComma{
    final numberFloat = NumberFormat.decimalPattern();
    return numberFloat.format(this);
  }
}
