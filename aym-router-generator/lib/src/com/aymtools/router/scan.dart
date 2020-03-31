import 'package:aym_router/aym_router.dart';
import 'package:bean_factory_generator/bean_factory_generator.dart';
import 'package:source_gen/source_gen.dart';

Map<String, List<GBean>> interceptors = {};
Map<RegExp, List<GBean>> _interceptorRegExps = {};

Map<String, String> routeInterceptorImports = {};
Map<String, List<String>> routePageAndInterceptors = {};

TypeChecker _routerInterceptorChecker =
    TypeChecker.fromRuntime(RouterInterceptorBase);
TypeChecker _routerInterceptorAnnChecker =
    TypeChecker.fromRuntime(RouterInterceptor);
TypeChecker _routerPageAnnChecker = TypeChecker.fromRuntime(RoutePage);
TypeChecker _routerPageCreatorAnnChecker =
    TypeChecker.fromRuntime(RouterPageGenerator);

void scanRouter() {
//  print('RouteInterceptor Scaning');
//    AYMRouterGenerator.routeImports
//        .forEach((p) => routeInterceptorImports[p.key] = p.value);
  BeanFactoryGenerator.beanMap.values
      .where((gb) => gb.annotation.instanceOf(_routerInterceptorAnnChecker))
      .where((gb) =>
          gb.element != null &&
          _routerInterceptorChecker.isAssignableFrom(gb.element))
      .forEach((gb) {
    List<GBean> interceptor = interceptors[gb.tag];
    if (interceptor == null) {
      interceptor = <GBean>[];
      interceptors[gb.tag] = interceptor;
    }
    interceptor.add(gb);
    routeInterceptorImports[gb.sourceUri] = gb.typeAsStr;
  });
//  print('RouteInterceptor Scaning1');
//    interceptors.entries.forEach((e) {
//      print(
//          "RegExp:${e.key} size:${e.value.length} vale:${e.value.map((b) => b.typeName).toList()}");
//    });
//    _interceptorRegExps.addEntries(newEntries)
  _interceptorRegExps.addEntries(interceptors.entries
      .map((e) => e..value.sort((a, b) => b.ext.compareTo(a.ext)))
      .map((e) => MapEntry(RegExp(e.key), e.value)));

//  print('RouteInterceptor Scaning2');
  routePageAndInterceptors.addEntries(BeanFactoryGenerator.beanCreatorMap.values
      .where((bc) => bc.annotation.instanceOf(_routerPageCreatorAnnChecker))
      .map(
        (b) => Pair(
          b,
          _interceptorRegExps.entries
              .where((me) => me.key.hasMatch(b.uri))
              .map((f) => f.value)
              .fold<List<GBean>>([],
                  (previousValue, element) =>previousValue..addAll(element))
              .toSet()
              .toList()
                ..sort((a, b) => b.ext.compareTo(a.ext)),
        ),
      )
      .map((e) => MapEntry(e.key.uri, e.value.map((v) => v.uri).toList())));
//  print('RouteInterceptor Scaning3');
  routePageAndInterceptors.addEntries(BeanFactoryGenerator.beanMap.values
      .where((b) => b.annotation.instanceOf(_routerPageAnnChecker))
      .where((b) => !routePageAndInterceptors.containsKey(b.uri))
      .map(
        (b) => Pair(
          b,
          _interceptorRegExps.entries
              .where((me) => me.key.hasMatch(b.uri))
              .map((f) => f.value)
              .fold<List<GBean>>([],
                  (previousValue, element) =>previousValue..addAll(element))
              .toSet()
              .toList()
                ..sort((a, b) => b.ext.compareTo(a.ext)),
        ),
      )
      .map((e) => MapEntry(e.key.uri, e.value.map((v) => v.uri).toList())));
}
