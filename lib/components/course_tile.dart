import 'package:api_cursos/models/courses.dart';
import 'package:api_cursos/views/course_modify.dart';
import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({ Key? key, required this.course, required this.callback }) : super(key: key);
  final Course course;
  final VoidCallback callback;
  
  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(child: Icon(Icons.book)); 
    return ListTile(
      leading: avatar,
      title: Text(course.name),
      subtitle: Text(course.description),
      trailing: Container(
        width: 50,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.orange,
              onPressed: () {
                Navigator.of(context)
                .push( MaterialPageRoute(
                  builder: (_) => CourseModify(courseId: course.id)
                )
                ).then((value) => callback());
              },
            ),
          ],
        )
      ) 
    );
  }
}