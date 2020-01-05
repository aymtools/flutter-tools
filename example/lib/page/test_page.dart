import 'package:flutter/material.dart';
import 'package:aym_router/aym_router.dart';
import 'package:example/entity/user.dart';

@AYMRoutePage("router://example.router.aymtools.com/test1")
class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第一个测试界面"),
      ),
      body: Center(
        child: Text(
          '这是第一个界面的内容',
        ),
      ),
    );
  }
}

@AYMRoutePage("router://example.router.aymtools.com/test2")
class Test2Page extends StatelessWidget {
  String content;

//  @AYMRoutePageConstructor()
  Test2Page({@AYMRoutePageParam("content") this.content});

  Test2Page.form(User user) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第二个测试界面"),
      ),
      body: Center(
        child: Text(
          '这是第二个界面，传递的参数是$content',
        ),
      ),
    );
  }
}

@AYMRoutePage("router://example.router.aymtools.com/test3")
class Test3Page extends StatelessWidget {
  String title;
  bool content;
  int age;
  double height;
  User user;

  @AYMRoutePageConstructor(namedConstructor: "jsonTest")
  Test3Page(@AYMRoutePageParam("titleRes") this.title,
      {@AYMRoutePageParam("content") this.content, this.age, this.height});

  @AYMRoutePageConstructor(namedConstructor: "json")
  Test3Page.formJson(String json) {
    title = "title form json";
  }

  @AYMRoutePageConstructor(namedConstructor: "height")
  Test3Page.height(this.height) {
    title = "no title  used height";
  }

  @AYMRoutePageConstructor(namedConstructor: "json2")
  Test3Page.formJson2(User user) {
    title = "title form ${user.name}";
  }

  Test3Page.formXML(String xml) {
    title = "title form xml";
  }

  @AYMRoutePageConstructor(namedConstructor: "formMap")
  Test3Page.formMap(Map<String, dynamic> map) {
    title = "title form xml";
  }

  @AYMRoutePageConstructor(namedConstructor: "formMap2")
  Test3Page.formMap2(@AYMRoutePageParam("map2") Map<String, String> map) {
    title = "title form xml";
  }

  @AYMRoutePageConstructor(namedConstructor: "formMap3")
  Test3Page.formMap3(Map<String, dynamic> map, {this.content}) {
    title = "title form xml";
  }

  @AYMRoutePageConstructor(namedConstructor: "formAll")
  Test3Page.formAll(this.content, Map<String, dynamic> map) {
    title = "title form xml";
  }

  @AYMRoutePageConstructor(namedConstructor: "form2Params")
  Test3Page.form2Params(
      Map<String, dynamic> mapEntity, Map<String, dynamic> mapQuery) {
    title = "title form xml";
  }

  @AYMRoutePageConstructor()
  Test3Page.all(@AYMRoutePageParam("titleRes") this.title,
      @AYMRoutePageParam("content") this.content, this.age, this.height);

  @AYMRoutePageConstructor()
  Test3Page._pri(@AYMRoutePageParam("titleRes") this.title,
      @AYMRoutePageParam("content") this.content, this.age, this.height);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第三个测试界面:$title"),
      ),
      body: Center(
        child: Text(
          '这是第三个界面，传递的参数是$content',
        ),
      ),
    );
  }
}
