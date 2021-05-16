import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/models/movie.dart';

class MainScaffoldNavigation
    extends Bloc<MainScaffoldNavigationEvent, MainScaffoldState> {
  static final instance = MainScaffoldNavigation(MainPage());

  MainScaffoldNavigation(initialState) : super(initialState);

  @override
  Stream<MainScaffoldState> mapEventToState(
      MainScaffoldNavigationEvent event) async* {
    if (event is ShowMovieDetails) {
      yield MovieDetailScreen(event.movie);
    } else if (event is Back) {
      yield MainPage();
    }
  }
}

abstract class MainScaffoldState {}

class MovieDetailScreen extends MainScaffoldState {
  final Movie movie;
  MovieDetailScreen(this.movie);
}

class MainPage extends MainScaffoldState {}

abstract class MainScaffoldNavigationEvent {}

class ShowMovieDetails extends MainScaffoldNavigationEvent {
  final Movie movie;
  ShowMovieDetails(this.movie);
}

class Back extends MainScaffoldNavigationEvent {}
