// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuolingoIconButton extends StatefulWidget {
  final Color color; // Button color
  final Widget child; // Button text
  final Offset elevation; // Shadow elevation
  final Offset clickedStateElevation; // Shadow elevation
  final Color shadowColor; // Shadow color
  final VoidCallback onPressed; // Tap callback
  final VoidCallback? onLongPress; // Long press callback
  final Curve curve; // Animation curve

  const DuolingoIconButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.onLongPress,
      this.color = Colors.green,
      this.elevation = const Offset(0, 8),
      this.clickedStateElevation = const Offset(0, 0),
      this.shadowColor = const Color(0xFF1B5E20),
      this.curve = Curves.easeInOut});

  @override
  State<DuolingoIconButton> createState() => _DuolingoState();
}

class _DuolingoState extends State<DuolingoIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _buttonAnimation;
  late Animation<Offset> _shadowAnimation;

  // late AudioPlayer _audioPlayer;

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

    // Initiate the audio player
    // _audioPlayer = AudioPlayer();

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
        // _audioPlayer.play(AssetSource('sounds/click_1.mp3'));
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
            // image: const DecorationImage(
            //   image: AssetImage(
            //     'assets/images/button_texture_1.png',
            //     package: 'parayada_ui_collection',
            //   ), // Replace with your texture image asset path
            //   fit: BoxFit
            //       .cover, // This should cover the entire button area without distorting the image
            // ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor,
                offset: _shadowAnimation
                    .value, // Use the animated value for the shadow offset
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
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
