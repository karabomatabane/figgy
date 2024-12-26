part of 'gif_bloc.dart';

sealed class GifEvent extends Equatable {
  const GifEvent();

  @override
  List<Object> get props => [];
}

final class SearchGifs extends GifEvent {
  final GifClient provider;
  final String query;

  const SearchGifs({
    required this.query,
    required this.provider,
  });

  @override
  List<Object> get props => [query];
}
