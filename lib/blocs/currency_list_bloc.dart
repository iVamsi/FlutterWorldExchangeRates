import 'dart:async';

import 'package:worldexchangerates/models/currency_entity.dart';
import 'package:worldexchangerates/services/repository.dart';
import 'package:worldexchangerates/services/result.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class CurrencyListBloc extends Bloc {
  CurrencyListBloc({this.repository});

  final Repository repository;

  final _currencyListSubject = PublishSubject<Result<List<CurrencyEntity>>>();

  Stream<Result<List<CurrencyEntity>>> get currencyListStream =>
      _currencyListSubject.stream;

  void loadCurrencies({bool isFavoriteCurrenciesList = false}) {
    repository.fetchLatestCurrencies(isFavoriteCurrenciesList).listen((currencyListStream) {
      return _currencyListSubject.add(SuccessResult(currencyListStream));
    }, onError: (error) {
      _currencyListSubject.addError(ErrorResult(error));
      print("fetchCurrencyList - $error");
    });
  }

  void dispose() {
    _currencyListSubject.close();
  }
}
