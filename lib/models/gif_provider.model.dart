import '../util/constant.dart';
import 'gif.model.dart';

class GifProvider {
  final String apiKey;
  final String apiKeyQuery;
  final String baseUrl;
  final String searchPath;
  GifClient client;


  GifProvider._({
    required this.client,
    required this.apiKey,
    required this.apiKeyQuery,
    required this.baseUrl,
    required this.searchPath,
  });

  factory GifProvider(GifClient client) {
    switch (client) {
      case GifClient.tenor:
        return GifProvider._(
          client: client,
          apiKey: Const.tenorApiKey,
          apiKeyQuery: Const.tenorApiKeyQuery,
          baseUrl: Const.tenorBaseUrl,
          searchPath: Const.tenorSearchPath,
        );
      case GifClient.giphy:
        return GifProvider._(
          client: client,
          apiKey: Const.giphyApiKey,
          apiKeyQuery: Const.giphyApiKeyQuery,
          baseUrl: Const.giphyBaseUrl,
          searchPath: Const.giphySearchPath,
        );
    }
  }

  List<Gif> parseJson(String body) {
    switch (client) {
      case GifClient.tenor:
        return Gif.parseTenorJson(body);
      case GifClient.giphy:
        return Gif.parseGiphyJson(body);
    }
  }
}