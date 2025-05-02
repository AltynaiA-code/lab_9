import 'package:flutter/material.dart';
import 'package:lab_/pages/first_page.dart';
import 'package:lab_/pages/fourth_page.dart';
import 'package:lab_/pages/second_page.dart';
import 'package:lab_/pages/third_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FirstPage(),
    SecondPage(),
    ThirdPage(),
    FourthPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '🏠'),
          BottomNavigationBarItem(icon: Icon(Icons.document_scanner), label: '📄'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '⚙️'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '👤'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

