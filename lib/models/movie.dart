import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  DocumentReference? doc;

  String title;
  String director;
  int? year;
  String description;
  bool seen;

  Movie({
    required this.title,
    this.director = "",
    this.year,
    this.description = "",
    this.seen = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "director": director,
      "year": year,
      "description": description,
      "seen": seen
    };
  }

  Movie.fromJson(Map<String, dynamic> json): this(
    title: json['title'],
    director: json['director'],
    year: json['year'],
    description: json['description'],
    seen: json['seen']
  );

  Movie.fromDocument(DocumentSnapshot document):
        title = document.get('title'),
        director = document.get('director'),
        year = document.get('year'),
        description = document.get('description'),
        seen = document.get("seen")
  {
    doc = document.reference;
  }

  void setId(DocumentReference id) {
    doc = id;
  }

  void drop() {
    doc?.delete();
  }

  void update(Movie newValue) {
    if (doc != null) {
      doc!.set(newValue.toJson());
      newValue.setId(doc!);
    }
  }

  @override
  String toString() {
    return "Movie[$title,$director,$year]";
  }
}