import 'flashcard_manager.dart';
import 'add_flashcard_screen.dart';
import 'edit_flashcard_screen.dart';
import 'flashcard_study_screen.dart';
import 'package:flutter/material.dart';
import 'flashcard_quiz_screen.dart'; // 確保有匯入測驗畫面

class FlashcardListScreen extends StatefulWidget {
  final FlashcardManager flashcardManager;

  const FlashcardListScreen({Key? key, required this.flashcardManager})
    : super(key: key);

  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('字卡列表')),
      body: ListView.builder(
        itemCount: widget.flashcardManager.flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = widget.flashcardManager.flashcards[index];
          return ListTile(
            title: Text(flashcard.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flashcard.definition),
                Text(
                  flashcard.example.isNotEmpty
                      ? '例句: ${flashcard.example}'
                      : '生成中...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditFlashcardScreen(
                              flashcardManager: widget.flashcardManager,
                              index: index,
                            ),
                      ),
                    ).then((_) => setState(() {})); // 確保 UI 會刷新
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      // 點擊刪除按鈕時刪除字卡
                      widget.flashcardManager.deleteFlashcard(index);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: () async {
                    await widget.flashcardManager.importCsv();
                    setState(() {}); // 重新整理 UI
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FlashcardStudyScreen(
                              flashcardManager: widget.flashcardManager,
                            ),
                      ),
                    );
                  },
                  child: Text('開始學習'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await widget.flashcardManager.importCsv();
                    setState(() {}); // 更新 UI
                  },
                  child: Text('匯入 CSV'),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FlashcardQuizScreen(
                        flashcardManager: widget.flashcardManager,
                      ),
                ),
              );
            },
            child: Text('開始選擇題測驗'),
          ),
          SizedBox(height: 10),

          // 新增字卡的浮動按鈕
          FloatingActionButton(
            onPressed: () {
              // 這裡是你原本的新增字卡按鈕
              // 點擊後跳轉到新增字卡畫面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AddFlashcardScreen(
                        flashcardManager: widget.flashcardManager,
                      ),
                ),
              ).then((_) => setState(() {})); // 確保 UI 會刷新
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
