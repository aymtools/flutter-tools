import 'package:aym_router/aym_router.dart';

import '../../entity/user.dart';

@RouterInterceptor("/")
class RouterLogInterceptor extends RouterInterceptorBase {
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print(" RouterLogInterceptor start page : " + rpa.name);
    return rpa;
  }
}

@RouterInterceptor("^/test", priority: 102)
class RouterLog2Interceptor extends RouterInterceptorBase {
  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("RouterLog2Interceptor start page : " + rpa.name);
    return rpa;
  }
}

@RouterInterceptor("^/test", priority: 101)
class RouterLog3Interceptor extends RouterInterceptorBase {
  @BeanField()
  String testSearch;

  @BeanMethod()
  void init() {}

  @BeanMethod()
  String init2(String msg) => msg;

  @BeanMethod()
  bool init3(String msg, {bool flag, User user}) => flag;

  @override
  RouterPageArg onInterceptor(RouterPageArg rpa) {
    print("RouterLog3Interceptor start page : " + rpa.name);
    return rpa;
  }
}
