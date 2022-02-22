import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sample_todo/model/model.dart';

class Homecontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    todoBox = Hive.box("tasks");
  }

  late Box<TodoModel> todoBox;

  final formKey = GlobalKey<FormState>();

  List<DateTime> parsedTimeList = [];
  List<dynamic> numberOfDays = [];
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  void add_task() {
    debugPrint("Called Funtion to save Todo");
    String heading = title.text;
    String writings = description.text;

    TodoModel tasks =
    TodoModel(title: heading, description: writings, time: userSelectedTodoTime.toString());
    todoBox.add(tasks);
    description.clear();
    title.clear();
  }

  void edit_task(TodoModel model, String title, String description) {
    model.title = title;
    model.description = description;
    model.time = userSelectedTodoTime.toString();
    model.save();
  }

  String? userSelectedTodoTime;

  changeSelectedTime(newTime2) {
    userSelectedTodoTime = newTime2;
    debugPrint("Time getting in controller small function is $userSelectedTodoTime");
    update();
  }

  showSelectedTime() {
    update();
  }
}
