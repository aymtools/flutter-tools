import 'package:aym_router/aym_router.dart';
import 'package:example_lib/entity/book.dart';
import 'package:flutter/material.dart';

@RoutePage("router://example.router.aymtools.com/test10")
class Test10Page extends StatelessWidget {
  String title;
  bool content;
  int age;
  double height;
  Book book;
  Text cPage;

  Test10Page({this.title, this.content, this.age, this.book, this.cPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("在第三方库中的界面"),
      ),
      body: Center(
        child: GestureDetector(
          child: Text(
            '这是在第三方库中的界面内容,点击跳回测试界面5 并传入',
          ),
          onTap: () => Navigator.of(context).pushNamed(
              "router://example.router.aymtools.com/test5",
              arguments: {"title": 0, "content": true}),
        ),
      ),
    );
  }
}
