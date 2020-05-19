import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:worldexchangerates/constants.dart';
import 'package:worldexchangerates/models/currency_entity.dart';
import 'package:worldexchangerates/services/currency_database.dart';
import 'package:worldexchangerates/services/currency_service.dart';
import 'package:worldexchangerates/services/repository.dart';

class RepositoryImpl implements Repository {
  final CurrencyService _currencyService;
  final CurrencyDatabase _currencyDatabase;

  Map<String, CurrencyEntity> _cachedCurrencies;

  RepositoryImpl(this._currencyService, this._currencyDatabase);

  @override
  Stream<List<CurrencyEntity>> fetchLatestCurrencies(
      bool isFavoriteCurrenciesList) {
    return Stream.fromFuture(_fetchFromRemoteOrLocal(isFavoriteCurrenciesList));
  }

  Future<List<CurrencyEntity>> _fetchFromRemoteOrLocal(
      bool isFavoriteCurrenciesList) async {
    if (_cachedCurrencies != null && _cachedCurrencies.isNotEmpty && _getDuration(await _getSavedTimeFromPreferences()) < 0) {
      print("Fetching currencies from Cache");
      return _getCachedCurrencies(isFavoriteCurrenciesList);
    }

    final currencies = await _currencyDatabase.getCurrenciesFromDatabase();
    
    if (currencies.isNotEmpty && _getDuration(await _getSavedTimeFromPreferences()) < 0) {
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

      // save current time to preferences
      _saveCurrentTimeToPreferences();

      return getCurrencies(updatedCurrencyList, isFavoriteCurrenciesList);
    }
  }

  List<CurrencyEntity> getCurrencies(
      List<CurrencyEntity> currencyList, bool isFavoriteCurrenciesList) {
    if (isFavoriteCurrenciesList) {
      return currencyList
          .where((currency) =>
              currency.currencyFavorite == Constants.FAVORITE_CURRENCY_YES)
          .toList();
    }
    return currencyList;
  }

  List<CurrencyEntity> _getCachedCurrencies(bool isFavoriteCurrenciesList) {
    final currencyList = _cachedCurrencies.values.toList();
    currencyList.sort(
        (a, b) => (a.currencyId as String).compareTo(b.currencyId as String));
    return getCurrencies(currencyList, isFavoriteCurrenciesList);
  }

  void _refreshCache(List<CurrencyEntity> currencyList) {
    _cachedCurrencies?.clear();
    currencyList.forEach((currency) {
      _cacheAndPerform(currency, (currency) {});
    });
  }

  CurrencyEntity _cacheCurrency(CurrencyEntity currencyEntity) {
    final cachedCurrency = CurrencyEntity(
        currencyId: currencyEntity.currencyId,
        currencyName: currencyEntity.currencyName,
        currencyValue: currencyEntity.currencyValue,
        currencyFavorite: currencyEntity.currencyFavorite,
        baseCurrency: currencyEntity.baseCurrency);

    // Create if cache map doesn't exist
    if (_cachedCurrencies == null) {
      _cachedCurrencies = HashMap();
    }

    _cachedCurrencies?.putIfAbsent(
        cachedCurrency.currencyId, () => cachedCurrency);
    return cachedCurrency;
  }

  Function perform = (currencyEntity) => Object;

  void _cacheAndPerform(CurrencyEntity currencyEntity, Function perform) {
    final cachedTask = _cacheCurrency(currencyEntity);
    perform(cachedTask);
  }

  Future<void> _saveCurrentTimeToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.PREF_CURRENT_TIME, DateTime.now().toString());
  }

  Future<String> _getSavedTimeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedTime = prefs.getString(Constants.PREF_CURRENT_TIME) ?? DateTime.now().toString();
    print("Saved time: $savedTime");
    return savedTime;
  }

  int _getDuration(String prefTime) {
    var currentTimeMinus24Hours = DateTime.now().subtract(Duration(hours: Constants.REFRESH_TIME_IN_HOURS));
    int duration = currentTimeMinus24Hours.difference(DateTime.tryParse(prefTime)).inSeconds;
    print("Duration: $duration");
    return duration;
  }

  @override
  Stream<bool> updateCurrencyInDatabase(CurrencyEntity currencyEntity) {
    // clear cache so that next time cache will be updated with values from database
    _cachedCurrencies.clear();
    return Stream.fromFuture(_currencyDatabase.updateCurrency(currencyEntity));
  }
}
