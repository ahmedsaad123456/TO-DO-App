import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/cubit.dart';

//==========================================================================================================================================================
// Widget for a default form field used for user input.

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required final String? label,
  required String? Function(String?)? validate,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixPressed,
  Function()? onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      obscureText: isPassword,
      // onFieldSubmitted: (value) {
      //   print(value);
      // },
      // onChanged: (value) {
      //   print(value);
      // },
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

//==========================================================================================================================================================
// Widget for building a task item, displayed in the task list.

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // CircleAvatar to display task time.
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.blue,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),

            // show done button if only the task is not done
            if (model['status'] != 'done')
            IconButton(
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
            ),

            // show archive button if only the task is not archived
            if (model['status'] != 'archive')
            IconButton(
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: model['id']);
              },
            ),
          ],
        ),
      ),
    );

//==========================================================================================================================================================

// Widget for building a list of tasks, handling the empty state as well.

Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      // Check if tasks list is not empty.
      condition: tasks.isNotEmpty,
      fallback: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display icon and message for empty task list.
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
          itemCount: tasks.length),
    );

//==========================================================================================================================================================


