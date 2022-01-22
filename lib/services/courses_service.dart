import 'dart:convert';
import 'package:api_cursos/models/api_response.dart';
import 'package:api_cursos/models/courses.dart';
import 'package:http/http.dart' as http;

class CourseService {
  static const API = "https://shrouded-lake-54076.herokuapp.com";
  static const headers = {
    "authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9zaHJvdWRlZC1sYWtlLTU0MDc2Lmhlcm9rdWFwcC5jb21cL2FwaVwvbG9naW4iLCJpYXQiOjE2MjM0MjQ2ODYsImV4cCI6MTYyMzQ2MDY4NiwibmJmIjoxNjIzNDI0Njg2LCJqdGkiOiJXNTRSTWN0eDRQZkUyaHlGIiwic3ViIjozLCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.SKeZWute6A4-g74T7I8ZLEeDHFpSOEBptT7KvMFB-G4",
    "Content-type" : "application/json"
  };

  Future<ApiResponse<List<Course>>> getCourseList() {
    return http.get(Uri.parse(API+'/api/courses'), headers: headers)
    .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final courses = <Course>[];
        
        for (var item in jsonData['data']) {
          print("erro no for $item");
          final course = Course.fromJason(item);
          courses.add(course);
        }
        print(courses);
        return ApiResponse<List<Course>>(data: courses);
      }
      return ApiResponse<List<Course>>(data: [], error: true, message: "aconteceu um erro");
    }).catchError((_) {
      return ApiResponse<List<Course>>(data: [], error: true, message: "aconteceu um erro");
    });
  }

  Future<ApiResponse<Course>> getCourse(String courseId) {
    return http.get(Uri.parse(API+'/api/courses/'+courseId), headers: headers)
    .then((data) {
      // 200 = ok
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final course = Course.fromJason(jsonData['data']);

        return ApiResponse<Course>(data: course);
      }
      return ApiResponse<Course>(error: true, message: "aconteceu um erro");
    }).catchError((_) {
      return ApiResponse<Course>(error: true, message: "aconteceu um erro");
    });
  }
  
  Future<ApiResponse<bool>> addCourse(Course course) {
    return http.post(Uri.parse(API+'/api/courses'),body: json.encode(course.toJson()), headers: headers)
    .then((data) {
      // 201 = created
      if (data.statusCode == 201) {
        return ApiResponse<bool>(data: true, error: false);
      }
      return ApiResponse<bool>(data: false, error: true, message: "aconteceu um erro");
    }).catchError((_) {
      return ApiResponse<bool>(data: false, error: true, message: "aconteceu um erro");
    });
  }

  Future<ApiResponse<bool>> updateCourse(Course course, String courseId) {
    return http.put(Uri.parse(API+'/api/courses/'+courseId),body: json.encode(course.toJson()), headers: headers)
    .then((data) {
      if (data.statusCode == 200 || data.statusCode == 204) {
        return ApiResponse<bool>(data: true, error: false);
      }
      return ApiResponse<bool>(data: false, error: true, message: "aconteceu um erro");
    }).catchError((_) {
      return ApiResponse<bool>(data: false, error: true, message: "aconteceu um erro");
    });
  }

  Future<ApiResponse<bool>> deleteCourse(String courseId) {
    return http.delete(Uri.parse(API+'/api/courses/'+courseId), headers: headers)
    .then((data) {
      if (data.statusCode == 200 || data.statusCode == 204) {
        return ApiResponse<bool>(data: true, error: false);
      }
      return ApiResponse<bool>(data: false, error: true, message: "aconteceu um erro");
    }).catchError((_) {
      return ApiResponse<bool>(data: false, error: true, message: "aconteceu um erro");
    });
  }
}