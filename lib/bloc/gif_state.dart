part of 'gif_bloc.dart';

sealed class GifState extends Equatable {
  const GifState();
}

final class GifInitial extends GifState {
  @override
  List<Object> get props => [];
}

final class GifLoading extends GifState {
  @override
  List<Object> get props => [];
}

final class GifFailure extends GifState {
  final String message;

  const GifFailure({required this.message});

  @override
  List<Object> get props => [];
}

final class GifSuccess extends GifState {
  final List<Gif> gifs;

  const GifSuccess({required this.gifs});

  @override
  List<Object> get props => [gifs];
}