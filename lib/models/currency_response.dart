import 'package:flutter/foundation.dart';

class CurrencyResponse {
  final currencyList = <Currency>[];

  final currencyRates;

  CurrencyResponse.fromJson(Map<String, dynamic> parsedJson)
      : currencyRates = (parsedJson["rates"] as Map);

  List<Currency> getCurrencyList(final Map currencyRates) {
    currencyRates?.forEach((currencyId, currencyValue) => currencyList
        .add(Currency(currencyId: currencyId, currencyValue: currencyValue)));
    return currencyList;
  }
}

class Currency {
  final currencyId;
  final currencyValue;

  Currency({@required this.currencyId, @required this.currencyValue});
}
