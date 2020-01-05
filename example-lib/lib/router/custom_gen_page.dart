import 'package:aym_router/aym_router.dart';
import 'package:example_lib/page/test_lib_page.dart';

@AYMRouterPageGenerator("router://example.router.aymtools.com/test11")
class GeneratorTest11Page extends RouterPageGeneratorBase<Test10Page> {
  @override
  Test10Page genRouterPage(String namedConstructor,
      Map<String, dynamic> mapParams, dynamic objParam) {
    return new Test10Page();
  }
}
