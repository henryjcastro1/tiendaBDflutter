import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tienda_bd/bd/email_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailValid = true;

  Future<void> _register() async {
  try {
    if (_formKey.currentState!.validate() && _isEmailValid) {
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      print('Registering user: $username, $email');

      final response = await http.post(
        Uri.parse('http://wordlx01.open-world.com.ve/register_user.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado con éxito')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseBody['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con el servidor')),
        );
      }
    }
  } catch (e) {
    print('Error in register: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('El correo electronico ya esta registrado')),
    );
  }
}

Future<void> _validateEmail() async {
  final email = _emailController.text;
  final isEmailTaken = await EmailService.isEmailAvailable(email);
  if (isEmailTaken) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('El correo electrónico ya está registrado')),
    );
    return; // Salir de la función si el correo ya está tomado
  }
  setState(() {
    _isEmailValid = !isEmailTaken;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un correo electrónico';
                  }
                  // Expresión regular para validar un correo electrónico básico
                  RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Por favor ingresa un correo electrónico válido';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _validateEmail(),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isEmailValid ? _register : null,
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
