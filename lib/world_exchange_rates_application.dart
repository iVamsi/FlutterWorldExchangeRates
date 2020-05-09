import 'package:flutter/material.dart';
import 'package:flutterworldexchangerates/blocs/currency_list_bloc.dart';
import 'package:flutterworldexchangerates/routes/all_currencies_screen_route.dart';
import 'package:flutterworldexchangerates/routes/currency_converter_screen_route.dart';
import 'package:flutterworldexchangerates/routes/favorite_currencies_screen_route.dart';
import 'package:flutterworldexchangerates/routes/home_screen_route.dart';
import 'package:flutterworldexchangerates/screens/all_currencies_screen.dart';
import 'package:flutterworldexchangerates/screens/currency_converter_screen.dart';
import 'package:flutterworldexchangerates/screens/favorite_currencies_screen.dart';
import 'package:flutterworldexchangerates/screens/home_screen.dart';
import 'package:flutterworldexchangerates/services/currency_database.dart';
import 'package:flutterworldexchangerates/services/currency_service.dart';
import 'package:flutterworldexchangerates/services/repository_impl.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class WorldExchangeRatesApplication extends StatelessWidget {

  final CurrencyListBloc _currencyListBloc = CurrencyListBloc(
      repository: RepositoryImpl(CurrencyService(), CurrencyDatabase.db)
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "World Exchange Rates",
      initialRoute: HomeScreenRoute.routeName,
      routes: {
        HomeScreenRoute.routeName : (context) => BlocProvider(
          child: HomeScreen(),
          bloc: _currencyListBloc
        ),
        AllCurrenciesScreenRoute.routeName : (context) => AllCurrenciesScreen(),
        FavoriteCurrenciesScreenRoute.routeName : (context) => FavoriteCurrenciesScreen(),
        CurrencyConverterScreenRoute.routeName : (context) => CurrencyConverterScreen()
      },
    );
  }
}