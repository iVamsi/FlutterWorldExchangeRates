import 'package:flutter/material.dart';
import 'package:worldexchangerates/blocs/currency_list_bloc.dart';
import 'package:worldexchangerates/routes/home_screen_route.dart';
import 'package:worldexchangerates/screens/home_screen.dart';
import 'package:worldexchangerates/services/currency_database.dart';
import 'package:worldexchangerates/services/currency_service.dart';
import 'package:worldexchangerates/services/repository_impl.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      initialRoute: HomeScreenRoute.routeName,
      routes: {
        HomeScreenRoute.routeName : (context) => BlocProvider(
          child: HomeScreen(),
          bloc: _currencyListBloc
        )
      },
    );
  }
}