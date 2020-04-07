import 'package:aym_router/aym_router.dart';
import 'package:example_lib/entity/book.dart';
import 'package:flutter/material.dart';

@RoutePage("router://example.router.aymtools.com/test10")
class Test10Page extends StatelessWidget {
  final String name;

  Test10Page({this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("在第三方库中的界面"),
      ),
      body: Center(
        child: GestureDetector(
          child: Text(
            'Hello $name \n这是在第三方库中的界面内容,点击跳回测试界面2 并传入content=Hello. I\'m back',
          ),
          onTap: () => Navigator.of(context).pushNamed(
              "router://example.router.aymtools.com/test2",
              arguments: {"content": 'Hello. I\'m back'}),
        ),
      ),
    );
  }
}
