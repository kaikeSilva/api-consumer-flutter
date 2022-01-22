import 'package:api_cursos/models/courses.dart';
import 'package:api_cursos/services/courses_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CourseModify extends StatefulWidget {
  final dynamic courseId ;
  CourseModify({this.courseId});

  @override
  _CourseModifyState createState() => _CourseModifyState();
}

class _CourseModifyState extends State<CourseModify> {
  bool get isEditing => widget.courseId != null;
  bool isLoading = false;

  CourseService get courseServise => GetIt.I<CourseService>();
  late String errorMessage;
  late Course? course;

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      setState(() {
        isLoading = true;
      });
      // quando editando buscar o curso a ser editado na API
      courseServise.getCourse(widget.courseId.toString())
      .then((response) {
        setState(() {
          isLoading = false;
        });
        if (response.error) {
          errorMessage = response.message ?? "Ocorreu um erro";
        } else {
          course = response.data;
          _nomeController.text = course!.name;
          _descriptionController.text = course!.description;
          _hourController.text = (course!.durationMinutes!~/60).toString();
          _minutesController.text = (course!.durationMinutes!%60).toString();
          _urlController.text = course!.resourcePlace;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text( isEditing ? "Atualizar Curso":"Criar Curso")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading ? Center(child: CircularProgressIndicator())  : Column(
            children: <Widget>[
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Nome do curso'
                ),
              ),
              TextField(
                maxLines: 5,
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Descrição do curso'
                ),
              ),
              TextField(
                controller: _hourController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Duração em horas'
                ),
              ),
              TextField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Duração em minutos'
                ),
              ),
              TextField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'Url do local do curso'
                ),
              ),
              Container(height: 16,),
              SizedBox(
                width: double.infinity,
                height: 35,
                child: ElevatedButton(
                onPressed: () async {
                  if (isEditing) {
                    setState(() {
                      isLoading = true;
                    });
                    final course = Course(
                      name: _nomeController.text, 
                      description: _descriptionController.text, 
                      resourcePlace: _urlController.text, 
                      durationMinutesInt: int.parse(_minutesController.text),
                      durationHours: int.parse(_hourController.text),
                    );

                    final result = await courseServise.updateCourse(course, widget.courseId.toString());
                    final text = result.error ? result.message : "Curso atualizado com sucesso!";
                    
                    setState(() {
                      isLoading = false;
                    });
                    
                    showDialog(
                      context: context, 
                      builder: (_) => AlertDialog(
                        title: Text("Resultado"),
                        content: Text(text),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, 
                            child: Text('Entendi'))
                        ],
                      )
                    ).then((data) {
                      if(result.data ?? false) {
                        Navigator.of(context).pop();
                      }
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    final course = Course(
                      name: _nomeController.text, 
                      description: _descriptionController.text, 
                      resourcePlace: _urlController.text, 
                      durationMinutesInt: int.parse(_minutesController.text),
                      durationHours: int.parse(_hourController.text),
                    );
                    // quando não estiver editando, enviar os dados na caixa de texto para serem savos na API
                    final result = await courseServise.addCourse(course);
                    final text = result.error ? result.message : "Curso criado com sucesso!";
                    
                    setState(() {
                      isLoading = false;
                    });
                    
                    showDialog(
                      context: context, 
                      builder: (_) => AlertDialog(
                        title: Text("Resultado"),
                        content: Text(text),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, 
                            child: Text('Entendi'))
                        ],
                      )
                    ).then((data) {
                      if(result.data ?? false) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                }, 
                child: Text('cadastrar')
                ),
              )
            ],
          ),
        )
      );
  }
}