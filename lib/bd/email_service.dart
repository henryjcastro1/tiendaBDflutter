import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailService {
  static Future<bool> isEmailAvailable(String email) async {
    final response = await http.post(
      Uri.parse('http://wordlx01.open-world.com.ve/register_user.php'), // Reemplazar con la URL real de su punto final
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['available'] ?? false; // Verifique la clave "available", establezca el valor predeterminado en falso si falta
    } else {
      throw Exception('Error al verificar el correo electrónico');
    }
  }
}

