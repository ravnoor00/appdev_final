import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

class Match extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const Match({Key? key, required this.data}) : super(key: key);

  @override
  State<Match> createState() => _Match();
}

class _Match extends State<Match> {
  final List<GridItem> _gridItems = [];
  GridItem? _previousSelectedItem;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int numberIncorrect = 0;

  @override
  void initState() {
    super.initState();
    _prepareGridItems();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _prepareGridItems() {
    for (var item in widget.data) {
      _gridItems.add(GridItem(
          type: GridItemType.question,
          content: item['question'],
          isMatched: false,
          notSelected: true));
      _gridItems.add(GridItem(
          type: GridItemType.answer,
          content: item['answer'],
          isMatched: false,
          notSelected: true));
    }
    _gridItems.shuffle(Random());
  }

  bool _isMatch(GridItem a, GridItem b) {
    return (a.type == GridItemType.question &&
            b.type == GridItemType.answer &&
            widget.data.any((item) =>
                item['question'] == a.content &&
                item['answer'] == b.content)) ||
        (a.type == GridItemType.answer &&
            b.type == GridItemType.question &&
            widget.data.any((item) =>
                item['question'] == b.content && item['answer'] == a.content));
  }

  int _getScore() {
    return _gridItems.where((item) => item.isMatched).length ~/ 2;
  }

  @override
  Widget build(BuildContext context) {
    bool isGameOver = _gridItems.every((item) => item.isMatched);

    if (isGameOver) {
      _timer?.cancel();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Match Game')),
      body: isGameOver
          ? _GameOver(
              incorrect: numberIncorrect,
              score: _getScore(),
              timeElapsed: _elapsedSeconds,
              onTryAgain: () {
                setState(() {
                  _gridItems.clear();
                  _prepareGridItems();
                  _elapsedSeconds = 0;
                  _startTimer();
                });
              },
              onReturnHome: () {
                Navigator.pop(context);
              },
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Score: ${_getScore()}"),
                      Text("Time: $_elapsedSeconds"),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildGridView(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: _gridItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (BuildContext context, int index) {
        GridItem item = _gridItems[index];
        return InkWell(
          onTap: () => _handleItemClick(item),
          child: Visibility(
            visible: !item.isMatched,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: item.correct
                      ? Colors.green.shade100
                      : (item.incorrect
                          ? Colors.red.shade100
                          : (item.notSelected
                              ? Colors.lightBlue
                              : Colors.white)),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(
                  item.content,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                )),
          ),
        );
      },
    );
  }

  void _handleItemClick(GridItem item) {
    if (item.isMatched || !item.notSelected) {
      return;
    }

    if (_previousSelectedItem == null) {
      setState(() {
        _previousSelectedItem = item;
        item.notSelected = false;
      });
    } else {
      if (_isMatch(_previousSelectedItem!, item)) {
        setState(() {
          item.correct = true;
          _previousSelectedItem!.correct = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            item.isMatched = true;
            _previousSelectedItem!.isMatched = true;
            item.correct = false;
            _previousSelectedItem!.correct = false;
            _previousSelectedItem = null;
          });
        });
      } else {
        setState(() {
          item.notSelected = false;
          _previousSelectedItem!.notSelected = false;
          item.incorrect = true;
          _previousSelectedItem!.incorrect = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            numberIncorrect += 1;
            item.notSelected = true;
            _previousSelectedItem!.notSelected = true;
            item.incorrect = false;
            _previousSelectedItem!.incorrect = false;
            _previousSelectedItem = null;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

enum GridItemType { question, answer }

class GridItem {
  GridItemType type;
  String content;
  bool isMatched;
  bool notSelected;
  bool incorrect;
  bool correct;

  GridItem({
    required this.type,
    required this.content,
    required this.isMatched,
    required this.notSelected,
    this.incorrect = false,
    this.correct = false, // Add this line
  });
}

class _GameOver extends StatelessWidget {
  final int score;
  final int timeElapsed;
  final int incorrect;
  final VoidCallback onTryAgain;
  final VoidCallback onReturnHome;

  const _GameOver({
    Key? key,
    required this.score,
    required this.timeElapsed,
    required this.incorrect,
    required this.onTryAgain,
    required this.onReturnHome,
  }) : super(key: key);

  String giveSuggestion(int correct, int incorrect) {
    if (incorrect > correct) {
      return 'You definitely need more help, try again';
    } else if (incorrect == correct) {
      return 'You got the same incorrect as correct, try to practice on more time';
    }
    return 'Good Job, you are getting the hang of this!';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Score: $score'),
          Text('Number incorrect: $incorrect'),
          Text('Time: $timeElapsed'),
          Text(giveSuggestion(score, incorrect)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTryAgain,
            child: const Text('Try Again'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onReturnHome,
            child: const Text('Return to Home'),
          ),
        ],
      ),
    );
  }
}
