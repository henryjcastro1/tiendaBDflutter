import 'package:flutter/material.dart';
import 'login_register_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginRegisterScreen()),
            );
          },
          child: Text('Ingresar'),
        ),
      ),
    );
  }
}
