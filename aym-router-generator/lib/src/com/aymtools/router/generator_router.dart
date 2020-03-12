import 'package:analyzer/dart/element/element.dart';
import 'package:aym_router/aym_router.dart';
import 'package:aym_router_generator/src/com/aymtools/router/router_code_template.dart';
import 'package:bean_factory/bean_factory.dart';
import 'package:bean_factory_generator/bean_factory_generator.dart';
import 'package:build/build.dart';
import 'package:mustache4dart/mustache4dart.dart';
import 'package:source_gen/source_gen.dart';

import 'generator_router_interceptor.dart';

class AYMRouterGenerator extends GeneratorForAnnotation<Factory> {
  ///导入包配置 把默认的包先增加进去
  static List<Pair<String, String>> routeImports = [
    Pair("package:aym_router/aym_router.dart", ""),
    Pair("package:flutter/material.dart", ""),
    Pair("package:flutter/widgets.dart", "")
  ];

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    String key = BeanFactory.beanFactoryDartLibUri;
    routeImports.add(Pair(key, ''));
//    print(
//        "size : ${AYMRouteInterceptorGenerator.interceptors["/"]?.map((b) => b.typeName)}");
    return render(codeRouterTemplate, <String, dynamic>{
      'imports': routeImports.map((item) => {
            'importsPath': "" == item.value
                ? "import '${item.key}';"
                : "import '${item.key}' as ${item.value} ;"
          }),
      'pageRInterceptor': AYMRouteInterceptorGenerator.routePageAndInterceptors
          .map((k, v) => MapEntry(
              '"$k"', '[${v.map((v) => '"$v"').reduce((v, e) => '$v,$e')}]')),
      'interceptors': AYMRouteInterceptorGenerator.interceptors.map((k, v) =>
          MapEntry('RegExp(r"${k}")',
              '[${v.map((v) => 'Pair("${v.uri}",${v.ext})').reduce((v, e) => '$v,$e')}]')),
    });
  }
}
