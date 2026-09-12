import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.white),

        Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 0.5,
            child: const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.page),
              child: SizedBox.expand(),
            ),
          ),
        ),

        child,
      ],
    );
  }
}
