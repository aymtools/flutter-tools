import 'dart:async';

import 'package:aym_router_generator/aym_router_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator_router.dart';
import 'generator_router_interceptor.dart';

Builder routerInterceptorBuilder(BuilderOptions options) =>
    LibraryBuilder(AYMRouteInterceptorGenerator(),
        generatedExtension: ".interceptor.router.aymtools.dart");

Builder routerBuilder(BuilderOptions options) =>
    LibraryBuilder(AYMRouterGenerator(),
        generatedExtension: ".router.aymtools.dart");

Builder router(BuilderOptions options) => Gen();

class Gen extends Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    print("Router gen start");
    if (BeanFactory.isGenerated) {
      print("Router gen success!");
    }

    print("Router run end!");
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        'beanfactory.dart': [
          'router.aymtools.dart',
        ]
      };
}

PostProcessBuilder buildRouter(BuilderOptions options) => GenRouter();

class GenRouter extends PostProcessBuilder {
  @override
  FutureOr<void> build(PostProcessBuildStep buildStep) {
    print("Router gen start");
    if (BeanFactory.isGenerated) {
      print("Router gen success!");
    }

    print("Router run end!");
  }

  @override
  Iterable<String> get inputExtensions => ['beanfactory.aymtools.dart'];
}
