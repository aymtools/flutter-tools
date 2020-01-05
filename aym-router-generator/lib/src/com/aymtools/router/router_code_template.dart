const String codeRouterTemplate = """

{{#imports}}
{{{importsPath}}}
{{/imports}}

/// 构造函数中取类型map参数时要慎重，如果包含了AYMRoutePageParam的值为空 则有可能取得的是uri的query参数亦或者传入的map对象
/// 所以取类型map参数时 最好注明在所有传入参数中的key  否则不一定会得到什么  优先会传入uri的query参数亦或者传入的map对象

class AYMRouter {
  static AYMRouter get instance => _getInstance();
  static AYMRouter _instance;

  AYMRouter._internal();

  factory AYMRouter() => _getInstance();

  static AYMRouter _getInstance() {
    if (_instance == null) {
      _instance = AYMRouter._internal();
    }
    return _instance;
  }


  RouteFactory onGenerateRoute = (RouteSettings settings) {
    String name = settings.name;
    Object arg = settings.arguments;
    try {
      RouterPageArg rp =
          instance.checkOpenOrForwardPage(RouterPageArg(name, arg: arg));
      return MaterialPageRoute(
          builder: (context) {
            return BeanFactory.createBean(rp.name, params: rp.arg);
          },
          settings: settings);
    } catch (e) {
      print(e);
    }
    return null;
  };

  bool canOpenPage(String pageUri, {Object arg}) {
    RouterPageArg rpa = RouterPageArg(pageUri, arg: arg);
    RouterPageArg temp = checkOpenOrForwardPage(rpa);
    return temp == rpa && temp.name == rpa.name;
  }

  RouterPageArg checkOpenOrForwardPage(RouterPageArg rpa) {
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
    if (pageRInterceptor.containsKey(pageUri)) {
      interceptors = pageRInterceptor[pageUri]
          .map((s) => BeanFactory.createBean(s) as RouterInterceptorBase)
          .where((i) => i != null)
          .toList();
    } else {
      interceptors = interceptorsMap.entries
          .where((e) => e.key.hasMatch(pageUri))
          .map((e) => e.value)
          .reduce((v, e) => v..addAll(e))
          .map((s) => BeanFactory.createBean(s) as RouterInterceptorBase)
          .where((i) => i != null)
          .toList();
    }
    for (RouterInterceptorBase i in interceptors) {
      RouterPageArg temp = i.onInterceptor(rpa);
      if (temp != rpa || temp.name != rpa.name) {
        return temp;
      }
    }
    return rpa;
  }
  
  static Map<String,List<String>> pageRInterceptor = {{{pageRInterceptor}}};
  static Map<RegExp, List<String>> interceptorsMap = {{{interceptors}}};

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

  AYMRouter._internal();

  factory AYMRouter() => _getInstance();

  static AYMRouter _getInstance() {
    if (_instance == null) {
      _instance = AYMRouter._internal();
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
            return BeanFactory.createBean(rp.name, params: rp.arg);
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