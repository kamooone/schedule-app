import 'package:flutter/material.dart';

class RoutineRegisterPage extends StatefulWidget {
  const RoutineRegisterPage({super.key});

  @override
  State<RoutineRegisterPage> createState() => _RoutineRegisterPageState();
}

class _RoutineRegisterPageState extends State<RoutineRegisterPage> {
  // 曜日リスト
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

  // -----------------------------
  // ルーティンダイアログを表示
  // -----------------------------
  void _showRoutineDialog(String day, {String? currentValue, int? index}) {
    final controller = TextEditingController(text: currentValue ?? "");

    showDialog(
      context: context,
      builder: (_) => _buildRoutineAlertDialog(day, controller, currentValue, index),
    );
  }

  // -----------------------------
  // AlertDialog を生成して返す
  // -----------------------------
  AlertDialog _buildRoutineAlertDialog(
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

  // -----------------------------
  // ダイアログ内のボタンを生成して返す
  // -----------------------------
  List<Widget> _buildDialogActions(
      String day,
      TextEditingController controller,
      String? currentValue,
      int? index,
      ) {
    final List<Widget> actions = [];

    // 削除ボタン
    if (currentValue != null) {
      actions.add(_buildDeleteButton(day, index!));
    }

    // キャンセルボタン
    actions.add(_buildCancelButton());

    // 保存ボタン
    actions.add(_buildSaveButton(day, controller.text, currentValue, index));

    return actions;
  }

  // -----------------------------
  // 削除ボタン
  // -----------------------------
  Widget _buildDeleteButton(String day, int index) {
    return TextButton(
      onPressed: () {
        _deleteRoutine(day, index);
        Navigator.pop(context);
      },
      child: const Text("削除", style: TextStyle(color: Colors.red)),
    );
  }

  // -----------------------------
  // キャンセルボタン
  // -----------------------------
  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("キャンセル"),
    );
  }

  // -----------------------------
  // 保存ボタン
  // -----------------------------
  Widget _buildSaveButton(String day, String text, String? currentValue, int? index) {
    return TextButton(
      onPressed: () {
        _saveRoutine(day, text, currentValue, index);
        Navigator.pop(context);
      },
      child: const Text("保存"),
    );
  }

  // -----------------------------
  // ルーティン削除処理
  // -----------------------------
  void _deleteRoutine(String day, int index) {
    setState(() {
      routines[day]?.removeAt(index);
    });
  }

  // -----------------------------
  // ルーティン保存（追加 or 編集）処理
  // -----------------------------
  void _saveRoutine(String day, String text, String? currentValue, int? index) {
    setState(() {
      if (currentValue == null) {
        routines[day]?.add(text);
      } else {
        routines[day]?[index!] = text;
      }
    });
  }

  // -----------------------------
  // 曜日ラベルを作成
  // -----------------------------
  Widget _buildDayLabel(String day) => Container(
    height: 40,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      color: Colors.blue.shade100,
    ),
    child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  // -----------------------------
  // 個別ルーティンカードを作成
  // -----------------------------
  Widget _buildRoutineCard(String day, String routine, int index) {
    return GestureDetector(
      onTap: () => _showRoutineDialog(day, currentValue: routine, index: index),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Text(routine),
      ),
    );
  }

  // -----------------------------
  // ルーティン追加ボタンを作成
  // -----------------------------
  Widget _buildAddButton(String day) => GestureDetector(
    onTap: () => _showRoutineDialog(day),
    child: Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade200,
      ),
      child: const Center(child: Text("+ 追加", style: TextStyle(color: Colors.grey))),
    ),
  );

  // -----------------------------
  // 曜日列のルーティン一覧を作成
  // -----------------------------
  Widget _buildRoutineList(String day) {
    final routineWidgets = routines[day]!
        .asMap()
        .entries
        .map((e) => _buildRoutineCard(day, e.value, e.key))
        .toList();
    routineWidgets.add(_buildAddButton(day));

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.black26),
            bottom: BorderSide(color: Colors.black26),
          ),
        ),
        child: ListView(padding: const EdgeInsets.all(4), children: routineWidgets),
      ),
    );
  }

  // -----------------------------
  // 曜日列全体（ラベル＋ルーティンリスト）を作成
  // -----------------------------
  Widget _buildRoutineColumn(String day) => Expanded(
    child: Column(
      children: [_buildDayLabel(day), _buildRoutineList(day)],
    ),
  );

  // -----------------------------
  // 全曜日列を作成
  // -----------------------------
  List<Widget> _buildDayColumns() => weekDays.map(_buildRoutineColumn).toList();

  // -----------------------------
  // 画面構築
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ルーティン登録")),
      body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: _buildDayColumns()),
    );
  }
}
