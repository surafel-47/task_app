import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteApiService {
  static const String _quotesUrl = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en';

  // Fetch a random quote from the API and return it as a Map<String, dynamic>
  static Future<Map<String, dynamic>> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(_quotesUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final String quoteText = data['quoteText'] ?? 'No quote text available';
        final String quoteAuthor = data['quoteAuthor']?.isNotEmpty ?? false ? data['quoteAuthor'] : 'Unknown author';
        final String senderName = data['senderName'] ?? '';

        return {
          'quoteText': quoteText,
          'quoteAuthor': quoteAuthor,
          'senderName': senderName,
          'quoteLink': data['quoteLink'] ?? '',
        };
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Unable to fetch quote: $e');
    }
  }
}
