import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> createPixQRCode({
  required double transactionAmount,
  required String description,
  required String paymentMethodId,
  required String email,
  required String identificationType,
  required String number,
  required String firstName,
  required String lastName,
  required String externalReference,
}) async {
  final url = Uri.parse('https://us-central1-dona-do-santo-ujhc0y.cloudfunctions.net/createPixQRCode');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'transactionAmount': transactionAmount,
      'description': description,
      'paymentMethodId': paymentMethodId,
      'email': email,
      'identificationType': identificationType,
      'number': number,
      'firstName': firstName,
      'lastName': lastName,
      'externalReference': externalReference,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Erro ao criar o QR code: ${response.statusCode}');
  }
}