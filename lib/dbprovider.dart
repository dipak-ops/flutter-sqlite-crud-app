import 'package:flutter/foundation.dart';
import 'package:sqlite_database/dbhelper.dart';

class DBProvider extends ChangeNotifier {
  DBHelper dbHelper;

  DBProvider({required this.dbHelper});

  List<Map<String, dynamic>> _mData = [];

  // Add Note
  void addNote(String title, String desc) async {
    bool check = await dbHelper.addNote(
      mTitle: title,
      mDesc: desc,
    );

    if (check) {
      _mData = await dbHelper.getNote();
      notifyListeners();
    }
  }

  // Update Note
  void updateNote(String title, String desc, int sno) async {
    bool check = await dbHelper.updateNote(
      mTitle: title,
      mDesc: desc,
      sno: sno,
    );

    if (check) {
      _mData = await dbHelper.getNote();
      notifyListeners();
    }
  }

  // Delete Note
  void deleteNote(int sno) async {
    bool check = await dbHelper.deleteNote(sno: sno);

    if (check) {
      _mData = await dbHelper.getNote();
      notifyListeners();
    }
  }

  // Get Notes
  List<Map<String, dynamic>> getNotes() => _mData;

  // Load Notes Initially
  void getInitialNotes() async {
    _mData = await dbHelper.getNote();
    notifyListeners();
  }
}