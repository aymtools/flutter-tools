import 'package:app_initializer_generator/app_initializer_generator.dart';
import 'package:bean_factory_generator/bean_factory_generator.dart';
import 'package:source_gen/source_gen.dart';

//List<GBean> appIniters = [];

Map<GBean, GBeanMethod> appInitializers = {};

//TypeChecker _typeCheckerAppInitBase = TypeChecker.fromRuntime(AppInitializerBase);
TypeChecker _typeCheckerAppInitAnn = TypeChecker.fromRuntime(AppInitializer);
TypeChecker _typeCheckerOnInitAnn = TypeChecker.fromRuntime(OnInit);

void scanAppInitializer() {
  BeanFactoryGenerator.beanMap.values
      .where((gb) => gb.isForAnnotation(_typeCheckerAppInitAnn))
      .forEach((gb) {
    var method = gb.searchFirstMethod(checkerAnnotation: _typeCheckerOnInitAnn);
    if (method != null && method.params.length == 0) {
      appInitializers[gb] = method;
    }
    ;
  });
}
