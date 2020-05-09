import 'package:flutterworldexchangerates/models/currency_entity.dart';

class CurrencyEntityResponse {
  final List<CurrencyEntity> currencyEntitiesList;

  CurrencyEntityResponse({this.currencyEntitiesList});

  CurrencyEntityResponse.fromJson(List<dynamic> parsedJson)
      : currencyEntitiesList = parsedJson
            .map((currencyEntity) => CurrencyEntity.fromJson(currencyEntity))
            .toList();
}
