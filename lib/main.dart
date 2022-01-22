import 'package:api_cursos/services/courses_service.dart';
import 'package:api_cursos/views/course_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void setUpLocator() {
  GetIt.instance.registerLazySingleton(() => CourseService());
}
void main() {
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CourseList(),
    );
  }
}
