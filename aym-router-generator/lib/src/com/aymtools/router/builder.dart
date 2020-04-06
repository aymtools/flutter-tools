import 'dart:async';

import 'package:aym_router_generator/aym_router_generator.dart';
import 'package:aym_router_generator/src/com/aymtools/router/gen.dart';
import 'package:aym_router_generator/src/com/aymtools/router/scan.dart';
import 'package:build/build.dart';

import 'package:dart_style/dart_style.dart';


Builder router(BuilderOptions options) => Gen();

class Gen extends Builder {
  final writeDartFileFormatter = DartFormatter();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
//    print("Router gen start");
    if (BeanFactoryGenerator.isGenerated) {
      scanRouter();
//      print("Router scan end");

      String filePath = buildStep.inputId.path;
      filePath = filePath.substring(0, filePath.lastIndexOf("/"));
      filePath = "$filePath/router.aymtools.dart";

//      print("Router gen start");

      var g = writeDartFileFormatter.format(genRouter());
//      print("Router gen end");
      await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, filePath), g);
      print("Router gen sucess!");
    }

//    print("Router run end!");
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
    if (BeanFactoryGenerator.isGenerated) {
      print("Router gen success!");
    }

    print("Router run end!");
  }

  @override
  Iterable<String> get inputExtensions => ['beanfactory.aymtools.dart'];
}
