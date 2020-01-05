import 'package:aym_router/aym_router.dart';

@AYMRouterInterceptor("/")
class RouterLogInterceptor extends RouterInterceptorBase{
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("start page : "+rpa.name);
    return rpa;
  }

}

@AYMRouterInterceptor("^/test")
class RouterLog2Interceptor extends RouterInterceptorBase{
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("start page : "+rpa.name);
    return rpa;
  }

}