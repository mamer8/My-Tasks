import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

Widget BuildTask(int index) => BlocConsumer<ToDoCubit, ToDoStates>(
    listener: (context, state) {},
    builder: (context, state) {
      var tasks = ToDoCubit.getobject(context).donetasks;
      return Dismissible(
        key: Key(tasks[index]['id'].toString()),
        onDismissed: (direction) {
          ToDoCubit.getobject(context).DeleteFromDB(id: tasks[index]['id']);
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${tasks[index]['time']}'),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tasks[index]['title']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('${tasks[index]['date']}')
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  ToDoCubit.getobject(context)
                      .UpdateDB(status: 'done', id: tasks[index]['id']);
                },
                icon: Icon(Icons.check_box),
                color: Colors.teal),
            IconButton(
                onPressed: () {
                  ToDoCubit.getobject(context)
                      .UpdateDB(status: 'archive', id: tasks[index]['id']);
                },
                icon: Icon(Icons.archive),
                color: Colors.teal),
          ],
        ),
      );
    });
