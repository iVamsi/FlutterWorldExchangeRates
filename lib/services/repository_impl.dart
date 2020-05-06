import 'package:flutterworldexchangerates/models/currency_response.dart';
import 'package:flutterworldexchangerates/services/currency_service.dart';
import 'package:flutterworldexchangerates/services/repository.dart';

class RepositoryImpl implements Repository {
  final CurrencyService currencyService;

  RepositoryImpl(this.currencyService);

  @override
  Stream<List<Currency>> fetchLatestCurrencies() {
    return Stream.fromFuture(currencyService.fetchLatestCurrencies())
        .map((response) => response.getCurrencyList(response.currencyRates));
  }
}
