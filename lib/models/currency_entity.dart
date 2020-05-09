import 'package:flutter/foundation.dart';
import 'package:flutterworldexchangerates/strings.dart';

class CurrencyEntity {
  final currencyId;
  final currencyName;
  final currencyValue;
  final currencyFavorite;
  final baseCurrency;

  CurrencyEntity(
      {@required this.currencyId,
      @required this.currencyName,
      @required this.currencyValue,
      @required this.currencyFavorite,
      @required this.baseCurrency});

  CurrencyEntity.fromJson(Map<String, dynamic> parsedJson)
      : currencyId = parsedJson['currencyId'],
        currencyName = parsedJson['currencyName'],
        currencyValue = parsedJson['currencyValue'],
        currencyFavorite = parsedJson['currencyFavorite'],
        baseCurrency = parsedJson['baseCurrency'];

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
