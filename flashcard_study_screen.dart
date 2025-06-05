import 'flashcard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';  // 匯入語音播放插件

class FlashcardStudyScreen extends StatefulWidget {
  final FlashcardManager flashcardManager;

  const FlashcardStudyScreen({super.key, required this.flashcardManager});

  @override
  _FlashcardStudyScreenState createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int currentIndex = 0;
  bool showDefinition = false;
  final FlutterTts flutterTts = FlutterTts(); // 初始化語音引擎

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US"); // 設定語言為英文
  }

  void nextCard() {
    setState(() {
      showDefinition = false;
      if (currentIndex < widget.flashcardManager.flashcards.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // 重新開始
      }
      _speak(); // 當切換字卡時，播放語音
    });
  }

  // 播放語音
  void _speak() async {
    String text = showDefinition
        ? widget.flashcardManager.flashcards[currentIndex].definition
        : widget.flashcardManager.flashcards[currentIndex].title;

    await flutterTts.speak(text); // 播放文字語音
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcardManager.flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('學習字卡')),
        body: Center(child: Text('沒有可學習的字卡')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('學習字卡')),
      body: GestureDetector(
        onTap: () {
          setState(() {
            showDefinition = !showDefinition;
          });
          _speak(); // 點擊後播放語音
        },
        child: Dismissible(
          key: ValueKey(currentIndex),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              // 左滑 -> 稍後再複習
              widget.flashcardManager.flashcards.add(
                  widget.flashcardManager.flashcards[currentIndex]);
            }
            nextCard();
          },
          child: Center(
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  showDefinition
                      ? widget.flashcardManager.flashcards[currentIndex].definition
                      : widget.flashcardManager.flashcards[currentIndex].title,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
