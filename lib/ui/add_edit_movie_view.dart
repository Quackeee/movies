import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/services/database.dart';
import 'package:provider/provider.dart';

class AddEditMovieView extends StatelessWidget {
  final Movie? movie;

  AddEditMovieView({this.movie});

  final formKey = GlobalKey<FormState>(debugLabel: "addMovieFormKey");

  @override
  Widget build(BuildContext context) {

    final titleController = TextEditingController();
    final directorController = TextEditingController();
    final yearController = TextEditingController();
    final descriptionController = TextEditingController();

    if (movie != null) {
      titleController.text = movie!.title;
      directorController.text = movie!.director;
      yearController.text = movie!.year?.toString() ?? "";
      descriptionController.text = movie!.description;
    }

    Movie readMovie() {
      var yearText = yearController.text.trim();

      return Movie(
          title: titleController.text.trim(),
          director: directorController.text.trim(),
          year: yearText.isEmpty? null: int.parse(yearText),
          description: descriptionController.text.trim()
      );
    }

      final node = FocusScope.of(context);

      final yearRegex = RegExp("[1-9][0-9][0-9][0-9]");

      return Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: "Title"),
                    onEditingComplete: () => node.nextFocus(),
                    validator: (String? text) {
                      if (text == null || text.trim().isEmpty) return "Title is required.";
                    },
                  ),
                  TextFormField(
                    controller: directorController,
                    decoration: InputDecoration(labelText: "Director"),
                    onEditingComplete: () => node.nextFocus(),
                  ),
                  TextFormField(
                    controller: yearController,
                    decoration: InputDecoration(labelText: "Year"),
                    keyboardType: TextInputType.number,
                    onEditingComplete: () => node.nextFocus(),
                    validator: (String? text) {
                      if (text == null || text.isEmpty) return null;
                      if (!yearRegex.hasMatch(text))
                        return "Provide a valid year or leave blank";
                      var year = int.parse(text);
                      if (year > 2100 || year < 1800) {
                        return "Are you sure that's the correct year?";
                      }
                    },
                  ),
                  Divider(),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder()
                    ),
                  )
                ]
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (movie == null) {
                var movie = readMovie();
                context.read<Database>().saveMovie(movie, context.read<User?>()!);
              } else {
                movie!.update(
                    readMovie()
                );
              }
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("There have been some errors")
                  )
              );
            }
          },
          child: Icon(Icons.check),
        ),
      );
    }
  }