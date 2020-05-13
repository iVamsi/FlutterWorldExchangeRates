import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worldexchangerates/blocs/currency_list_bloc.dart';
import 'package:worldexchangerates/widgets/all_currencies_widget.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurrencyListBloc _currencyListBloc;
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    if (_currencyListBloc == null) {
      _currencyListBloc = BlocProvider.of<CurrencyListBloc>(context);
    }
    super.didChangeDependencies();
  }

  void _refreshCurrencies(bool isFavoriteCurrencyList) {
    _currencyListBloc.loadCurrencies(
        isFavoriteCurrenciesList: isFavoriteCurrencyList);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWidgetPopped() {
    setState(() {
      if (_selectedIndex == 0) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else {
        _selectedIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWidgetPopped,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('World Exchange Rates'),
        ),
        body: _buildScreen(_currencyListBloc),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              title: Text('All Currencies'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favorites'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sync),
              title: Text('Converter'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildScreen(CurrencyListBloc bloc) {
    switch (_selectedIndex) {
      case 0:
        {
          _refreshCurrencies(false);
          return AllCurrenciesWidget(bloc: bloc);
        }
        break;
      case 1:
        {
          _refreshCurrencies(true);
          return AllCurrenciesWidget(bloc: bloc);
        }
        break;
      default:
        {
          return Center(
            child: Text(
              'Under development',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        }
    }
  }
}
