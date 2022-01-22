import 'package:api_cursos/components/course_tile.dart';
import 'package:api_cursos/models/api_response.dart';
import 'package:api_cursos/models/courses.dart';
import 'package:api_cursos/services/courses_service.dart';
import 'package:api_cursos/views/course_delete.dart';
import 'package:api_cursos/views/course_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  CourseService get courseService => GetIt.I<CourseService>();
  late ApiResponse<List<Course>> _apiResponse;
  List<Course> courses = [];
  bool _isLoading = false;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await courseService.getCourseList();
    
    setState(() {
      _isLoading = false;
    });
  }

  void _fetchNotesCallBack() {
    print("chamou função");
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lista de cursos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => CourseModify()))
            .then((_) {
              _fetchNotes();
            });
        },
        child:  Icon(Icons.add),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _apiResponse.data!.length,
        itemBuilder: (ctx, i) { 
          return Dismissible(
            key: ValueKey(_apiResponse.data!.elementAt(i).id), 
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {},
            confirmDismiss: (direction) async {
              final bool result = await showDialog(
                context: context, 
                builder: (_) => CourseDelete()
              );
              print("dialog result $result");
              if(result) {
                final deleteResult = await courseService.deleteCourse(_apiResponse.data!.elementAt(i).id.toString());

                var message;
                if (deleteResult.data ?? false) {
                  message = "Curso deletado com sucesso!";
                } else {
                  message = deleteResult.message ?? "Ocorreu um erro";
                }

                ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                  content: Text(message),
                  duration: new Duration(milliseconds: 2000),
                ));

                return deleteResult?.data ?? false;
              }

              return result;
            },
            background: Container (
              color: Colors.red,
              padding: EdgeInsets.only(left: 16),
              child: Align(
                child: Icon(Icons.delete, color: Colors.white,),
                alignment: Alignment.centerLeft
              ),
            ),
            child: CourseTile(course: _apiResponse.data!.elementAt(i), callback: () => _fetchNotesCallBack()));},
      )
    );
  }
}