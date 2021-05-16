import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/services/authentication_service.dart';
import 'package:movies/services/database.dart';
import 'package:movies/services/main_scaffold_navigation.dart';
import 'package:movies/ui/add_edit_movie_view.dart';
import 'package:movies/ui/movie_detail_view.dart';
import 'package:movies/ui/movie_list.dart';
import 'package:movies/ui/sign_in_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return BlocProvider (
       create: (context) => MainScaffoldNavigation.instance,
         child: MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        Provider<Database>(
          create: (_) => Database(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Movies',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          iconTheme: IconThemeData(color: Colors.white)
        ),
        home: AuthenticationWrapper(),
      )
     )
     );
  }
}

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScaffoldNavigation, MainScaffoldState>(
        builder: (context, state) {
          if (state is MainPage) {
            return MovieList();
          }
          if (state is MovieDetailScreen) {
            return MovieDetailView(state.movie);
          }
          return Center(child: Text("Invalid state"));
        }

    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    return user == null? SignInPage(): MainScaffold();
  }
}