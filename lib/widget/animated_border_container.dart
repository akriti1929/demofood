import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedBorderContainer extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final EdgeInsets? padding;
  final Color? color;

  const AnimatedBorderContainer({super.key, required this.child, required this.isLoading, this.padding, this.color});

  @override
  State<AnimatedBorderContainer> createState() => _AnimatedBorderContainerState();
}

class _AnimatedBorderContainerState extends State<AnimatedBorderContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: widget.isLoading ? 2 : 0, color: Colors.transparent),
            gradient: widget.isLoading
                ? SweepGradient(
                    startAngle: 0.0,
                    endAngle: 6.28,
                    colors: [
                      AppThemeData.primary300,
                      AppThemeData.accent300,
                      AppThemeData.blue300,
                    ],
                    stops: const [0.0, 0.25, 0.5],
                    transform: GradientRotation(_controller.value * 6.28),
                  )
                : null,
          ),
          child: Container(
            padding: widget.padding ?? EdgeInsets.zero,
            decoration: BoxDecoration(
              color: widget.color ?? AppThemeData.lynch25,
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
