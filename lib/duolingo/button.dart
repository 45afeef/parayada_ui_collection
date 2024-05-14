import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinycolor2/tinycolor2.dart';

class DuolingoButton extends StatefulWidget {
  final Color color; // Button color
  final Widget child; // Button text
  final Offset elevation; // Shadow elevation
  final Offset clickedStateElevation; // Shadow elevation
  final Color? shadowColor; // Shadow color
  final VoidCallback onPressed; // Tap callback
  final VoidCallback? onLongPress; // Long press callback
  final Curve curve; // Animation curve
  final BorderRadiusGeometry radius; // Border Radius
  final BoxBorder? border; //
  final double borderWidth;
  final EdgeInsetsGeometry? padding;

  const DuolingoButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.color = Colors.yellow,
    this.elevation = const Offset(0, 8),
    this.clickedStateElevation = const Offset(0, 0),
    this.shadowColor, // = const Color(0xFF1B5E20),
    this.curve = Curves.easeInOut,
    this.radius = const BorderRadius.all(Radius.circular(16)),
    this.border,
    this.borderWidth = 0,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
  });

  @override
  State<DuolingoButton> createState() => _DuolingoState();
}

class _DuolingoState extends State<DuolingoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _buttonAnimation;
  late Animation<Offset> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 100), // Set the duration of the animation
    );

    // Define the Tween objects with the beginning and ending values
    _buttonAnimation = Tween<Offset>(
      begin: widget.clickedStateElevation,
      end: widget.elevation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve, // Use the same curve for consistency
    ));

    _shadowAnimation = Tween<Offset>(
      begin: widget.elevation,
      end: widget.clickedStateElevation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve, // Use the same curve for consistency
    ));

    // Add a listener to call setState whenever the animation value changes
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        HapticFeedback.heavyImpact();
        _controller.forward();
      }, // Start the animation
      onTapUp: (_) {
        _controller.reverse(); // Reverse the animation
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      onLongPress: widget.onLongPress,
      child: Transform.translate(
        offset: _buttonAnimation.value, // Use the animated value for the offset
        child: AnimatedContainer(
          duration: Duration
              .zero, // Set duration to zero since we're using the controller
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: widget.radius,
            border: widget.border ??
                Border.all(
                  color: TinyColor.fromColor(widget.color).lighten(15).color,
                  width: widget.borderWidth,
                ),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ??
                    TinyColor.fromColor(widget.color).darken(25).color,
                offset: _shadowAnimation
                    .value, // Use the animated value for the shadow offset
              ),
            ],
          ),
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }
}
