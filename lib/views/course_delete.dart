import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseDelete extends StatelessWidget {
  const CourseDelete({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Aviso'),
      content: Text('Tem certeza que deseja deletar o curso?'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          }, 
          child: Text('Sim')
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          }, 
          child: Text('Não')
        ),
      ],
    );
  }
}