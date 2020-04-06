const String codeRouterTemplate = """

{{#imports}}
{{{importsPath}}}
{{/imports}}
class RouterInstance implements IRouter {
  RouterInstance._() {
    BeanFactoryInstance.register();
    Router.registerRouter(this);
  }

  static RouterInstance _instance = RouterInstance._();
  static bool isRegistered = false;

  static RouterInstance get instance => _instance;

  static void register() {
    if (isRegistered) return;
    isRegistered = true;
    var i = instance;
  }

  RouteFactory onGenerateRoute = (RouteSettings settings) {
    String name = settings.name;
    Object arg = settings.arguments;
    return MaterialPageRoute(
        builder: (context) {
          return Router.getPageS(name, arg: arg);
        },
        settings: settings);
  };

  RouteFactory onUnknownRoute = (RouteSettings settings) {
    String name = settings.name;
    Object arg = settings.arguments;
    return MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: Text("Cannot find \\nuri\\n\${name}\\nargs\\n\${arg}"),
            ),
          );
        },
        settings: settings);
  };

  static Map<String,List<String>> _pageRInterceptor = {{{pageRInterceptor}}};
  static Map<RegExp, List<Pair<String, int>>> _interceptorsMap = {{{interceptors}}};
  
  @override
  bool hasRouterPage(String pageUri) => _pageRInterceptor.containsKey(pageUri);

  @override
  List<RouterInterceptorBase> getRouterPageInterceptors(String pageUri) {
    List<RouterInterceptorBase> interceptors;
    if (_pageRInterceptor.containsKey(pageUri)) {
      interceptors = _pageRInterceptor[pageUri]
          .map((s) => BeanFactory.getBean(s) as RouterInterceptorBase)
          .where((i) => i != null)
          .toList();
    } else {
      List<Pair<String, int>> iss = List.from(_interceptorsMap.entries
          .where((e) => e.key.hasMatch(pageUri))
          .map((e) => e.value)
          .reduce((v, e) => List.from(v)..addAll(e)));
      iss.sort((a, b) => b.value.compareTo(a.value));
      interceptors = iss
          .map((p) => p.key)
          .map((s) => BeanFactory.getBean(s) as RouterInterceptorBase)
          .where((i) => i != null)
          .toList();
    }
    return interceptors;
  }
}
""";

const String codeRouterTemplateBackup = """

{{#imports}}
{{{importsPath}}}
{{/imports}}

class AYMRouter {
  static AYMRouter get instance => _getInstance();
  static AYMRouter _instance;

  AYMRouter._(){
    BeanFactoryInstance.register();
  }

  factory AYMRouter() => _getInstance();

  static AYMRouter _getInstance() {
    if (_instance == null) {
      _instance = AYMRouter._();
    }
    return _instance;
  }


  RouteFactory onGenerateRoute = (RouteSettings settings) {
    String name = settings.name;
    Object arg = settings.arguments;
    try {
      RouterPageArg rp =
          instance.openOrForwardPage(RouterPageArg(name, arg: arg));
      return MaterialPageRoute(
          builder: (context) {
             var widget = BeanFactory.getBean(rp.name, params: rp.arg);
            if (widget == null) {
              return Scaffold(
                body: Center(
                  child: Text(\"Cannot find \\nuri\\n\${rp.name}\\nargs\\n\${rp.arg}\"),
                ),
              );
            }
            return widget;
          },
          settings: settings);
    } catch (e) {
      print(e);
    }
    return null;
  };

  bool canOpenPage(String pageUri, {Object arg}) {
    RouterPageArg rpa = RouterPageArg(pageUri, arg: arg);
    RouterPageArg temp = openOrForwardPage(rpa);
    return temp == rpa && temp.name == rpa.name;
  }

  RouterPageArg openOrForwardPage(RouterPageArg rpa) {
    Uri u = Uri.parse(rpa.name);
    //绿色通道 不执行检查
    if (u.queryParameters.containsKey("useGreenChannel") &&
        "true" == u.queryParameters["useGreenChannel"]) {
      return rpa;
    }
    return _runRouterPageInterceptor(rpa);
  }

  RouterPageArg _runRouterPageInterceptor(RouterPageArg rpa) {
    String pageUri = rpa.pageUri;
    List<RouterInterceptorBase> interceptors ;
    interceptors = getRouterPageInterceptors(pageUri);
    for (RouterInterceptorBase i in interceptors) {
      RouterPageArg temp = i.onInterceptor(rpa);
      if (temp != rpa || temp.name != rpa.name) {
        return temp;
      }
    }
    return rpa;
  }
  
  List<RouterInterceptorBase> getRouterPageInterceptors(String pageUri) {
    List<RouterInterceptorBase> interceptors;
    if (pageRInterceptor.containsKey(pageUri)) {
      interceptors = pageRInterceptor[pageUri]
          .map((s) => BeanFactory.getBean(s) as RouterInterceptorBase)
          .where((i) => i != null)
          .toList();
    } else {
      List<Pair<String, int>> iss = List.from(interceptorsMap.entries
          .where((e) => e.key.hasMatch(pageUri))
          .map((e) => e.value)
          .reduce((v, e) => List.from(v)..addAll(e)));
      iss.sort((a, b) => b.value.compareTo(a.value));
      interceptors = iss
          .map((p) => p.key)
          .map((s) => BeanFactory.getBean(s) as RouterInterceptorBase)
          .where((i) => i != null)
          .toList();
    }
    return interceptors;
  }

  static Map<String,List<String>> pageRInterceptor = {{{pageRInterceptor}}};
  static Map<RegExp, List<Pair<String, int>>> interceptorsMap = {{{interceptors}}};

}
""";

