import 'dart:math';
import 'flashcard_manager.dart';
import 'package:flutter/material.dart';

class FlashcardQuizScreen extends StatefulWidget {
  final FlashcardManager flashcardManager;

  FlashcardQuizScreen({required this.flashcardManager});

  @override
  _FlashcardQuizScreenState createState() => _FlashcardQuizScreenState();
}

class _FlashcardQuizScreenState extends State<FlashcardQuizScreen> {
  late Flashcard? correctCard;
  late List<Flashcard> options = [];
  int score = 0;
  int questionIndex = 0;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      generateNewQuestion();
    });
  }

  void generateNewQuestion() {
    if (widget.flashcardManager.flashcards.isEmpty) {
      setState(() {
        correctCard = null;
      });
      return;
    }

    correctCard =
        widget.flashcardManager.flashcards[Random().nextInt(
          widget.flashcardManager.flashcards.length,
        )];

    // 生成選項
    Set<Flashcard> choices = {correctCard!};
    while (choices.length < 4) {
      choices.add(
        widget.flashcardManager.flashcards[Random().nextInt(
          widget.flashcardManager.flashcards.length,
        )],
      );
    }
    options = choices.toList();
    options.shuffle();

    setState(() {});
  }

  void checkAnswer(Flashcard selectedCard) {
    if (correctCard == null) return; // 確保 correctCard 已初始化

    if (selectedCard == correctCard) {
      setState(() {
        score++;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('正確！當前分數：$score')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('錯誤！正確答案是：${correctCard?.definition ?? '未知'}')),
      );
    }

    questionIndex++;
    generateNewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('選擇題測驗')),
      body:
          correctCard == null
              ? Center(child: CircularProgressIndicator()) // 如果還沒初始化，顯示 loading
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '請選擇「${correctCard?.title ?? '未知單字'}」的正確定義：',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ...?options?.map(
                    (option) => ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      child: Text(option.definition),
                    ),
                  ),
                ],
              ),
    );
  }
}
