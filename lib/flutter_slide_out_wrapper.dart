library flutter_slide_out_wrapper;

import 'package:flutter/material.dart';

class AutoSlideOutAnimationWrapper extends StatefulWidget {
  final Widget child;
  final int duration; //milliSeconds
  final bool isFromLeftToRight;

  const AutoSlideOutAnimationWrapper(
      {Key key,
      @required this.child,
      this.duration,
      this.isFromLeftToRight = false})
      : super(key: key);
  @override
  _AutoSlideOutAnimationWrapperState createState() =>
      _AutoSlideOutAnimationWrapperState();
}

class _AutoSlideOutAnimationWrapperState
    extends State<AutoSlideOutAnimationWrapper> with TickerProviderStateMixin {
  bool isAnimated = false;
  Animation<double> slideAnimation;
  AnimationController slideController;

  Animation<double> scaleAnimation;
  AnimationController scaleController;

  @override
  void initState() {
    super.initState();
    slideController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    slideAnimation =
        Tween<double>(begin: 0, end: widget.isFromLeftToRight ? 1 : -1)
            .animate(slideController);

    scaleController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    scaleAnimation = Tween<double>(begin: 1, end: 0).animate(scaleController);

    scaleController.forward();
    slideController.forward();
    Future.delayed(Duration(milliseconds: widget.duration), () {
      setState(() {
        isAnimated = true;
      });
    });
  }

  @override
  void dispose() {
    slideController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      child: SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: scaleAnimation,
          child: isAnimated ? Container() : widget.child),
      builder: (context, child) {
        return Container(
          transform: Matrix4.identity()
            ..translate(
                slideAnimation.value * MediaQuery.of(context).size.width, 0),
          child: child,
        );
      },
    );
  }
}
