import 'dart:collection';

import 'package:flutterworldexchangerates/constants.dart';
import 'package:flutterworldexchangerates/models/currency_entity.dart';
import 'package:flutterworldexchangerates/services/currency_database.dart';
import 'package:flutterworldexchangerates/services/currency_service.dart';
import 'package:flutterworldexchangerates/services/repository.dart';

class RepositoryImpl implements Repository {
  final CurrencyService _currencyService;
  final CurrencyDatabase _currencyDatabase;

  Map<String, CurrencyEntity> _cachedCurrencies;

  RepositoryImpl(this._currencyService, this._currencyDatabase);

  @override
  Stream<List<CurrencyEntity>> fetchLatestCurrencies(bool isFavoriteCurrenciesList) {
    return Stream.fromFuture(_fetchFromRemoteOrLocal(isFavoriteCurrenciesList));
  }

  Future<List<CurrencyEntity>> _fetchFromRemoteOrLocal(bool isFavoriteCurrenciesList) async {
    if (_cachedCurrencies != null) {
      print("Fetching currencies from Cache");
      return _getCachedCurrencies(isFavoriteCurrenciesList);
    }

    final currencies = await _currencyDatabase.getCurrenciesFromDatabase();

    if (currencies.isNotEmpty) {
      print("Fetching currencies from database");
      // refresh cache
      _refreshCache(currencies);
      return getCurrencies(currencies, isFavoriteCurrenciesList);
    } else {
      print("Fetching currencies from remote");
      final currencyEntitiesList = await _currencyService
          .fetchLocalCurrenciesFromFile()
          .then((response) => response.currencyEntitiesList);

      final updatedCurrencyList =
          await _currencyService.fetchLatestCurrencies().then((response) {
        final currencyList = response.getCurrencyList(response.currencyRates);

        return currencyEntitiesList.map((currency) {
          final updatedCurrency = currencyList
              .firstWhere((item) => item.currencyId == currency.currencyId);
          return CurrencyEntity(
              currencyId: currency.currencyId,
              currencyName: currency.currencyName,
              currencyFavorite: currency.currencyFavorite,
              baseCurrency: currency.baseCurrency,
              currencyValue: updatedCurrency.currencyValue);
        }).toList();
      });

      // refresh cache
      _refreshCache(updatedCurrencyList);

      // save to db
      updatedCurrencyList.forEach((currency) {
        _currencyDatabase.insertCurrency(currency);
      });

      return getCurrencies(updatedCurrencyList, isFavoriteCurrenciesList);
    }
  }

  List<CurrencyEntity> getCurrencies(List<CurrencyEntity> currencyList, bool isFavoriteCurrenciesList) {
    if (isFavoriteCurrenciesList) {
      return currencyList.where((currency) => currency.currencyFavorite == Constants.BASE_CURRENCY_YES).toList();
    }
    return currencyList;
  }

  List<CurrencyEntity> _getCachedCurrencies(bool isFavoriteCurrenciesList) {
    final currencyList = _cachedCurrencies.values.toList();
    currencyList.sort(
      (a, b) => (a.currencyId as String).compareTo(b.currencyId as String)
    );
    return getCurrencies(currencyList, isFavoriteCurrenciesList);
  }

  void _refreshCache(List<CurrencyEntity> currencyList) {
    _cachedCurrencies?.clear();
    currencyList.forEach((currency) {
      _cacheAndPerform(currency, (currency) {});
    });
  }

  CurrencyEntity _cacheCurrency(CurrencyEntity currencyEntity) {
    final cachedCurrency = CurrencyEntity(currencyId: currencyEntity.currencyId,
    currencyName: currencyEntity.currencyName,
    currencyValue: currencyEntity.currencyValue,
    currencyFavorite: currencyEntity.currencyFavorite,
    baseCurrency: currencyEntity.baseCurrency
    );

    // Create if cache map doesn't exist
    if (_cachedCurrencies == null) {
      _cachedCurrencies = HashMap();
    }

    _cachedCurrencies?.putIfAbsent(cachedCurrency.currencyId, () => cachedCurrency);
    return cachedCurrency;
  }

  Function perform = (currencyEntity) => Object;

  void _cacheAndPerform(CurrencyEntity currencyEntity, Function perform) {
    final cachedTask = _cacheCurrency(currencyEntity);
    perform(cachedTask);
  }

}
