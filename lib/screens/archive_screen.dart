import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';

import '../shared/components/constans.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/state.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = ToDoCubit.getobject(context).archivetasks;

        return ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) => BuildTask(index),
                itemCount: tasks.length,
              ),
            ),
          ),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 100,
                  color: Colors.teal,
                ),
                Text(
                  'There is no archived tasks !!',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
