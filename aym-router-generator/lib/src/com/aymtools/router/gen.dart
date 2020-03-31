import 'package:aym_router_generator/aym_router_generator.dart';
import 'package:aym_router_generator/src/com/aymtools/router/code_template.dart';
import 'package:aym_router_generator/src/com/aymtools/router/scan.dart';
import 'package:bean_factory/bean_factory.dart';
import 'package:mustache4dart/mustache4dart.dart';

List<Pair<String, String>> _routeImports = [
  Pair("package:aym_router/aym_router.dart", ""),
  Pair("package:flutter/material.dart", ""),
  Pair("package:flutter/widgets.dart", "")
];

String genRouter() {
  _routeImports.add(Pair(BeanFactory.beanFactoryDartLibUri, ''));
  return render(codeRouterTemplate, <String, dynamic>{
    'imports': _routeImports.map((item) => {
          'importsPath': "" == item.value
              ? "import '${item.key}';"
              : "import '${item.key}' as ${item.value} ;"
        }),
    'pageRInterceptor': routePageAndInterceptors == null ||
            routePageAndInterceptors.isEmpty
        ? '{}'
        : routePageAndInterceptors.map((k, v) => MapEntry(
            '"$k"', '[${v.map((v) => '"$v"').fold('', (p, e) =>  p == '' ? e :'$p,$e')}]')),
    'interceptors': interceptors == null || interceptors.isEmpty
        ? '{}'
        : interceptors.map((k, v) => MapEntry('RegExp(r"${k}")',
            '[${v.map((v) => 'Pair("${v.uri}",${v.ext})').fold('', (p, e) => p == '' ? e : '$p,$e')}]')),
  });
}
