import 'package:flutter/material.dart';

class AnimatedMagnifier extends StatefulWidget {
  final double size;
  final String assetPath;
  final bool enableRotate;

  const AnimatedMagnifier({
    Key? key,
    this.size = 56,
    this.assetPath = 'assets/magnifier.png',
    this.enableRotate = true,
  }) : super(key: key);

  @override
  State<AnimatedMagnifier> createState() => _AnimatedMagnifierState();
}

class _AnimatedMagnifierState extends State<AnimatedMagnifier>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..repeat(reverse: true);

    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(curved);
    _glow = Tween<double>(begin: 0.10, end: 0.25).animate(curved);

    _rotate = Tween<double>(begin: -0.03, end: 0.03).animate(curved);
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
      builder: (context, _) {
        final angle = widget.enableRotate ? _rotate.value : 0.0;

        return Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(_glow.value),
                    blurRadius: 18,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
