import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void getData() async {

    //await callToAPI();
    if(context.mounted){
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(data)))
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(child: Text(". . .")),
        ),
      ),
    );
  }
}