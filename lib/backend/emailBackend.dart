import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailSender {
  final subject = "Typster odzyskiwanie hasła";
  final serviceId = 'service_xfkhg2a';
  final templateId = 'template_ej0nd4i';
  final userId = 'yisqhNNfvkg6QY3vq';

  Future sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'subject': subject,
          'user_email': email,
          'nick': name,
          'message': message,
        },
      }),
    );
  }
}
