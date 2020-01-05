import 'dart:math';

import 'package:bean_factory/bean_factory.dart';

/// 定义路由注解
class AYMRouter extends Factory {
  /// otherRouter 表示存在在其他类库中的路由 路径 可以自动分模块引用 当当前模块优先级 最高
  const AYMRouter({List<Type> otherRouter = const []})
      : super(otherFactory: otherRouter, otherImports: const [
          'package:aym_router/aym_router.dart',
          'package:flutter/material.dart',
          'package:flutter/widgets.dart'
        ]);
}

/// 定义路由相关的类自动导出 就是写库 让库中的AYMRoutePage AYMRouterPageGenerator 自动生成lib文件
class AYMRouterLibExport extends FactoryLibExport {
  const AYMRouterLibExport();
}

/// 定义页面路由注解
class AYMRoutePage extends Bean {
  const AYMRoutePage(String uri) : super(uri: uri);
}

/// 指定页面的构造函数 结合AYMRoutePageConstructorParam 来指定参数来源 不指定参数来源视为无参构造
/// 只可以使用在命名构造函数上 使用在默认构造函数上时 keyInRouter指定 会生成两种构造路径
/// "" 代表默认构造函数 就是非命名构造函数
class AYMRoutePageConstructor extends BeanConstructor {
  const AYMRoutePageConstructor({String namedConstructor = ""})
      : super(namedConstructor: namedConstructor);
}

///// 指定此构造函数不能通过路由来构造 但 对默认的构造函数无效 只可以使用在命名构造函数上
//class AYMRouteNotPageConstructor {
//  const AYMRouteNotPageConstructor();
//}

/// 每个页面都必须添加一个接受此参数的构造函数
class AYMRoutePageParam extends BeanCreateParam {
  const AYMRoutePageParam(String keyInMap) : super(keyInMap);
}

/// 自定义路由页生成器 定义的类必须继承 RouterPageGeneratorBase
class AYMRouterPageGenerator extends BeanCreator {
  const AYMRouterPageGenerator(String uri) : super(uri);
}

/// 定义路由的拦截器
class AYMRouterInterceptor extends Bean {
  const AYMRouterInterceptor(String uri)
      : super(
            uri: "",
            tag: uri,
            keyGen: const KeyGenByClassName(),
            needAssignableFrom: const [RouterInterceptorBase]);
}

///自定义路由的生成器 不在提供路由的配置信息 自己完全自定义 一个uri对应一个生成策略
abstract class RouterPageGeneratorBase<Page>
    extends BeanCustomCreatorBase<Page> {
  Page create(String namedConstructorInRouter, Map<String, dynamic> mapParams,
          dynamic objParam) =>
      genRouterPage(namedConstructorInRouter, mapParams, objParam);

  Page genRouterPage(String namedConstructorInRouter,
      Map<String, dynamic> mapParams, dynamic objParam);
}

class RouterPageArg {
  String name;

//  String pageUri;

  Object arg;

  RouterPageArg(this.name, {this.arg});

  String get pageUri {
    Uri u = Uri.parse(name);
    String uri;
    List<String> pathSegments = u.pathSegments;
//    String namedConstructorInRouter = "";
    if (pathSegments.length > 0) {
      String lastPathS = pathSegments[pathSegments.length - 1];
      int lastPathSF = lastPathS.lastIndexOf(".");
      if (lastPathSF > -1) {
//        namedConstructorInRouter = lastPathS.substring(lastPathSF + 1);
        String lastPathRe = lastPathS.substring(0, lastPathSF);
        pathSegments = List.from(pathSegments, growable: false);
        pathSegments[pathSegments.length - 1] = lastPathRe;
        u = u.replace(pathSegments: pathSegments);
      } else {
//        namedConstructorInRouter = "";
      }
    } else {
      //如果是如 router://test.named 也可以尝试进行解析  但如 router://xxxx.test.named 为了安全起见 不解析 最好遵照uri的标准用法
      if (u.hasAuthority &&
          u.authority.indexOf(":") == -1 &&
          u.authority.indexOf(".") == u.authority.lastIndexOf(".")) {
        String authority = u.authority;
        int ni = authority.lastIndexOf(".");
//        namedConstructorInRouter = ni > -1 ? authority.substring(ni + 1) : "";
        String newAuthority = ni > -1 ? authority.substring(0, ni) : authority;
        u = u.replace(host: newAuthority);
      }
    }
    u = u.replace(queryParameters: {});

    uri = u.toString();

    if (uri.endsWith("?")) {
      uri = uri.substring(0, uri.length - 1);
    }
    return uri;
  }
}

///路由拦截器 必须有无参构造函数
abstract class RouterInterceptorBase {
  RouterPageArg onInterceptor(RouterPageArg rpa);
}

///但不能创建时的回调 如果回调返回了null则继续报错 如果返回了wiget 则使用返回的结果 类似 最后一次纠错机会
///全局只认一个 当出现多个时 不确定会使用哪个
///暂时未实现 也是一个坑 放弃实现 请使用onUnknownRoute 来检测
abstract class OnCannotCreateRouterPage {
  dynamic onCannotCreatePage(
      String uri, Map<String, dynamic> mapParams, dynamic objParam);
}
