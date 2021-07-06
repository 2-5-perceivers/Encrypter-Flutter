import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

class EncrypterWaves extends StatelessWidget {
  const EncrypterWaves({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        colors: ThemeProvider.of(context)!.brightness == Brightness.light
            ? [
                Colors.deepPurple[300]!,
                Colors.deepPurple[500]!,
                Colors.deepPurple[800]!,
              ]
            : [
                Colors.deepPurple[200]!,
                Colors.deepPurple[300]!,
                Colors.deepPurple[400]!,
              ],
        durations: [35000, 19440, 10800],
        heightPercentages: [0.25, 0.30, 0.35],
        blur: MaskFilter.blur(BlurStyle.solid, 4),
      ),
      size: Size(
        double.infinity,
        double.infinity,
      ),
    );
  }
}
