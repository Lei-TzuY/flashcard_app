import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart'; //用來定義 Hive 的資料類別（model），像是 Flashcard。
import 'ollama_service.dart';
// import 'package:flutter/src/widgets/framework.dart';

part 'flashcard_manager.g.dart';

// 定義一個字卡類別，包含字卡的標題和定義
@HiveType(typeId: 0)
class Flashcard {
  @HiveField(0)
  String title;

  @HiveField(1)
  String definition;

  @HiveField(2)
  bool isRemembered;

  @HiveField(3)
  String example;

  Flashcard({
    required this.title,
    required this.definition,
    this.isRemembered = false,
    this.example = '',
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'definition': definition,
    'example': example,
  };

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      title: json['title'],
      definition: json['definition'],
      example: json['example'] ?? '',
    );
  }
}

// FlashcardManager 類別，負責管理字卡的增、刪、改功能
class FlashcardManager extends ChangeNotifier {
  final Box<Flashcard> flashcardBox = Hive.box('flashcards');
  List<Flashcard> get flashcards => flashcardBox.values.toList(); // 用來存儲字卡的列表

  void addFlashcard(Flashcard flashcard) {
    flashcardBox.add(flashcard);
  }

  void deleteFlashcard(int index) {
    flashcardBox.deleteAt(index);
  }

  void editFlashcard(int index, Flashcard updatedFlashcard) {
    flashcardBox.putAt(index, updatedFlashcard);
  }

  Future<void> updateFlashcardExample(Flashcard flashcard) async {
    print('Generating example for: ${flashcard.title}');
    String example = await generateExample(flashcard.title);
    print('Generated example: $example');
    flashcard.example = example;
    notifyListeners();
  }

  Future<String> generateExample(String word) async {
    await Future.delayed(Duration(seconds: 2)); // 模擬 API 請求
    return "This is an example sentence for $word.";
  }

  Future<void> importCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final input = await file.readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(input);

      for (var row in csvTable) {
        if (row.length >= 2) {
          Flashcard newFlashcard = Flashcard(
            title: row[0].toString(),
            definition: row[1].toString(),
          );
          flashcardBox.add(newFlashcard); // 直接使用 Hive 存入
        }
      }
    }
  }
}
