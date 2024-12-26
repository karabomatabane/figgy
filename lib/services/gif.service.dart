import 'package:figgy/models/gif_provider.model.dart';
import 'package:http/http.dart' as http;
import '../models/gif.model.dart';

class GifService {
  final GifClient gifClient;
  late final GifProvider provider;

  GifService({required this.gifClient}){
    provider = GifProvider(gifClient);
  }

  Future<List<Gif>> searchGifs(String query) async {
    final queryParameters = {
      'q' : query,
      provider.apiKeyQuery : provider.apiKey,
    };
    final uri = Uri.https(provider.baseUrl, provider.searchPath, queryParameters);
    print(uri);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return provider.parseJson(response.body);
    } else {
      throw Exception('Failed to load gifs');
    }
  }
}