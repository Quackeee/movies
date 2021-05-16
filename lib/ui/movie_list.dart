import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/authentication_service.dart';
import 'package:movies/services/main_scaffold_navigation.dart';
import 'package:movies/ui/add_edit_movie_view.dart';
import 'package:provider/provider.dart';
import 'package:movies/extensions/user_collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'movie_detail_view.dart';

class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.read<User?>();

    if (user == null)
      return Center(
        child: Text("Not logged in"),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => context.read<AuthenticationService>().signOut())
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: user.movies.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: Text("Loading..."));
            return SingleChildScrollView(
                child: ListView(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              children: snapshot.data!.docs
                  .map((doc) => Hero(
                      child: MovieListItem(Movie.fromDocument(doc)),
                      tag: doc.id))
                  .toList(),
              shrinkWrap: true,
            ));
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddEditMovieView())),
      ),
    );
  }
}

class MovieListItem extends StatelessWidget {
  final Movie movie;

  MovieListItem(this.movie);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  if (movie.director.isNotEmpty)
                    Text(
                      movie.director,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (movie.year != null)
                    Text(
                      movie.year.toString(),
                      style: Theme.of(context).textTheme.headline5,
                    )
                ],
              )
            ],
          ),
          behavior: HitTestBehavior.translucent,
          onTap: () {
            MainScaffoldNavigation.instance.add(ShowMovieDetails(movie));
          },
        ));
  }
}
