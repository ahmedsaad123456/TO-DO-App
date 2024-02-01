import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/modules/archived_tasks/archived_tasks.dart';
import 'package:to_do/modules/done_tasks/done_tasks.dart';
import 'package:to_do/modules/new_tasks/new_tasks.dart';
import 'package:to_do/shared/cubit/states.dart';

// ==========================================================================================================================================================
// The AppCubit class is responsible for managing the application's state using Flutter Bloc.

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialState());

  // A method to get the AppCubit instance from the context.
  static AppCubit get(context) => BlocProvider.of(context);

  // Index to manage the current active tab in the bottom navigation bar.
  int currentIndex = 0;

  // Lists to store different types of tasks.
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  // Variables to manage the bottom sheet state 
  bool isBottomSheet = false;

  // floating action button icon.
  IconData floatingActionButtonIcon = Icons.edit;

  // Database instance 
  Database? database;

  // screen widgets.
  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks()
  ];

  // Titles for the different screens.
  List<String> title = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

// ==========================================================================================================================================================
  
  // Method to change the current index.
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

// ==========================================================================================================================================================
 
  // Method to create the SQLite database.
  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      // Table creation with fields: id, title, date, time, status.
      database.execute(
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
      ).then((value) {
        // Table created successfully.
      }).catchError((error) {
        // print('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      // When the database is opened, get data from it.
      getDataFromDatabase(database);
    }).then((value) {
      // Set the database instance and emit state change.
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

// ==========================================================================================================================================================
  // Method to insert a new task into the database.
  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) {
      return txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      ).then((value) {
        // Task inserted successfully.
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        // print('Error when inserting new record $error.toString()');
      });
    });
  }

// ==========================================================================================================================================================
  // Method to get tasks data from the database.
  void getDataFromDatabase(Database? database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    // get tasks and put it in the list according to the status 
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      }
      emit(AppGetDatabaseState());
    });
  }

// ==========================================================================================================================================================
  // Method to change the state of the bottom sheet and floating action button.
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheet = isShow;
    floatingActionButtonIcon = icon;
    emit(AppChangeBottomSheetState());
  }

// ==========================================================================================================================================================
  // Method to update the status of a task in the database.
  void updateData({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?', [status, id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

// ==========================================================================================================================================================
  // Method to delete a task from the database.
  void deleteData({
    required int id,
  }) {
    database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

// ==========================================================================================================================================================
}

// ==========================================================================================================================================================
