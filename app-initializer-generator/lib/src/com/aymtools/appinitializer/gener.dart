import 'package:app_initializer/app_initializer.dart';
import 'package:app_initializer_generator/src/com/aymtools/appinitializer/scnner.dart';
import 'package:bean_factory_generator/bean_factory_generator.dart';
import 'package:mustache4dart/mustache4dart.dart';

import 'code_template.dart';

List<Pair<String, String>> _imports = [
  Pair("package:app_initializer/app_initializer.dart", ""),
  Pair("package:flutter/material.dart", ""),
  Pair("package:flutter/widgets.dart", "")
];

String genAppInitializer() {
  _imports.add(Pair(BeanFactoryGenerator.beanFactoryDartLibUri, ''));
  return render(
    codeAppIniterTemplate,
    <String, dynamic>{
      'imports': _imports.map((item) => {
            'importsPath': "" == item.value
                ? "import '${item.key}';"
                : "import '${item.key}' as ${item.value} ;"
          }),
      'initBeanFactory': 'BeanFactoryInstance.register();',
      'initers': appInitializers == null || appInitializers.isEmpty
          ? '[]'
          : appInitializers.entries
              .map((e) => "Pair('${e.key.uri}', '${e.value.methodNameKey}')")
              .toList()
              .toString(),
//      'interceptors': interceptors == null || interceptors.isEmpty
//          ? '{}'
//          : interceptors.map((k, v) => MapEntry('RegExp(r"${k}")',
//              '[${v.map((v) => 'Pair("${v.uri}",${v.ext})').fold('', (p, e) => p == '' ? e : '$p,$e')}]')),
    },
  );
}
