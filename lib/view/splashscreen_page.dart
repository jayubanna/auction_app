import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TweenAnimationBuilder(
            duration: const Duration(seconds: 3),
            onEnd: () {
              Get.offNamed("home_page");
            },
            tween: Tween(begin: 0.0, end: 160.0),
            builder: (context, value, child) {
              return Center(
                child: Image.network(
                  "https://seeklogo.com/images/O/online-shopping-logo-365B76F5DC-seeklogo.com.png",
                  height: 200,
                ),
              );
            }));
  }
}
