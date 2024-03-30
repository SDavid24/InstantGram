import 'package:flutter/material.dart';
import 'package:instantgram/views/components/animations/models/lottie_animations.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool repeat; //To repeat the animation
  final bool reverse; //To reverse the animation

  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) =>
      Lottie.asset(
        animation.fullPath,
        repeat: repeat,
        reverse: reverse,
      );
}


extension GetFUllPath on LottieAnimation{
  String get fullPath => 'assets/animations/$name.json';
}

