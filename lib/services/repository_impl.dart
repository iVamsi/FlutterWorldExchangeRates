import 'package:flutterworldexchangerates/models/currency_entity.dart';
import 'package:flutterworldexchangerates/models/currency_response.dart';
import 'package:flutterworldexchangerates/services/currency_database.dart';
import 'package:flutterworldexchangerates/services/currency_service.dart';
import 'package:flutterworldexchangerates/services/repository.dart';

class RepositoryImpl implements Repository {
  final CurrencyService _currencyService;
  final CurrencyDatabase _currencyDatabase;

  RepositoryImpl(this._currencyService, this._currencyDatabase);

  @override
  Stream<List<Currency>> fetchLatestCurrencies() {
    return Stream.fromFuture(_currencyService.fetchLatestCurrencies())
        .map((response) => response.getCurrencyList(response.currencyRates));
  }

  @override
  Future<void> deleteCurrency(int id) {
    return _currencyDatabase.deleteCurrency(id);
  }

  @override
  Future<List<CurrencyEntity>> getCurrenciesFromDatabase() {
    return _currencyDatabase.getCurrenciesFromDatabase();
  }

  @override
  Future<void> insertCurrency(CurrencyEntity currency) {
    return _currencyDatabase.insertCurrency(currency);
  }

  @override
  Future<void> updateCurrency(CurrencyEntity currencyEntity) {
    return _currencyDatabase.updateCurrency(currencyEntity);
  }
}
