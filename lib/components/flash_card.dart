import 'dart:math';
import 'package:flutter/material.dart';
import 'package:makequiz/models/flashcard.dart';

class FlipCard extends StatefulWidget {
  final Flashcard flashcard;

  const FlipCard({Key? key, required this.flashcard})
      : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCard();
}

class _FlipCard extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: pi / 2),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 3 * pi / 2, end: 2 * pi),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.addListener(() {
      if (_controller.value >= 0.5 && _isFrontVisible) {
        setState(() {
          _isFrontVisible = false;
        });
      } else if (_controller.value < 0.5 && !_isFrontVisible) {
        setState(() {
          _isFrontVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!_controller.isAnimating) {
      if (_isFrontVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_animation.value),
            child: _isFrontVisible
                ? _buildCardSide(widget.flashcard.frontText)
                : _buildCardSide(widget.flashcard.backText),
          );
        },
      ),
    );
  }

  Widget _buildCardSide(String text) {
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
