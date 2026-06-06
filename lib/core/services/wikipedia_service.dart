import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/chronicle/widgets/article_card.dart';

class WikipediaService {
  static const String _baseUrl =
      'https://en.wikipedia.org/api/rest_v1/feed/onthisday';

  Future<Map<String, List<Article>>> fetchOnThisDay(int month, int day) async {
    final monthStr = month.toString().padLeft(2, '0');
    final dayStr = day.toString().padLeft(2, '0');
    final url = Uri.parse('$_baseUrl/all/$monthStr/$dayStr');

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'ChronicleApp/1.0 (contact: info@chronicle.app)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        final selected = _parseArticles(data['selected']);
        final births = _parseArticles(data['births']);
        final deaths = _parseArticles(data['deaths']);
        final events = _parseArticles(data['events']);

        return {
          'featured': selected.isNotEmpty
              ? selected
              : (events.isNotEmpty ? [events.first] : []),
          'events': events,
          'births': births,
          'deaths': deaths,
        };
      } else {
        throw Exception(
          'Failed to load data from Wikipedia: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Return empty lists on error
      return {'featured': [], 'events': [], 'births': [], 'deaths': []};
    }
  }

  Future<Map<String, dynamic>?> fetchPageSummary(String title) async {
    final encodedTitle = Uri.encodeComponent(title);
    final url = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/page/summary/$encodedTitle',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'ChronicleApp/1.0 (contact: info@chronicle.app)',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {
      // Fallback to null
    }
    return null;
  }

  Future<String?> fetchPageExtract(String title) async {
    final url = Uri.https('en.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'prop': 'extracts',
      'explaintext': '1',
      'exsectionformat': 'plain',
      'redirects': '1',
      'format': 'json',
      'formatversion': '2',
      'origin': '*',
      'titles': title,
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'ChronicleApp/1.0 (contact: info@chronicle.app)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final pages = data['query']?['pages'] as List<dynamic>?;
        if (pages == null || pages.isEmpty) return null;

        final extract = pages.first['extract'] as String?;
        if (extract == null || extract.trim().isEmpty) return null;
        return extract;
      }
    } catch (_) {
      // Fallback to summary content.
    }
    return null;
  }

  List<Article> _parseArticles(dynamic list) {
    if (list == null || list is! List) return [];

    final articles = <Article>[];
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;

      final text = item['text'] as String? ?? '';
      final yearInt = item['year'] as int? ?? 0;
      final pages = item['pages'] as List? ?? [];
      if (pages.isEmpty) continue;

      String id = '';
      String title = '';
      String? imageUrl;

      if (pages.isNotEmpty) {
        final firstPage = pages.first as Map<String, dynamic>;
        id =
            firstPage['title'] as String? ??
            firstPage['wikibase_item'] as String? ??
            '';
        title =
            firstPage['titles']?['normalized'] as String? ??
            firstPage['title'] as String? ??
            '';
        imageUrl =
            firstPage['originalimage']?['source'] as String? ??
            firstPage['thumbnail']?['source'] as String?;
      }

      if (id.isEmpty) {
        id = yearInt.toString() + text.hashCode.toString();
      }
      if (title.isEmpty) {
        title = text.split(',').first;
      }

      articles.add(
        Article(
          id: id,
          year: yearInt.toString(),
          title: title,
          excerpt: text,
          imageUrl: imageUrl,
        ),
      );
    }
    return articles;
  }
}
