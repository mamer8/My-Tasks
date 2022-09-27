import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';

import '../../screens/archive_screen.dart';
import '../../screens/done_screen.dart';
import '../../screens/task_screen.dart';
import 'state.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(ToDoInitialState());

  static ToDoCubit getobject(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];

  List<String> bar = ['New tasks', 'Done tasks', 'Archived tasks'];
  List<Widget> Screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen()
  ];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(ToDoChangeScreenIndexesState());
  }

  void CreateDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('db created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((eror) {
        print('error on created ${eror.toString()}');
      });
    }, onOpen: (database) {
      GetDataFromDB(database);
      print('db opened');
    }).then((value) {
      database = value;
      emit(ToDoCreateDBState());
    });
  }

  InsertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(ToDoInsertToDBState());
        print('values inserted $value');
        GetDataFromDB(database);
      }).catchError((error) {
        print('erroooor ${error.toString()}');
      });
      return null;
    });
  }

  void UpdateDB({required String status, required int id}) async {
    database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      GetDataFromDB(database);
      emit(ToDoUpdateDBState());
    });
  }

  void DeleteFromDB({required int id}) async {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      GetDataFromDB(database);
      emit(ToDoDeleteFromDBState());
    });
  }

  void GetDataFromDB(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    emit(ToDoGetDataFromDBLoadingState());
    database?.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else if (element['status'] == 'archive') {
          archivetasks.add(element);
        }
      });

      emit(ToDoGetDataFromDBState());
    });
  }
}
