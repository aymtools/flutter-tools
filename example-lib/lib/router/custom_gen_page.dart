import 'package:aym_router/aym_router.dart';
import 'package:example_lib/page/test_lib_page.dart';

@RouterPageGenerator("router://example.router.aymtools.com/test11")
class GeneratorTest11Page extends RouterPageGeneratorBase<Test10Page> {
  @override
  Test10Page genRouterPage(String namedConstructorInUri, dynamic param,
      Map<String, String> uriParams, bool canThrowException) {
    return new Test10Page();
  }
}
