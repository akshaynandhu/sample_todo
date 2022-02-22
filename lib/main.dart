import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample_todo/controller/getx_controller.dart';
import 'package:sample_todo/view/splash.dart';
import 'package:get/get.dart';

import 'model/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>("tasks");
  Get.put(Homecontroller());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => GetMaterialApp(
        builder: (context, widget){
          ScreenUtil.setContext(context);
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget!,);
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyCustomSplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
}
