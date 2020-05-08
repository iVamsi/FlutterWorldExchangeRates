import 'package:flutter/foundation.dart';
import 'package:flutterworldexchangerates/strings.dart';

class CurrencyEntity {
  final String currencyId;
  final String currencyName;
  final double currencyValue;
  final String currencyFavorite;
  final String baseCurrency;

  CurrencyEntity({@required this.currencyId, @required this.currencyName, @required this.currencyValue, @required this.currencyFavorite, @required this.baseCurrency});

  Map<String, dynamic> toMap() {
    return {
      Strings.KEY_COLUMN_CURRENCY_ID: currencyId,
      Strings.KEY_COLUMN_CURRENCY_NAME: currencyName,
      Strings.KEY_COLUMN_CURRENCY_VALUE: currencyValue,
      Strings.KEY_COLUMN_CURRENCY_FAVORITE: currencyFavorite,
      Strings.KEY_COLUMN_CURRENCY_BASE: baseCurrency
    };
  }

  @override
  String toString() {
    return 'Currency{id: $currencyId, name: $currencyName, value: $currencyValue, favorite: $currencyFavorite, base: $baseCurrency}';
  }
}