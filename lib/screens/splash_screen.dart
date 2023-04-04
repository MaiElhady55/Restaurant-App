import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network(
          'https://themesnap.com/wp-content/uploads/2016/09/146.png'),

      backgroundColor: Colors.white,
      logoWidth:150 ,
      loadingTextPadding: EdgeInsets.symmetric(vertical: 15),
      showLoader: true,
      loaderColor: Theme.of(context).primaryColor,
      loadingText: Text("Loading..."),
      durationInSeconds: 4,
    );
  }
}