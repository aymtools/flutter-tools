import 'package:analyzer/dart/element/element.dart';
import 'package:aym_router/aym_router.dart';
import 'package:bean_factory_generator/bean_factory_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class AYMRouteInterceptorGenerator extends GeneratorForAnnotation<Factory> {
  static Map<String, List<GBean>> interceptors = {};
  static Map<RegExp, List<GBean>> _interceptorRegExps = {};

  static Map<String, String> routeInterceptorImports = {};
  static Map<String, List<String>> routePageAndInterceptors = {};

  TypeChecker _routerInterceptorChecker =
      TypeChecker.fromRuntime(RouterInterceptorBase);
  TypeChecker _routerInterceptorAnnChecker =
      TypeChecker.fromRuntime(RouterInterceptor);
  TypeChecker _routerPageAnnChecker = TypeChecker.fromRuntime(RoutePage);
  TypeChecker _routerPageCreatorAnnChecker =
      TypeChecker.fromRuntime(RouterPageGenerator);

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {

    print('RouteInterceptor Scaning');
//    AYMRouterGenerator.routeImports
//        .forEach((p) => routeInterceptorImports[p.key] = p.value);
    BeanFactoryGenerator.beanMap.values
        .where((gb) => gb.annotation.instanceOf(_routerInterceptorAnnChecker))
        .where((gb) =>
            gb.element != null &&
            !_routerInterceptorChecker.isAssignableFrom(gb.element))
        .forEach((gb) {
      List<GBean> interceptor = interceptors[gb.tag];
      if (interceptor == null) {
        interceptor = <GBean>[];
        interceptors[gb.tag] = interceptor;
      }
      interceptor.add(gb);
      routeInterceptorImports[gb.sourceUri] = gb.typeAsStr;
    });
//    interceptors.entries.forEach((e) {
//      print(
//          "RegExp:${e.key} size:${e.value.length} vale:${e.value.map((b) => b.typeName).toList()}");
//    });
//    _interceptorRegExps.addEntries(newEntries)
    _interceptorRegExps.addEntries(interceptors.entries
        .map((e) => e..value.sort((a, b) => b.ext.compareTo(a.ext)))
        .map((e) => MapEntry(RegExp(e.key), e.value)));

    routePageAndInterceptors.addEntries(BeanFactoryGenerator
        .beanCreatorMap.values
        .where((bc) => bc.annotation.instanceOf(_routerPageCreatorAnnChecker))
        .map(
          (b) => Pair(
            b,
            _interceptorRegExps.entries
                .where((me) => me.key.hasMatch(b.uri))
                .map((f) => f.value)
                .reduce((v, e) => List.from(v)..addAll(e))
                .toSet()
                .toList()
                  ..sort((a, b) => b.ext.compareTo(a.ext)),
          ),
        )
        .map((e) => MapEntry(e.key.uri, e.value.map((v) => v.uri).toList())));
    routePageAndInterceptors.addEntries(BeanFactoryGenerator.beanMap.values
        .where((b) => b.annotation.instanceOf(_routerPageAnnChecker))
        .where((b) => !routePageAndInterceptors.containsKey(b.uri))
        .map(
          (b) => Pair(
            b,
            _interceptorRegExps.entries
                .where((me) => me.key.hasMatch(b.uri))
                .map((f) => f.value)
                .reduce((v, e) => List.from(v)..addAll(e))
                .toSet()
                .toList()
                  ..sort((a, b) => b.ext.compareTo(a.ext)),
          ),
        )
        .map((e) => MapEntry(e.key.uri, e.value.map((v) => v.uri).toList())));
    return null;
//    return _genRouterInterceptor();
  }

  Future<String> _genRouterInterceptor() async {
    String result = routeInterceptorImports.entries
        .where((i) => "dart:core" != i.key)
        .map((item) => "" == item.value
            ? "import '${item.key}';"
            : "import '${item.key}' as ${item.value} ;")
        .fold("", (i, n) => i + n);
    result += _genMap();
    result = BeanFactoryGenerator.beanMap.values
        .where((b) => b.annotation.instanceOf(_routerPageAnnChecker))
        .map((b) => Pair(
            b,
            _interceptorRegExps.entries
                .where((me) => me.key.hasMatch(b.uri))
                .map((f) => f.value)
                .reduce((v, e) => v..addAll(e))))
        .map((e) => _genRouterInterceptorClass(e.key, e.value))
        .fold(result, (i, n) => i + n);

//    result = interceptors.entries
//        .map((e) => _genRouterInterceptorClass(e.key, e.value))
//        .fold(result, (i, n) => i + n);

    return result;
  }

  String _genMap() {
    String s = routePageAndInterceptors.entries
        .map((e) =>
            '"${e.key}":[${e.value.map((v) => '"$v"').reduce((v, e) => '$v,$e')}]')
        .reduce((v, e) => '$v,$e');
    return """
class Runner  {
  static Map<String,List<String>> pi={${s}};
  static Map<RegExp, List<String>> interceptors = {${interceptors.entries.map((e) => 'RegExp(r"${e.key}"):[${e.value.map((v) => '"${v.uri}"').reduce((v, e) => '$v,$e')}]').reduce((v, e) => '$v,$e')}};
}
    """;
  }

  String _genRouterInterceptorClass(
      GBean routerPage, List<GBean> routerPageInterceptors) {
    return """
class ${routerPage.clsType}InterceptorRunner  {
 
}
    """;
  }
}
