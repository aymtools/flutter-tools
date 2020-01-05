

import 'package:aym_router/aym_router.dart';

@AYMRouterInterceptor("/")
class RouterLogInterceptor extends RouterInterceptorBase{
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("start page :"+rpa.name);
    return rpa;
  }

}