const String codeRouterInterceptorTemplate = """

{{#imports}}
{{{importsPath}}}
{{/imports}}

/// 构造函数中取类型map参数时要慎重，如果包含了AYMRoutePageParam的值为空 则有可能取得的是uri的query参数亦或者传入的map对象
/// 所以取类型map参数时 最好注明在所有传入参数中的key  否则不一定会得到什么  优先会传入uri的query参数亦或者传入的map对象

class AYMRouter {
  static AYMRouter get instance => _getInstance();
  static AYMRouter _instance;

  AYMRouter._(){
    BeanFactoryInstance.register();
  }

  factory AYMRouter() => _getInstance();

  static AYMRouter _getInstance() {
    if (_instance == null) {
      _instance = AYMRouter._();
    }
    return _instance;
  }

  
  RouteFactory onGenerateRoute = (RouteSettings settings) {
    String name = settings.name;
    Object arg = settings.arguments;
    try {
      RouterPageArg rp =
          instance._checkNeedRunRouterPageInterceptor(RouterPageArg(name, arg: arg));
      return MaterialPageRoute(
          builder: (context) {
            return BeanFactory.getBean(rp.name, params: rp.arg);
          },
          settings: settings);
    } catch (e) {
      print(e);
    }
    return null;
  };

  bool canOpenPage(String pageUri, {Object arg}) {
    RouterPageArg rpa = RouterPageArg(pageUri, arg: arg);
    RouterPageArg temp = _checkNeedRunRouterPageInterceptor(rpa);
    return temp == rpa && temp.name == rpa.name;
  }

  RouterPageArg _checkNeedRunRouterPageInterceptor(RouterPageArg rpa) {
    Uri u = Uri.parse(rpa.name);
    //绿色通道 不执行检查
    if (u.queryParameters.containsKey("useGreenChannel") &&
        "true" == u.queryParameters["useGreenChannel"]) {
      return rpa;
    }
    return _runRouterPageInterceptor(rpa);
  }

  RouterPageArg _runRouterPageInterceptor(RouterPageArg rpa) {
    String pageUri = rpa.pageUri;
    List<RouterInterceptorBase> interceptors = [];
    for (RouterInterceptorBase i in interceptors) {
      RouterPageArg temp = i.onInterceptor(rpa);
      if (temp != rpa || temp.name != rpa.name) {
        return temp;
      }
    }
    return rpa;
  }
}
""";
