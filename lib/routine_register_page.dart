import 'package:flutter/material.dart';

class RoutineRegisterPage extends StatefulWidget {
  const RoutineRegisterPage({super.key});

  @override
  State<RoutineRegisterPage> createState() => _RoutineRegisterPageState();
}

class _RoutineRegisterPageState extends State<RoutineRegisterPage> {
  final List<String> weekDays = ["月", "火", "水", "木", "金", "土", "日"];

  // 各曜日ごとのルーティンを管理
  final Map<String, List<String>> routines = {
    "月": [],
    "火": [],
    "水": [],
    "木": [],
    "金": [],
    "土": [],
    "日": [],
  };

  // ルーティンダイアログ
  void _showRoutineDialog(String day, {String? currentValue, int? index}) {
    final controller = TextEditingController(text: currentValue ?? "");

    showDialog(
      context: context,
      builder: (context) => _buildRoutineDialog(day, controller, currentValue, index),
    );
  }

  // AlertDialog を返すメソッド
  Widget _buildRoutineDialog(
      String day,
      TextEditingController controller,
      String? currentValue,
      int? index,
      ) {
    return AlertDialog(
      title: Text(currentValue == null ? "$day に追加" : "$day を編集"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "ルーティン名を入力"),
      ),
      actions: _buildDialogActions(day, controller, currentValue, index),
    );
  }

  // actions を返すメソッド
  List<Widget> _buildDialogActions(
      String day,
      TextEditingController controller,
      String? currentValue,
      int? index,
      ) {
    return [
      if (currentValue != null)
        TextButton(
          onPressed: () {
            _deleteRoutine(day, index!);
            Navigator.pop(context);
          },
          child: const Text("削除", style: TextStyle(color: Colors.red)),
        ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("キャンセル"),
      ),
      TextButton(
        onPressed: () {
          _saveRoutine(day, controller.text, currentValue, index);
          Navigator.pop(context);
        },
        child: const Text("保存"),
      ),
    ];
  }

  // ルーティン削除
  void _deleteRoutine(String day, int index) {
    setState(() {
      routines[day]?.removeAt(index);
    });
  }

  // ルーティン保存（追加 or 編集）
  void _saveRoutine(String day, String text, String? currentValue, int? index) {
    setState(() {
      if (currentValue == null) {
        routines[day]?.add(text);
      } else {
        routines[day]?[index!] = text;
      }
    });
  }

  // 曜日ラベル
  Widget _buildDayLabel(String day) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.blue.shade100,
      child: Text(
        day,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // ルーティンカード
  Widget _buildRoutineCard(String day, String routine, int index) {
    return GestureDetector(
      onTap: () => _showRoutineDialog(day, currentValue: routine, index: index),
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(routine),
        ),
      ),
    );
  }

  // ルーティン一覧
  Widget _buildRoutineList(String day) {
    return Expanded(
      child: ListView(
        children: [
          ...routines[day]!.asMap().entries.map(
                (entry) => _buildRoutineCard(day, entry.value, entry.key),
          ),
          // 新規追加ボタン
          GestureDetector(
            onTap: () => _showRoutineDialog(day),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "+ 追加",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 曜日列
  Widget _buildDayColumn(String day) {
    return Expanded(
      child: Column(
        children: [
          _buildDayLabel(day),
          _buildRoutineList(day),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ルーティン登録")),
      body: Row(
        children: weekDays.map(_buildDayColumn).toList(),
      ),
    );
  }
}
