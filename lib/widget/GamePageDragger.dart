import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class PageDragger extends StatefulWidget {
  final bool canDragLeftToRight;
  final bool canDragRightToLeft;

  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger({
    this.canDragLeftToRight,
    this.canDragRightToLeft,
    this.slideUpdateStream,
  });

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSTITION_PX = 200.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;

      if (dx > 0 && widget.canDragRightToLeft) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0 && widget.canDragLeftToRight) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSTITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }
      widget.slideUpdateStream.add(
          new SlideUpdate(UpdateType.dragging, slideDirection, slidePercent));
    }
  }

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(new SlideUpdate(
      UpdateType.doneDragging,
      SlideDirection.none,
      0.0,
    ));

    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        onDragStart(details);
      },
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class SlideUpdate {
  final updateType;
  final direction;
  final slidePercent;

  SlideUpdate(this.updateType, this.direction, this.slidePercent);
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;

      final slideRemaining = 1.0 - slidePercent;

      duration = new Duration(
          milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round());
    } else {
      endSlidePercent = 0.0;
      duration = new Duration(
          milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    completionAnimationController =
        new AnimationController(duration: duration, vsync: vsync)
          ..addListener(() {
            slidePercent = lerpDouble(startSlidePercent, endSlidePercent,
                completionAnimationController.value);

            slideUpdateStream.add(new SlideUpdate(
              UpdateType.animating,
              slideDirection,
              slidePercent,
            ));
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream.add(new SlideUpdate(
                UpdateType.doneAnimating,
                slideDirection,
                endSlidePercent,
              ));
            }
          });
  }

  run() {
    completionAnimationController.forward(from: 0.0);
  }

  dispose() {
    completionAnimationController.dispose();
  }
}

enum TransitionGoal {
  open,
  close,
}
