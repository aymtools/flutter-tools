import 'package:aym_router/src/com/aymtools/router/core.dart';
import 'package:bean_factory/bean_factory.dart';

abstract class IRouter {
  bool hasRouterPage(String pageUri);

  List<RouterInterceptorBase> getRouterPageInterceptors(String pageUri);
}

class Router implements IRouter {
  Router._();

  static Router _instance = Router._();

  factory Router() => _instance;

  static Router get instance => _instance;

  IRouter _router;

  void bindRouter(IRouter router) {
    if (router != _router) _router = router;
  }

  static void registerRouter(IRouter router) => instance.bindRouter(router);

  static Page getPageS<Page>(String pageUri,
          {Object arg, bool isUseGreenChannel = false}) =>
      instance.getPage(pageUri, arg: arg, isUseGreenChannel: isUseGreenChannel);

  Page getPage<Page>(String pageUri,
      {Object arg, bool isUseGreenChannel = false}) {
    if (!hasRouterPage(pageUri)) return null;
    RouterPageArg rp = instance.openOrForwardPage(
        RouterPageArg(pageUri, arg: arg, isUseGreenChannel: isUseGreenChannel));
    return BeanFactory.getBean(rp.name, params: rp.arg);
  }

  static bool canOpenPageS(String pageUri,
          {Object arg, bool isUseGreenChannel = false}) =>
      instance.canOpenPage(pageUri,
          arg: arg, isUseGreenChannel: isUseGreenChannel);

  bool canOpenPage(String pageUri,
      {Object arg, bool isUseGreenChannel = false}) {
    if (!hasRouterPage(pageUri)) return false;
    RouterPageArg rpa =
        RouterPageArg(pageUri, arg: arg, isUseGreenChannel: isUseGreenChannel);
    RouterPageArg temp = openOrForwardPage(rpa);
    return temp == rpa && temp.name == rpa.name;
  }

  static RouterPageArg openOrForwardPageS(RouterPageArg rpa) =>
      instance.openOrForwardPage(rpa);

  RouterPageArg openOrForwardPage(RouterPageArg rpa) {
    Uri u = rpa.uri;
    //绿色通道 不执行检查
    if (rpa.isUseGreenChannel ||
        u.queryParameters.containsKey("useGreenChannel") &&
            "true" == u.queryParameters["useGreenChannel"]) {
      return rpa;
    }
    return _runRouterPageInterceptor(rpa);
  }

  RouterPageArg _runRouterPageInterceptor(RouterPageArg rpa) {
    String pageUri = rpa.pageUri;
    List<RouterInterceptorBase> interceptors;
    interceptors = getRouterPageInterceptors(pageUri);
    for (RouterInterceptorBase i in interceptors) {
      RouterPageArg temp = i.onInterceptor(rpa);
      if (temp != rpa || temp.name != rpa.name) {
        return temp;
      }
    }
    return rpa;
  }

  @override
  List<RouterInterceptorBase> getRouterPageInterceptors(String pageUri) =>
      _router?.getRouterPageInterceptors(pageUri) ?? [];

  static bool hasRouterPageS(String pageUri) => instance.hasRouterPage(pageUri);

  @override
  bool hasRouterPage(String pageUri) =>
      _router?.hasRouterPage(BeanFactory.getBeanUri(Uri.parse(pageUri))) ??
      false;
}
