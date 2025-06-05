import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateExample(String word) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:11434/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': 'gemma',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an AI that provides example sentences.',
          },
          {
            'role': 'user',
            'content': 'Generate an example sentence using "$word".',
          },
        ],
      }),
    );

    print('Raw response:\n${response.body}');

    List<String> sentences = [];
    for (var line in LineSplitter().convert(response.body)) {
      final Map<String, dynamic> jsonLine = jsonDecode(line);
      if (jsonLine.containsKey('response')) {
        sentences.add(jsonLine['response']);
      }
    }

    if (sentences.isEmpty) {
      print('Error: No valid response received');
      return 'Error generating example';
    }

    return sentences.join(); // 正確拼接句子
  } catch (e) {
    print('JSON Decode Error: $e');
    return 'Error generating example';
  }
}
