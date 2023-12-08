import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/models/DTO/UserLoginDTO.dart';
import 'package:mobile_app/pages/LoadingPage.dart';
import 'package:mobile_app/services/Config.dart';
import 'package:mobile_app/services/Themes.dart';
import 'package:mobile_app/services/UserService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  bool showErrorMessage = false;
  bool showRegisterMessage = false;
  bool buttonsEnabled = true;


  @override
  Widget build(BuildContext context) {
    ipController.text = Config.ip;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showDialog(
          builder: (context) => Dialog(
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Adres ip", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: ipController,
                    ),
                    ElevatedButton(onPressed: (){
                      Config.ip = ipController.text;
                      Navigator.of(context).pop();
                    }, child: const Text("OK"))
                  ],
                ),
              ),
            ),
          ),
          context: context,
        ),
        backgroundColor: Colors.white,
        child: const Icon(Icons.settings, color: Colors.blue),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
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
            height: 355,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: Text("System zarządzania urządzeniami IoT", style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),
                Visibility(
                  visible: buttonsEnabled,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showErrorMessage = false;
                        showRegisterMessage = false;
                        buttonsEnabled = false;
                      });
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
                      } else {
                        setState(() {
                          showErrorMessage = true;
                          buttonsEnabled = true;
                        });
                      }
                    },
                    child: const Text("Zaloguj"),
                  ),
                ),
                Visibility(
                  visible: buttonsEnabled,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showErrorMessage = false;
                        showRegisterMessage = false;
                        buttonsEnabled = false;
                      });
                      UserService userService = UserService();

                      UserLoginDTO userRegister = UserLoginDTO(
                          login: _loginController.text,
                          password: _passwordController.text);

                      await userService.registerUser(userRegister);
                      if (UserService.registered) {
                        setState(() {
                          showRegisterMessage = true;
                          buttonsEnabled = true;
                        });
                      }
                    },
                    child: const Text("Zarejestruj"),
                  ),
                ),
                if (showErrorMessage)
                  const Text("Nieprawidłowy login lub hasło!",
                      style: TextStyle(color: Colors.red)),
                if (showRegisterMessage)
                  const Text(
                      "Pomyślnie zarejestrowano. Możesz się teraz zalogować",
                      style: TextStyle(color: Colors.green)),
                Visibility(
                    visible: !buttonsEnabled,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: const SpinKitRing(
                        color: Colors.blue,
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
