const String codeAppIniterTemplate = """

{{#imports}}
{{{importsPath}}}
{{/imports}}

Widget initApp(Widget app) {
  return Builder(builder: (ctx) {
    AppInitializerRunner.initApp();
    return app;
  });
}

class AppInitializerRunner {
  static List<Pair<String, String>> _initializers = {{{initers}}};

  static void initApp() {
    {{{initBeanFactory}}}
    for (var ai in _initializers) {
      var i = BeanFactory.getBean(ai.key);
      BeanFactory.invokeMethodS(i, ai.value);
    }
  }
}
""";
