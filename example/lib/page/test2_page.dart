import 'package:flutter/material.dart';
import 'package:aym_router/aym_router.dart';
import 'package:example/entity/user.dart';

import 'package:example_lib/entity/book.dart';

@RoutePage("router://example.router.aymtools.com/test5")
class TestPage extends StatelessWidget {
  String title;
  bool sex;
  int age;
  double height;

  TestPage({@RoutePageParam('titleRes') this.title, this.sex, this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Router Demo"),
      ),
      body: Center(
          child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          "/test6",
        ),
        child: Text(
          '这是第五个界面的内容$title\ncontent:$sex',
        ),
      )),
    );
  }
}

@RoutePage("/test6")
class Test6Page extends StatelessWidget {
  Text cPage;

  Test6Page({this.cPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Router Demo"),
      ),
      body: Center(
        child: Text(
          '这是第六个界面的内容',
        ),
      ),
    );
  }
}

@RoutePage("router://example.router.aymtools.com/test7")
class Test7Page extends StatelessWidget {
  String title;

  Book book;

  Test7Page({this.title, this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Router Demo"),
      ),
      body: Center(
        child: Text(
          '这是第7个界面的内容',
        ),
      ),
    );
  }
}

@RoutePage("router://example.router.aymtools.com/test8")
class Test8Page extends StatelessWidget {
  String title;

  Book book;

//  _Test8Page({this.title, this.book});
  Test8Page._(this.title);

  factory Test8Page(String name) => Test8Page._(name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Router Demo"),
      ),
      body: Center(
        child: Text(
          '使用定义的factory创建的界面',
        ),
      ),
    );
  }
}
