import 'package:flutterworldexchangerates/models/currency_response.dart';

abstract class Repository {
  Stream<List<Currency>> fetchLatestCurrencies();
}