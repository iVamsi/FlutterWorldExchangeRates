import 'package:flutter/material.dart';
import 'package:flutterworldexchangerates/routes/all_currencies_screen_route.dart';
import 'package:flutterworldexchangerates/routes/currency_converter_screen_route.dart';
import 'package:flutterworldexchangerates/routes/favorite_currencies_screen_route.dart';
import 'package:flutterworldexchangerates/routes/home_screen_route.dart';
import 'package:flutterworldexchangerates/screens/all_currencies_screen.dart';
import 'package:flutterworldexchangerates/screens/currency_converter_screen.dart';
import 'package:flutterworldexchangerates/screens/favorite_currencies_screen.dart';
import 'package:flutterworldexchangerates/screens/home_screen.dart';

class WorldExchangeRatesApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "World Exchange Rates",
      initialRoute: HomeScreenRoute.routeName,
      routes: {
        HomeScreenRoute.routeName : (context) => HomeScreen(),
        AllCurrenciesScreenRoute.routeName : (context) => AllCurrenciesScreen(),
        FavoriteCurrenciesScreenRoute.routeName : (context) => FavoriteCurrenciesScreen(),
        CurrencyConverterScreenRoute.routeName : (context) => CurrencyConverterScreen()
      },
    );
  }
}