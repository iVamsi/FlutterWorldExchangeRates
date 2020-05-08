import 'package:flutterworldexchangerates/models/currency_entity.dart';
import 'package:flutterworldexchangerates/models/currency_response.dart';

abstract class Repository {
  Stream<List<Currency>> fetchLatestCurrencies();

  //TODO: Remove all below methods from repository once RepositoryImpl is updated
  Future<void> insertCurrency(CurrencyEntity currency);
  Future<List<CurrencyEntity>> getCurrenciesFromDatabase();
  Future<void> updateCurrency(CurrencyEntity currencyEntity);
  Future<void> deleteCurrency(int id);
}