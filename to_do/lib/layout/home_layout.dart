import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';
//==========================================================================================================================================================

// 1. create database
// 2. create tables
// 3. open the database
// 4. insert to the database
// 5. get from the database
// 6. update the database
// 7. delete the database

// ==========================================================================================================================================================
// The HomeLayout class represents the main screen of the To-Do app.

class HomeLayout extends StatelessWidget {
  // Global key for accessing the Scaffold state.
  final scaffoldkey = GlobalKey<ScaffoldState>();

  // Global key for accessing the Form state.
  final formkey = GlobalKey<FormState>();

  // Controllers for handling user input for task title, time, and date.
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  // Constructor for the HomeLayout class.
  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Using BlocProvider to provide the AppCubit to the widget tree.
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        // Listener to handle state changes and navigate back when a task is inserted.
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            // navigate back is mean close bottom sheet after a task is inserted
            Navigator.pop(context);
          }

          AppCubit cubit = AppCubit.get(context);
          if (cubit.isBottomSheet && cubit.currentIndex != 0) {
            // Close the bottom sheet if it is open and navigate to the other screens
            Navigator.pop(context);
          }
        },
        // Builder to construct the UI based on the current state.
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
              ),

            ),
            body: ConditionalBuilder(
              // Display different widgets based on the database loading state.
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: cubit.currentIndex ==
                    0 // Show FAB only on the "New Tasks" screen (index 0).
                ? FloatingActionButton(
                    onPressed: () {
                      // if the bottom sheet is already selected
                      if (cubit.isBottomSheet) {
                        if (formkey.currentState!.validate()) {
                          cubit.insertDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                          );
                        }
                      } else {
                        // if the bottom sheet is not selected
                        scaffoldkey.currentState!
                            .showBottomSheet(
                              // Bottom sheet widget for adding a new task.
                              elevation: 20.0,
                              (context) => Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: formkey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Form fields for task title, time, and date.
                                      defaultFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        label: 'Task Title',
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'title must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.title,
                                      ),
                                      const SizedBox(height: 15.0),
                                      defaultFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        label: 'Task Time',
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'time must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.watch_later_outlined,
                                        onTap: () {
                                          // Show time picker when tapping on the time field.
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 15.0),
                                      defaultFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        label: 'Task Date',
                                        validate: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'date must not be empty';
                                          }
                                          return null;
                                        },
                                        prefix: Icons.calendar_today,
                                        onTap: () {
                                          // Show date picker when tapping on the date field.
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now()
                                                .add(const Duration(days: 90)),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 15.0),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .closed
                            .then((value) {
                          // Change bottom sheet state when it's closed and remove the writed text.
                          titleController.text = "";
                          timeController.text = "";
                          dateController.text = "";
                          cubit.changeBottomSheetState(
                              isShow: false, icon: Icons.edit);
                        });
                        // Change bottom sheet state when it's opened.
                        cubit.changeBottomSheetState(
                            isShow: true, icon: Icons.add);
                      }
                    },
                    backgroundColor: Colors.blue,
                    // icon of floationg action button
                    child: Icon(cubit.floatingActionButtonIcon , color: Colors.white,),
                  )
                : null, // Set to null to hide the FAB on other screens.

            bottomNavigationBar: ConvexAppBar(
              initialActiveIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                // Change the active index when tapping on a navigation bar item.
                AppCubit.get(context).changeIndex(index);
              },
              items: const[
                TabItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  title: 'Tasks',
                
                ),
                TabItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  title: 'Done',
                ),
                TabItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  title: 'Archived',
                  
                ),
              ],
              backgroundColor: Colors.blue,
              style: TabStyle.reactCircle ,
              
                
            ),
          );
        },
      ),
    );
  }
}
// ==========================================================================================================================================================


