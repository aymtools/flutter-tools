import 'package:aym_router/aym_router.dart';

@RouterInterceptor("/")
class RouterLogInterceptor extends RouterInterceptorBase {
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("start page : " + rpa.name);
    return rpa;
  }
}

@RouterInterceptor("^/test", priority: 102)
class RouterLog2Interceptor extends RouterInterceptorBase {
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("start page : " + rpa.name);
    return rpa;
  }
}

@RouterInterceptor("^/test", priority: 101)
class RouterLog3Interceptor extends RouterInterceptorBase {

  @BeanMethod()
  void init() {}

  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("start page : " + rpa.name);
    return rpa;
  }
}
