import 'dart:async';

import 'package:app_initializer_generator/src/com/aymtools/appinitializer/gener.dart';
import 'package:app_initializer_generator/src/com/aymtools/appinitializer/scnner.dart';
import 'package:bean_factory_generator/bean_factory_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:dart_style/dart_style.dart';


Builder appInit(BuilderOptions options) => Gen();

class Gen extends Builder {
  final writeDartFileFormatter = DartFormatter();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
//    print("AppInitializer gen start");
    if (BeanFactoryGenerator.isGenerated) {
      scanAppInitializer();
//      print("AppInitializer scan end");

      String filePath = buildStep.inputId.path;
      filePath = filePath.substring(0, filePath.lastIndexOf("/"));
      filePath = "$filePath/appinitializer.aymtools.dart";

//      print("AppInitializer gen start");

      var g = writeDartFileFormatter.format(genAppInitializer());
//      print("AppInitializer gen end");
      await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, filePath), g);
      print("AppInitializer gen sucess!");
    }

//    print("AppInitializer run end!");
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    'beanfactory.dart': [
      'appinitializer.aymtools.dart',
    ]
  };
}