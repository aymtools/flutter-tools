import 'package:bean_factory/bean_factory.dart';

//const List<String> _imports = [
//  'package:aym_router/aym_router.dart',
//  'package:flutter/material.dart',
//  'package:flutter/widgets.dart'
//];

/// 定义路由注解
/// 亦可以直接使用@BeanFactory，手动加入相关导入即可
class AYMRouterRoot extends Factory {
  /// otherRouter 表示存在在其他类库中的路由 路径 可以自动分模块引用 当当前模块优先级 最高
  const AYMRouterRoot({List<String> importLibsName = const []})
      : super(importLibsName: importLibsName);
}

/// 定义路由相关的类自动导出 就是写库 让库中的AYMRoutePage AYMRouterPageGenerator 自动生成lib文件
/// 不建议继续使用，请使用@BeanFactoryLibExport
class AYMRouterLibExport extends BeanFactoryLibExport {
  const AYMRouterLibExport();
}

/// 定义页面路由注解
class RoutePage extends Bean {
  const RoutePage(String uri, {bool scanConstructorsUsedBlackList = false})
      : super(
            key: uri,
            scanConstructorsUsedBlackList: scanConstructorsUsedBlackList);
}

/// 指定页面的构造函数 结合RoutePageConstructorParam 来指定参数来源 不指定参数来源视为无参构造
/// 只可以使用在命名构造函数上 使用在默认构造函数上时 keyInRouter指定 会生成两种构造路径
/// "" 代表默认构造函数 就是非命名构造函数
class RoutePageConstructor extends BeanConstructor {
  const RoutePageConstructor({String namedConstructor = ""})
      : super(namedConstructor: namedConstructor);
}

class RoutePageConstructorNot extends BeanConstructorNot {
  const RoutePageConstructorNot() : super();
}

///// 指定此构造函数不能通过路由来构造 但 对默认的构造函数无效 只可以使用在命名构造函数上
//class AYMRouteNotPageConstructor {
//  const AYMRouteNotPageConstructor();
//}

/// 每个页面都必须添加一个接受此参数的构造函数
class RoutePageParam extends BeanConstructorParam {
  const RoutePageParam(String keyInMap) : super(keyInMap: keyInMap);
}

/// 自定义路由页生成器 定义的类必须继承 RouterPageGeneratorBase
class RouterPageGenerator extends BeanCreator {
  const RouterPageGenerator(String uri) : super(uri);
}

/// 定义路由的拦截器
class RouterInterceptor extends Bean {
  ///uri 正则表达式所匹配的url priority等级 默认100 从到到底排序 等级越高约优先执行
  const RouterInterceptor(String uri, {int priority = 100})
      : super(
          key: "",
          tag: uri,
          ext: priority,
          keyGen: const KeyGenByClassName(),
          needAssignableFrom: const [RouterInterceptorBase],
          scanConstructors: false,
          scanMethods: true,
          scanFields: true,
        );
}

///自定义路由的生成器 不在提供路由的配置信息 自己完全自定义 一个uri对应一个生成策略
abstract class RouterPageGeneratorBase<Page>
    extends BeanCustomCreatorBase<Page> {
  Page genRouterPage(String namedConstructorInRouter, dynamic param,
      Map<String, String> uriParams, bool canThrowException);

  @override
  Page create(String namedConstructorInUri, dynamic param,
          Map<String, String> uriParams, bool canThrowException) =>
      genRouterPage(namedConstructorInUri, param, uriParams, canThrowException);
}

class RouterPageArg {
  String _name;
  Uri _uri;

  Object arg;

  final bool isUseGreenChannel;

  RouterPageArg(this._name, {this.arg, bool isUseGreenChannel})
      : this.isUseGreenChannel = isUseGreenChannel ?? false,
        this._uri = Uri.parse(_name);

  String get pageUri => BeanFactory.getBeanUri(uri);

  Uri get uri => _uri;

  String get name => _name;

  set name(String value) {
    this._name = name;
    _uri = Uri.parse(_name);
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
