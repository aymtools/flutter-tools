import 'package:aym_router/aym_router.dart';
import 'package:example_lib/entity/book.dart';
import 'package:flutter/material.dart';

@AYMRoutePage("router://example.router.aymtools.com/test10")
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
        title: Text("第10个测试界面"),
      ),
      body: Center(
        child: GestureDetector(
          child: Text(
            '这是第10个界面的内容',
          ),
          onTap: () => Navigator.of(context).pushNamed(
              "router://example.router.aymtools.com/test5",
              arguments: {"title": 0, "content": true}),
        ),
      ),
    );
  }
}
