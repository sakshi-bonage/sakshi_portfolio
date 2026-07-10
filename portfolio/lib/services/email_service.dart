import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _apiUrl =
      'https://api.emailjs.com/api/v1.0/email/send';

  static String get _serviceId => dotenv.env['EMAILJS_SERVICE_ID'] ?? '';
  static String get _templateId => dotenv.env['EMAILJS_TEMPLATE_ID'] ?? '';
  static String get _publicKey => dotenv.env['EMAILJS_PUBLIC_KEY'] ?? '';

  /// Sends an email via EmailJS REST API.
  /// Template variables must match exactly: {{name}}, {{email}}, {{message}}
  static Future<void> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _publicKey,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'message': message,
          'reply_to': email,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('EmailJS error ${response.statusCode}: ${response.body}');
    }
  }
}
