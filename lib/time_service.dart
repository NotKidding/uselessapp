import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';

class TimeService {
  static const baseUrl = "https://api.api-ninjas.com/v1/worldtime";
  final String apiKey;

  TimeService(this.apiKey);

  Future<String> getTime(String timezone) async {
    final response = await http.get(
      Uri.parse('$baseUrl?timezone=$timezone'),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['datetime'] ?? 'Time not found';
    } else {
      throw Exception("Failed to load time data");
    }
  }
}

void main() async {
  final apiKey = dotenv.env['TIME_API_KEY']; 
  final timeService = TimeService(apiKey!);

  // List of example timezones
  final List<String> timezones = [
    'America/New_York',
    'Europe/London',
    'Asia/Tokyo',
    'Australia/Sydney',
    'Africa/Cairo',
    'America/Los_Angeles',
    'Europe/Berlin',
    'Asia/Kolkata',
  ];

  // Get a random timezone
  final randomIndex = Random().nextInt(timezones.length);
  final randomTimezone = timezones[randomIndex];

  try {
    // Get the current time for the random timezone
    final time = await timeService.getTime(randomTimezone);

    // Store the results in variables
    String timezone = randomTimezone;

  //   // Print the results
  //   print('Current time in $timezone: $time');
   } catch (e) {
     print(e);
   }
}
