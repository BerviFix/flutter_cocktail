import 'package:flutter/material.dart';

class ThemeSwitch extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const ThemeSwitch({required this.isDark, required this.onTap});
  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant ThemeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      _controller.forward(from: 0);
      setState(() => _animating = true);
      Future.delayed(
        const Duration(milliseconds: 600),
        () => setState(() => _animating = false),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_animating) return;
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final turns = _controller.value;
          return Transform.rotate(
            angle: turns * 3.14,
            child: widget.isDark
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                    child: Icon(
                      Icons.nightlight_round,
                      key: const ValueKey('moon'),
                      size: 28,
                    ),
                  )
                : Icon(
                    Icons.wb_sunny_rounded,
                    key: const ValueKey('sun'),
                    color: Colors.amber,
                    size: 28,
                  ),
          );
        },
      ),
    );
  }
}
