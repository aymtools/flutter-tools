import 'package:aym_router/aym_router.dart';
import 'package:example/page/test2_page.dart' as t2;
import 'package:example/page/test_page.dart';

@AYMRouterPageGenerator("router://example.router.aymtools.com/test8")
class GeneratorTestPage extends RouterPageGeneratorBase<TestPage> {
  @override
  TestPage genRouterPage(String namedConstructor,
      Map<String, dynamic> mapParams, dynamic objParam) {


    return null;
  }
}


@AYMRouterPageGenerator("/test6")
class GeneratorTest6Page extends RouterPageGeneratorBase<t2.Test6Page> {
  @override
  t2.Test6Page genRouterPage(String namedConstructor,
      Map<String, dynamic> mapParams, dynamic objParam) {


    return null;
  }
}
