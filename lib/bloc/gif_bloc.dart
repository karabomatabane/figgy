import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/gif.model.dart';
import '../services/gif.service.dart';

part 'gif_event.dart';

part 'gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  GifBloc() : super(GifInitial()) {
    on<SearchGifs>((event, emit) async {
      emit(GifLoading());
      try {
        final gifService = GifService(gifClient: event.provider);
        final gifs = await gifService
            .searchGifs(event.query);
          emit(GifSuccess(gifs: gifs));
      } catch (e) {
        emit(const GifFailure(message: 'Failed to fetch gifs'));
      }
    });
  }
}
