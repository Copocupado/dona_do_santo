import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<int> calculateTravelTime(String origin, String destination) async {
  final String apiKey = dotenv.env['DISTANCE_MATRIX_API_KEY']!;
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['rows'][0]['elements'][0]['status'] == 'OK') {
      final int durationInSeconds = data['rows'][0]['elements'][0]['duration']['value']; // Convert to minutes
      return durationInSeconds;
    } else {
      throw Exception('Error: ${data['rows'][0]['elements'][0]['status']}');
    }
  } else {
    throw Exception('Failed to fetch data from Distance Matrix API');
  }
}