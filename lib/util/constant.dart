import 'package:flutter_dotenv/flutter_dotenv.dart';

class Const {
  /// The Giphy API.
  static const String giphyApiKeyQuery = 'api_key';
  static String giphyApiKey = dotenv.env['GIPHY_API_KEY'] ?? 'your_api_key';
  static const String giphyBaseUrl = 'api.giphy.com';
  static const String giphySearchPath = '/v1/gifs/search';

  /// The Tenor API.
  static const String tenorApiKeyQuery = 'key';
  static String tenorApiKey = dotenv.env['TENOR_API_KEY'] ?? 'your_api_key';
  static const String tenorBaseUrl ='tenor.googleapis.com';
  static const String tenorSearchPath = '/v2/search';
}