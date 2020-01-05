import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator_router.dart';
import 'generator_router_interceptor.dart';

Builder routerInterceptorBuilder(BuilderOptions options) =>
    LibraryBuilder(AYMRouteInterceptorGenerator(),
        generatedExtension: ".interceptor.router.aymtools.dart");

Builder routerBuilder(BuilderOptions options) =>
    LibraryBuilder(AYMRouterGenerator(),
        generatedExtension: ".router.aymtools.dart");
