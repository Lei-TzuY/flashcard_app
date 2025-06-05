import './flashcard_manager.dart';
import './flashcard_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; //Hive 在 Flutter 上的擴充版本，用來初始化 Hive，讓它能在 Flutter 環境運作。

// 主要是負責應用程式的啟動，通常不會直接放 UI 控件

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 確保 Flutter 正確初始化
  await Hive.initFlutter(); // 初始化 Hive
  Hive.registerAdapter(FlashcardAdapter()); // 註冊 Flashcard 類別
  await Hive.openBox<Flashcard>('flashcards'); // 開啟存字卡的 box

  final flashcardManager = FlashcardManager(); // 創建 flashcard 管理器
  runApp(MyApp(flashcardManager: flashcardManager)); // 啟動應用程式
}

class MyApp extends StatelessWidget {
  final FlashcardManager flashcardManager;
  
  // 建構子，接收 flashcardManager 參數
  const MyApp({super.key, required this.flashcardManager});

  @override
  Widget build(BuildContext context) {
    // 使用 MaterialApp 來建立 UI
    return MaterialApp(
      title: '字卡學習',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlashcardListScreen(flashcardManager: flashcardManager),
    );
  }
}


