// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/extensions/user_collections.dart';

class Database {
  Future saveMovie(Movie movie, User user) async {
    var doc = await user.movies
        .add(movie.toJson());

    movie.setId(doc);
  }
}