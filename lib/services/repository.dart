import 'package:worldexchangerates/models/currency_entity.dart';

abstract class Repository {
  Stream<List<CurrencyEntity>> fetchLatestCurrencies(bool isFavoriteCurrenciesList);
}