import 'package:flutterworldexchangerates/models/currency_entity.dart';
import 'package:flutterworldexchangerates/services/currency_database.dart';
import 'package:flutterworldexchangerates/services/currency_service.dart';
import 'package:flutterworldexchangerates/services/repository.dart';

class RepositoryImpl implements Repository {
  final CurrencyService _currencyService;
  final CurrencyDatabase _currencyDatabase;

  //TODO: Save to cache
  Map<String, CurrencyEntity> _cachedCurrencies;

  RepositoryImpl(this._currencyService, this._currencyDatabase);

  @override
  Stream<List<CurrencyEntity>> fetchLatestCurrencies() {
    return Stream.fromFuture(_fetchFromRemoteOrLocal());
  }

  Future<List<CurrencyEntity>> _fetchFromRemoteOrLocal() async {
    final currencies = await _currencyDatabase.getCurrenciesFromDatabase();

    if (currencies.isNotEmpty) {
      return currencies;
    } else {
      final currencyEntitiesList = await _currencyService
          .fetchLocalCurrenciesFromFile()
          .then((response) => response.currencyEntitiesList);

      final updatedCurrencyList =
          await _currencyService.fetchLatestCurrencies().then((response) {
        final currencyList = response.getCurrencyList(response.currencyRates);
        
        return currencyEntitiesList.map((currency) {
          final updatedCurrency = currencyList.firstWhere(
              (item) => item.currencyId == currency.currencyId);
          return CurrencyEntity(
              currencyId: currency.currencyId,
              currencyName: currency.currencyName,
              currencyFavorite: currency.currencyFavorite,
              baseCurrency: currency.baseCurrency,
              currencyValue: updatedCurrency.currencyValue);
        }).toList();
      });

      // save to db
      updatedCurrencyList.forEach((currency) {
        _currencyDatabase.insertCurrency(currency);
      });

      return updatedCurrencyList;
    }
  }
}
