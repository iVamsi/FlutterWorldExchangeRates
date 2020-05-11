import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterworldexchangerates/widgets/all_currencies_widget.dart';
import 'package:flutterworldexchangerates/widgets/favorite_currencies_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
        body: _buildScreen(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Business'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('School'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        {
          return AllCurrenciesWidget(isFavoriteCurrenciesList: false);
        }
        break;
      case 1:
        {
          //TODO: Find out a way to just call AllCurrenciesWidget(isFavoriteCurrenciesList: true)
          // currently it's not refreshing widget if above one is used.
          return FavoriteCurrenciesWidget(isFavoriteCurrenciesList: true);
        }
        break;
      default:
        {
          return Text(
            'Index 2: School',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          );
        }
    }
  }
}
