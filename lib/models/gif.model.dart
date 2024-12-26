import 'dart:convert';

class Gif {
  final String id;
  final String title;
  final String url;
  final double height;
  final double width;
  final GifClient source;

  Gif({
    required this.id,
    required this.title,
    required this.url,
    required this.height,
    required this.width,
    required this.source,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      id: json['id'],
      title: json['title'],
      url: json['images']['fixed_height']['url'],
      height: double.parse(json['images']['fixed_height']['height']),
      width: double.parse(json['images']['fixed_height']['width']),
      source: GifClient.giphy,
    );
  }

  factory Gif.fromTenorJson(Map<String, dynamic> json) {
    return Gif(
      id: json['id'],
      title: json['title'],
      url: json['media_formats']['gif']['url'],
      height: json['media_formats']['gif']['dims'][1] * 1.0,
      width: json['media_formats']['gif']['dims'][0] * 1.0,
      source: GifClient.tenor,
    );
  }

  static List<Gif> parseGiphyJson(String body) {
    try {
      List<dynamic> data = jsonDecode(body)["data"];
      List<Gif> gifs = data.map((dynamic item) => Gif.fromJson(item))
          .toList();
      return gifs;
    } catch (e) {
      print(e);
      throw Exception('Failed to load gifs');
    }
  }

  static List<Gif> parseTenorJson(String body) {
    try {
      List<dynamic> data = jsonDecode(body)["results"];
      print('test: ${data[0]['media_formats']['gif']}');
      List<Gif> gifs = data.map((dynamic item) => Gif.fromTenorJson(item))
          .toList();
      return gifs;
    } catch (e) {
      print(e);
      throw Exception('Failed to load gifs');
    }
  }
}

enum GifClient {
  tenor,
  giphy,
}