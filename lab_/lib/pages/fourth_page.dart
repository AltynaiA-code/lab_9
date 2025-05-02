import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  late String fullName, email, phone;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'Не указано';
      email = prefs.getString('email') ?? 'Не указано';
      phone = prefs.getString('phone') ?? 'Не указано';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ФИО: $fullName', style: TextStyle(fontSize: 18)),
          Text('Email: $email', style: TextStyle(fontSize: 18)),
          Text('Телефон: $phone', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}