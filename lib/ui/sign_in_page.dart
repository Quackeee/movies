import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movies/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:movies/extensions/email_validation.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool newAccount = false;

  void _triggerNewAccount() {
    setState(() {
      newAccount = !newAccount;
    });
  }

  final formKey = GlobalKey<FormState>(debugLabel: "loginForm");

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    final buttonText = newAccount ? "Sign up" : "Sign in";
    final signInOrUp = newAccount
        ? () => context.read<AuthenticationService>().signUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        : () => context.read<AuthenticationService>().signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
    final noteText1 = newAccount
        ? "Already have an account? "
        : "Don't have an account yet? ";
    final noteText2 = newAccount ? "Sign in!" : "Sign up!";

    return Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
        ),
        body: Padding(
            padding: EdgeInsets.all(50),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (String? value) {
                      if (value == null) return "Email is required";
                      var email = value.toString();
                      if (email.isEmpty) return "Email is required";
                      if (!email.isEmail) return "Invalid email";
                    },
                    onEditingComplete: () => node.nextFocus(),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (String? value) {
                      if (value == null || value.toString().trim().isEmpty)
                        return "Password is required";
                      if (value.trim().length < 6) return "Pasword too short";
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var error = await signInOrUp();
                        if (error != null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(error)));
                        }
                      }
                    },
                    child: Text(buttonText),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: noteText1,
                        style: Theme.of(context).textTheme.bodyText2),
                    TextSpan(
                        text: noteText2,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _triggerNewAccount())
                  ]))
                ],
              ),
            )));
  }
}
