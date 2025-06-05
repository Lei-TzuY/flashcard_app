import 'flashcard_manager.dart';
import 'package:flutter/material.dart';

class AddFlashcardScreen extends StatelessWidget {
  final FlashcardManager flashcardManager;

  // 建構子，接收 flashcardManager 參數
  AddFlashcardScreen({super.key, required this.flashcardManager});

  // 控制標題和定義欄位的文字輸入
  final TextEditingController titleController = TextEditingController();
  final TextEditingController definitionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Scaffold 是 Flutter 的基礎 UI 框架，提供了標題列、內容區域等
    return Scaffold(
      appBar: AppBar(title: Text('新增字卡')), // 顯示標題
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // 設定內邊距
        child: Column(
          children: [
            // 用來輸入字卡標題的文字框
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '字卡正面'),
            ),
            // 用來輸入字卡定義的文字框
            TextField(
              controller: definitionController,
              decoration: InputDecoration(labelText: '字卡反面'),
            ),
            // 儲存字卡的按鈕
            ElevatedButton(
              onPressed: () {
                // 創建一個新的字卡
                final newCard = Flashcard(
                  title: titleController.text,
                  definition: definitionController.text,
                );
                // 使用 flashcardManager 新增字卡
                flashcardManager.addFlashcard(newCard);
                // 返回上一頁
                Navigator.pop(context);
              },
              child: Text('儲存字卡'),
            ),
          ],
        ),
      ),
    );
  }
}
