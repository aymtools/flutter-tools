import 'package:aym_router/aym_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@RoutePage("router://example.router.aymtools.com/home")
class HomePage extends StatelessWidget {
  final String content;

  HomePage({this.content}) : super();

  @override
  Widget build(BuildContext context) {
    List<Pair<String, String>> data = [];
    data.add(Pair('正常无参的界面', 'router://example.router.aymtools.com/test1'));
    data.add(Pair('uri无scheme无host即 /test6', '/test6'));
    data.add(
        Pair('可传入一个String参数', 'router://example.router.aymtools.com/test2'));
    data.add(
        Pair('可传入各个基本类型的参数', 'router://example.router.aymtools.com/test5'));
    data.add(Pair('最复杂的参数列表界面', 'router://example.router.aymtools.com/test3'));

    return Scaffold(
      appBar: AppBar(
        title: Text("这里是主界面"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '来自Uri中的参数\ncontent:$content',
              ),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.blue,
                        ),
                    itemCount: data.length,
                    itemBuilder: (context, index) => RaisedButton(
                          child: Text('${data[index].key}'),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(data[index].value),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
