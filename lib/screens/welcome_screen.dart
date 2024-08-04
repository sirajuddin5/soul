import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:soul/screens/chat_screen.dart';
import 'package:soul/screens/login_screen.dart';
import 'package:soul/screens/registration_screen.dart';
import '../components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  bool isMe =false;

  void checkUser() async{
    if (await FirebaseAuth.instance.currentUser != null) {
      Navigator.pushNamed(context, ChatScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();


    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      // upperBound: 100,
    );

    // // curved animation
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    controller.forward();

    animation =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);

    controller.addListener(
      () {
        setState(() {});
        print(animation.value);
      },
    );

    // // forward and backward animation
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1);
    //   }else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    checkUser();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red.withOpacity(controller.value),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'log',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  ' Soul',
                  // '${controller.value.toInt()}%',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              textOnButton: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                //TODO Go to login screen.
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              textOnButton: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
                //TODO Go to login screen.
              },
            ),
          ],
        ),
      ),
    );
  }
}
