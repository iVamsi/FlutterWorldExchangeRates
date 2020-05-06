import 'package:flutter/material.dart';
import 'package:flutterworldexchangerates/services/repository.dart';
import 'package:flutterworldexchangerates/widgets/all_currencies_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({@required this.repository});

  final Repository repository;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        {
          return AllCurrenciesWidget(widget.repository);
        }
        break;
      case 1:
        {
          return Text(
            'Index 1: Business',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          );
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
