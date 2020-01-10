import 'package:flutter/material.dart';
import 'package:aym_router/aym_router.dart';
import 'package:example/entity/user.dart';

import 'package:example_lib/entity/book.dart';


@RoutePage("router://example.router.aymtools.com/test5")
class TestPage extends StatelessWidget {
  String title;
  bool content;
  int age;
  double height;
  User user;

  TestPage({@RoutePageParam('titleRes') this.title, this.content, this.age});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第五个测试界面"),
      ),
      body: Center(
          child: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(
                    "router://example.router.aymtools.com/test3.json2",
                    arguments: User("哈哈哈")),
            child: Text(
              '这是第五个界面的内容$title\ncontent:$content',
            ),
          )),
    );
  }
}

@RoutePage("/test6")
class Test6Page extends StatelessWidget {
  String title;
  bool content;
  int age;
  double height;
  User user;
  Text cPage;

  Test6Page({this.title, this.content, this.age, this.cPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第六个测试界面"),
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
        title: Text("第7个测试界面"),
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
  Test8Page._();

  factory Test8Page(String name) => Test8Page._();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第7个测试界面"),
      ),
      body: Center(
        child: Text(
          '这是第7个界面的内容',
        ),
      ),
    );
  }
}
