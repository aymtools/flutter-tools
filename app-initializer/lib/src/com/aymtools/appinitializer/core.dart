import 'dart:math';

import 'package:bean_factory/bean_factory.dart';

/// 定义路由自动化初始化注解
//class AppInitRoot extends Factory {
//  /// otherInit 表示存在在其他类库中的自动初始化 路径 可以自动分模块引用 当当前模块优先级 最高
//  const AppInitRoot({List<Type> otherInit = const []})
//      : super(otherFactory: otherInit, otherImports: const [
//          'package:app_init/app_initializer.dart',
//          'package:flutter/material.dart',
//          'package:flutter/widgets.dart'
//        ]);
//}

/// 定义路由相关的类自动导出 就是写库 让库中的AYMRoutePage AYMRouterPageGenerator 自动生成lib文件
//class AppInitLibExport extends FactoryLibExport {
//  const AppInitLibExport();
//}

/// 定义自动初始化的注解
class AppInitializer extends Bean {
  const AppInitializer(
      {bool scanConstructorsUsedBlackList = false,
      bool scanSuperMethods = false})
      : super(
            keyGen: const KeyGenByClassName(),
            scanMethods: true,
            scanMethodsUsedBlackList: scanConstructorsUsedBlackList,
            scanSuperMethods: scanSuperMethods,
            needAssignableFrom: const []);
}

class OnInit extends BeanMethod {
  const OnInit() : super(key: 'onInit');
}

//abstract class AppInitializerBase {
//  void onInit();
//}
