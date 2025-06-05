import 'package:flutter/material.dart';
import 'flashcard_manager.dart';
import 'ollama_service.dart';

class EditFlashcardScreen extends StatefulWidget {
  final FlashcardManager flashcardManager;
  final int index;

  const EditFlashcardScreen({
    super.key,
    required this.flashcardManager,
    required this.index,
  });

  @override
  _EditFlashcardScreenState createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  late TextEditingController wordController;
  late TextEditingController definitionController;
  late TextEditingController exampleController;

  @override
  void initState() {
    super.initState();
     Future.microtask(() => _generateExamples()); // 初始化時觸發例句生成
    final flashcard = widget.flashcardManager.flashcards[widget.index];
    wordController = TextEditingController(text: flashcard.title);
    definitionController = TextEditingController(text: flashcard.definition);
    exampleController = TextEditingController(
      text: flashcard.example ?? '',
    ); // 防止 null);
  }

  @override
  void dispose() {
    wordController.dispose();
    definitionController.dispose();
    exampleController.dispose();
    super.dispose();
  }

  void _generateExamples() async {
    for (var flashcard in widget.flashcardManager.flashcards) {
      if (flashcard.example.isEmpty) {
        String example = await widget.flashcardManager.generateExample(
          flashcard.title,
        );
        if (mounted) {
          setState(() {
            flashcard.example = example; // 確保 UI 更新
          });
        }
      }
    }
  }

  // Future<void> fetchExampleSentence() async {
  //   try {
  //     String word = wordController.text.trim();
  //     if (word.isEmpty) return;
  //     String example = await ChatGPTService.generateExampleSentence(word);
  //     setState(() {
  //       exampleController.text = example;
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('編輯字卡')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: wordController,
              decoration: InputDecoration(labelText: '單字'),
            ),
            TextField(
              controller: definitionController,
              decoration: InputDecoration(labelText: '定義'),
            ),
            TextField(
              controller: exampleController,
              decoration: InputDecoration(labelText: '例句'),
              maxLines: 2,
            ),
            SizedBox(height: 16),

            // ChatGPT 調用
            // ElevatedButton(
            //   onPressed: fetchExampleSentence,
            //   child: Text('自動生成例句'),
            // ),
            ElevatedButton(
              onPressed: () async {
                String word = wordController.text;
                String example = await generateExample(word); // 呼叫本地 AI 生成例句
                setState(() {
                  exampleController.text = example; // 顯示例句
                });
              },
              child: Text('生成例句'),
            ),

            ElevatedButton(
              onPressed: () {
                final updatedCard = Flashcard(
                  title: wordController.text,
                  definition: definitionController.text,
                  example: exampleController.text,
                );
                setState(() {
                  widget.flashcardManager.editFlashcard(
                    widget.index,
                    updatedCard,
                  );
                });
                Navigator.pop(context);
              },
              child: Text('儲存變更'),
            ),
          ],
        ),
      ),
    );
  }
}
