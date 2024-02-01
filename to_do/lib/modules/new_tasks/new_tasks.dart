import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/components/components.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

//==========================================================================================================================================================

// Define a StatelessWidget for displaying new tasks

class NewTasks extends StatelessWidget {
  const NewTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use BlocConsumer to listen for state changes in AppCubit

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},

        // The builder function is called to build the UI based on the current state

        builder: (context, state) {
          // Retrieve the list of done tasks from AppCubit

          var tasks = AppCubit.get(context).newTasks;

          // Build the UI using the tasksBuilder function and the retrieved new tasks

          return tasksBuilder(tasks: tasks);
        });
  }
}

//==========================================================================================================================================================

