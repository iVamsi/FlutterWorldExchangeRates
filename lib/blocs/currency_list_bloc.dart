import 'dart:async';

import 'package:flutterworldexchangerates/models/currency_response.dart';
import 'package:flutterworldexchangerates/services/repository.dart';

class CurrencyListBloc {
  CurrencyListBloc(this._repository);

  final Repository _repository;

  final _currencyStreamController = StreamController<CurrencyListState>();

  Stream<CurrencyListState> get currencyList =>
      _currencyStreamController.stream;

  void loadCurrencies() {
    _repository.fetchLatestCurrencies().listen((currencyList) {
      return _currencyStreamController.sink
          .add(CurrencyListDataState(currencyList));
    }, onError: (error) {
      _currencyStreamController.sink.addError(CurrencyListErrorState(error));
      print("fetchTriviaQuestions - $error");
    });
  }

  void dispose() {
    _currencyStreamController.close();
  }
}

class CurrencyListState {}

class CurrencyListLoadingState extends CurrencyListState {}

class CurrencyListErrorState extends CurrencyListState {
  CurrencyListErrorState(this.error);

  Object error;
}

class CurrencyListDataState extends CurrencyListState {
  CurrencyListDataState(this.currencies);

  List<Currency> currencies;
}
