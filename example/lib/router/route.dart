import 'package:aym_router/aym_router.dart';
import 'package:example_lib/example_lib.dart'
    as R1; // 此处引入时必须使用库引入 如果单dart文件引入在无法加载库中的路由信息

@AYMRouter(otherRouter: [R1.Router])
class Router {}
