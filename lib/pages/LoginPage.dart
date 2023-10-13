import 'package:flutter/material.dart';
import 'package:mobile_app/models/DTO/UserLoginDTO.dart';
import 'package:mobile_app/pages/LoadingPage.dart';
import 'package:mobile_app/services/Themes.dart';
import 'package:mobile_app/services/UserService.dart';
import 'MainPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showErrorMessage = false;
  bool showRegisterMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Themes.darkBlue, Themes.lightBlue],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 330,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Login:"),
                TextFormField(
                  controller: _loginController,
                ),
                const SizedBox(height: 20),
                const Text("Hasło:"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                ),
                ElevatedButton(
                  onPressed: () async {
                    showErrorMessage = false;
                    showRegisterMessage = false;
                    UserService userService = UserService();

                    UserLoginDTO userLogin = UserLoginDTO(
                        login: _loginController.text,
                        password: _passwordController.text);

                    await userService.getUserData(userLogin);
                    if (UserService.loggedIn) {
                      if (context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Loading()));
                      }
                    }else{
                      setState(() {
                        showErrorMessage = true;
                      });
                    }
                  },
                  child: const Text("Zaloguj"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showErrorMessage = false;
                    showRegisterMessage = false;
                    UserService userService = UserService();

                    UserLoginDTO userRegister = UserLoginDTO(
                        login: _loginController.text,
                        password: _passwordController.text);

                    await userService.registerUser(userRegister);
                    if (UserService.registered) {
                      setState(() {
                        showRegisterMessage = true;
                      });
                    }
                  },
                  child: const Text("Zarejestruj"),
                ),
                if(showErrorMessage)
                  const Text("Nieprawidłowy login lub hasło!", style: TextStyle(color: Colors.red)),
                if(showRegisterMessage)
                  const Text("Pomyślnie zarejestrowano. Możesz się teraz zalogować",
                      style: TextStyle(color: Colors.green)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
