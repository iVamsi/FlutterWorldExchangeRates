import 'dart:convert';

import 'package:flutterworldexchangerates/models/currency_entity_response.dart';
import 'package:flutterworldexchangerates/models/currency_response.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/services.dart' show rootBundle;

class CurrencyService {
  final Client client = Client();
  //TODO: Remove the key from the code and check if there is a way to fetch it from config
  final String currencyUrl = "http://data.fixer.io/api/latest?access_key=5e75ca4496c13e02f32e7fbf0f9c3707";

  Future<CurrencyResponse> fetchLatestCurrencies() async {
    final response = await client.get(currencyUrl);
    print(currencyUrl);

    final json = jsonDecode(response.body);
    print(json);

    return CurrencyResponse.fromJson(json);
  }

  Future<CurrencyEntityResponse> fetchLocalCurrenciesFromFile() async {

    String jsonString = await rootBundle.loadString('assets/currencies.json');
    final json = jsonDecode(jsonString);

    return CurrencyEntityResponse.fromJson(json);
  }

}