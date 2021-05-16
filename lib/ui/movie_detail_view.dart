import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/main_scaffold_navigation.dart';
import 'package:movies/ui/add_edit_movie_view.dart';
import 'package:movies/ui/movie_list.dart';
import 'package:provider/provider.dart';
import 'package:movies/extensions/user_collections.dart';

class MovieDetailView extends StatelessWidget {
  final Movie movie;

  MovieDetailView(this.movie);

  void delete() {
    movie.drop();
    MainScaffoldNavigation.instance.add(Back());
  }

  void edit(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddEditMovieView(movie: movie);
    }));
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Movies"),
              actions: [
                IconButton(icon: Icon(Icons.delete), onPressed: delete),
                IconButton(
                    icon: Icon(Icons.edit), onPressed: () => edit(context))
              ],
            ),
            body: StreamBuilder<DocumentSnapshot>(
              stream: movie.doc!.snapshots(),
              builder: (context, snap) {
                var movie =
                    snap.hasData ? Movie.fromDocument(snap.data!) : this.movie;
                return Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Hero(
                                  child: MovieListItem(movie),
                                  tag: movie.doc!.id),
                              if (movie.description.isNotEmpty)
                                Text(movie.description, textAlign: TextAlign.justify,)
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsetsDirectional.only(bottom: 10),
                            height: 40,
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(10),
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.center,
                                  width: 90,
                                  child: const Text("Not seen"),
                                ),
                                Container(
                                  alignment: AlignmentDirectional.center,
                                  width: 90,
                                  child: const Text("Seen"),
                                ),
                              ],
                              isSelected: [
                                !movie.seen,
                                movie.seen,
                              ],
                              onPressed: (i) {
                                if (i == (movie.seen ? 1 : 0)) return;
                                movie.seen = !movie.seen;
                                movie.update(movie);
                              },
                            ),
                          ),
                        )
                      ],
                    )
                );
              },
            )),
        onWillPop: () async {
          MainScaffoldNavigation.instance.add(Back());
          return false;
        });
  }
}
