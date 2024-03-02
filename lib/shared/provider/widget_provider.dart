import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:heartless/widgets/log/diary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Structure {
  List<Diary>? DiaryStructureList;
  List<String>? DiaryStructureStringList;
  Structure({this.DiaryStructureList, this.DiaryStructureStringList});
}

class WidgetNotifier with ChangeNotifier {
  // for circular progress indicator
  bool _loading = false;
  bool get loading => _loading;
  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // for hiding/showing password
  bool _passwordShown = true;
  bool get passwordShown => _passwordShown;
  void setPasswordShown(bool passwordShown) {
    _passwordShown = passwordShown;
    notifyListeners();
  }

  // for swtiching the toggle button
  bool _emailPhoneToggle = true;
  bool get emailPhoneToggle => _emailPhoneToggle;
  void toggleEmailPhone() {
    _emailPhoneToggle = !_emailPhoneToggle;
    notifyListeners();
  }

  // login or signup toggle
  bool _showLogin = true;
  bool get showLogin => _showLogin;
  void toggleLoginSignup() {
    _showLogin = !_showLogin;
    notifyListeners();
  }

  ScheduleToggleType _scheduleToggleType = ScheduleToggleType.all;
  ScheduleToggleType get scheduleToggleType => _scheduleToggleType;
  void changeToggleSelection(ScheduleToggleType scheduleToggleType) {
    _scheduleToggleType = scheduleToggleType;
    notifyListeners();
  }

  // date selected in the schedule page
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  //for diary
  List<Diary>? _diaryList = [];
  List<String>? _diaryListString = [];

  List<Diary>? get diaryList => _diaryList;
  List<String>? get diaryJsonList => _diaryListString;

  void SetDiaryList(List<Diary> list, List<String> stringList) {
    _diaryList = list;
    _diaryListString = stringList;
    notifyListeners();
  }

  void addtoDiary(Diary diary) {
    _diaryList!.add(diary);
    _diaryListString!.add(jsonEncode(diary.toMap()));
    saveDiary();
    notifyListeners();
  }

  void updateDiary(Diary diary, int index) {
    _diaryList![index] = diary;
    _diaryListString![index] = jsonEncode(diary.toMap());
    saveDiary();
    notifyListeners();
  }

  void deleteDiary(Diary diary) {
    _diaryList!.remove(diary);
    _diaryListString!.remove(jsonEncode(diary.toMap()));
    saveDiary();
    notifyListeners();
  }

  Future<bool> saveDiary() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setStringList('DiaryList', _diaryListString ?? []);
    notifyListeners();
    return true;
  }

  List<String>? getDiarydiary(Map<String, dynamic> data) {
    return data['diary'] is Iterable ? List.from(data['diary']) : null;
  }

  getDiaryFormFirebase(String uid) async {
    //todo
  }

  Future<Structure> getDiary() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    List<String>? dairySP = sp.getStringList('DiaryList');
    _diaryListString = dairySP;

    debugPrint('diary Stirng in get Diary$_diaryListString');
    List<Diary> diaryList = [];
    for (String dairy in _diaryListString ?? []) {
      diaryList.add(Diary.fromMap(jsonDecode(dairy)));
    }
    notifyListeners();
    debugPrint('diary string get Diary$_diaryListString');
    Structure structure = Structure(
        DiaryStructureList: diaryList,
        DiaryStructureStringList: _diaryListString);
    return structure;
  }

  void ClearDiaryList() async {
    //todo
  }
}
