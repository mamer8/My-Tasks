import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'shared/components/components.dart';
import 'shared/cubit/cubit.dart';
import 'shared/cubit/state.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  // late Database database;
  String newTask = '';
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var tasktime;
  var taskdate;
  double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  GlobalKey<FormState> form_key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ToDoCubit()..CreateDatabase(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (BuildContext context, ToDoStates state) {
          if (state is ToDoInsertToDBState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, ToDoStates state) {
          ToDoCubit cubit = ToDoCubit.getobject(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(
                cubit.bar[cubit.currentIndex],
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
              centerTitle: true,
            ),
            body: ConditionalBuilder(
                builder: (context) => cubit.Screens[cubit.currentIndex],
                condition: state is! ToDoGetDataFromDBLoadingState,
                fallback: (context) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Loading ...',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                    )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                          color: Color(0xff757575),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            child: Form(
                              key: form_key,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  defaultTextFeild(
                                      onTap: () {},
                                      controller: titlecontroller,
                                      type: TextInputType.text,
                                      validator: (value) => value!.isEmpty
                                          ? 'Title cannot be blank'
                                          : null,
                                      label: 'Title',
                                      onSubmitted: (String? value) {},
                                      prefix: Icons.title),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: defaultTextFeild(
                                            onTap: () {
                                              showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now())
                                                  .then((value) {
                                                tasktime =
                                                    value?.format(context);

                                                // setState(() {
                                                timecontroller.text = tasktime;
                                                // });
                                              }).catchError((error) {
                                                print(
                                                    'Errooor ${error.toString()}');
                                              });
                                            },
                                            controller: timecontroller,
                                            type: TextInputType.datetime,
                                            validator: (value) => value!.isEmpty
                                                ? 'Time cannot be blank'
                                                : null,
                                            label: 'Time',
                                            onSubmitted: (String? value) {},
                                            prefix: Icons.timer),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: defaultTextFeild(
                                            onTap: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2023-02-27'),
                                              ).then((value) {
                                                taskdate = DateFormat.yMMMEd()
                                                    .format(value!);
                                                // setState(() {
                                                datecontroller.text = taskdate;
                                                //   print('fd');
                                                // });
                                              }).catchError((error) {
                                                print(
                                                    'Errooor ${error.toString()}');
                                              });
                                            },
                                            controller: datecontroller,
                                            type: TextInputType.datetime,
                                            validator: (value) => value!.isEmpty
                                                ? 'Date cannot be blank'
                                                : null,
                                            label: 'Date',
                                            onSubmitted: (String? value) {},
                                            prefix: Icons.calendar_month),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultButton(
                                      button_onPressed: () {
                                        final isValid =
                                            form_key.currentState!.validate();
                                        if (isValid) {
                                          cubit.InsertToDatabase(
                                              title: titlecontroller.text,
                                              time: timecontroller.text,
                                              date: datecontroller.text);
                                          // Navigator.pop(context);
                                          // timecontroller.text = '';
                                          // titlecontroller.text = '';
                                          // datecontroller.text = '';
                                        } else {
                                          print('object');
                                        }
                                      },
                                      // ToDoCubit.getobject(context)
                                      //     .validateAndSave,
                                      text: 'ADD'),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(height: getKeyboardHeight(context)),
                                ],
                              ),
                            ),
                          ),
                        ),
                    isScrollControlled: true);
                // scaffoldkey.currentState?.showBottomSheet((context) => Container(
                //       height: 30,
                //       color: Colors.red,
                //     ));
              },
              child: Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Task'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
