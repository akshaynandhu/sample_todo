import 'package:custom_timer/custom_timer.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample_todo/controller/getx_controller.dart';
import 'package:sample_todo/model/model.dart';

///Create Task
var homeController = Get.put(Homecontroller());

showDialogBox(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  return showDialog(
    context: context,
    builder: (context) {
      return GetBuilder<Homecontroller>(
          builder: (homeController) {
        return AlertDialog(
          title: const Text(
            'CREATE YOUR TASK',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty || value[0] == " ") {
                          return "This field is required";
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      controller: homeController.title,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.title,
                            color: Colors.redAccent,
                          ),
                          hintText: "Title",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w900),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value[0] == " ") {
                          return "This field is required";
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: homeController.description,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.description,
                            color: Colors.redAccent,
                          ),
                          hintText: "Description",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showTimePickerWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              homeController.add_task();
                              homeController.showSelectedTime();
                              Get.back();
                            } else {}
                          },
                          child: const Text("Save"),
                          color: Colors.redAccent,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

///List Task

class ListTask extends StatelessWidget {
  const ListTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ValueListenableBuilder(
        valueListenable: homeController.todoBox.listenable(),
        builder: (context, Box<TodoModel> studentShow, child) {
          List<int> key = homeController.todoBox.keys.cast<int>().toList();
          return GetBuilder<Homecontroller>(
            builder: (homeController) {
              return ListView.builder(
                itemBuilder: (con, index) {
                  final indexedKey = key[index];
                  final TodoModel? todoDetails =
                      homeController.todoBox.get(indexedKey);
                  debugPrint("SINGLE TODO DETAIL IS ${todoDetails?.time.toString()}");
                  final time = todoDetails?.time;
                  var parsedTime,dayDifference;
                  debugPrint("RUNTIME TYPE is ${time.runtimeType}");
                  if(time != ""){
                    parsedTime = DateTime.parse(time);
                    homeController.parsedTimeList.add(parsedTime);
                    dayDifference =
                        (DateTime.now().difference(parsedTime).inDays) * -1;
                    homeController.numberOfDays.add(dayDifference);
                  }else{
                    parsedTime = "";
                  }

                  return key.isEmpty
                      ? const Center(
                          child: Text(
                            "Empty",
                            style: (TextStyle(color: Colors.black)),
                          ),
                        )
                      : Column(
                          children: [
                            Dismissible(
                              background: Padding(
                                padding: const EdgeInsets.only(right: 22.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: Colors.red,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              key: ValueKey<int>(indexedKey),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                if (direction ==
                                    DismissDirection.endToStart) {
                                  final bool res = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                " Are you sure want to delete?",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.redAccent,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      homeController
                                                          .todoBox
                                                          .delete(
                                                        indexedKey,
                                                      );
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.redAccent,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text(
                                                      "No",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Poppins",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                  return res;
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              child: GestureDetector(
                                onTap: () {
                                  final CustomTimerController _controller =
                                      CustomTimerController();
                                  _controller.start();
                                  debugPrint(
                                      "SEnding days are ${homeController.numberOfDays[index]}");
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      var title = todoDetails!.title;
                                      var description =
                                          todoDetails.description;
                                      return AlertDialog(
                                        title: const Text(
                                          'TASK',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Form(
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    onChanged: (string) {
                                                      title = string;
                                                    },
                                                    initialValue:
                                                        (todoDetails.title),
                                                    validator: (value) {
                                                      if (value!.isEmpty ||
                                                          value[0] == " ") {
                                                        return "This field is required";
                                                      }
                                                    },
                                                    keyboardType:
                                                        TextInputType.name,
                                                    decoration:
                                                        const InputDecoration(
                                                      icon: Icon(
                                                        Icons.title,
                                                        color: Colors.redAccent,
                                                      ),
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Form(
                                                  child: TextFormField(
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    onChanged: (string) {
                                                      description = string;
                                                    },
                                                    initialValue: todoDetails
                                                        .description,
                                                    validator: (value) {
                                                      if (value!.isEmpty ||
                                                          value[0] == " ") {
                                                        return "This field is required";
                                                      }
                                                    },
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    decoration:
                                                    const InputDecoration(
                                                      icon:  Icon(
                                                        Icons.description,
                                                        color: Colors.redAccent,
                                                      ),
                                                      hintText: "Description",
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w900),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: CustomTimer(
                                                  controller: _controller,
                                                  begin: Duration(
                                                    days: homeController
                                                        .numberOfDays[index],
                                                    hours: homeController
                                                        .parsedTimeList[index]
                                                        .hour,
                                                    minutes: homeController
                                                        .parsedTimeList[index]
                                                        .minute,
                                                  ),
                                                  end: const Duration(),
                                                  builder: (time) {
                                                    return Text(
                                                      "${time.hours}:${time.minutes}:${time.seconds}",
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    MaterialButton(
                                                      onPressed: () {
                                                        TodoModel changed =
                                                            TodoModel(
                                                          title: title,
                                                          description:
                                                              description,
                                                          time: homeController
                                                              .userSelectedTodoTime,
                                                        );
                                                        homeController
                                                            .todoBox
                                                            .putAt(index,
                                                                changed);
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                          "Update"),
                                                      color: Colors.redAccent,
                                                      textColor: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(Icons.event_note_outlined,size: 40,),
                                  title: Text(
                                    todoDetails!.title.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  subtitle: Text(
                                    todoDetails.description,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing:
                                      Text(todoDetails.time.split(" ")[0]),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                          ],
                        );
                },
                itemCount: key.length,
              );
            },
          );
        },
      ),
    );
  }
}

/// Show TimePicker

Widget showTimePickerWidget() {
  return GetBuilder<Homecontroller>(builder: (controller) {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.event,color: Colors.redAccent,),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 6 || date.weekday == 7) {
          return false;
        }

        return true;
      },
      onChanged: (newTime) => controller.changeSelectedTime(newTime),
      validator: (val) {
        debugPrint(val);
        return null;
      },
      onSaved: (newTime) => controller.changeSelectedTime(newTime),
    );
  });
}
