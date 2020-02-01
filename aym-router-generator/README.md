 AYMRouter generator Dart libraries.
 A flutter routing generator that automatically generates routing tables when compiling. 
 Need to use with aym_router.
 
 # 简介
 
 一个以注解方式实现的路由映射解决方案，基于 bean_factory
 
 # 使用
 
 1. 你的页面包含任意多构造器（当然仅包含无参的默认也是可以的），会根据传入的参数自动寻找合适的构造，然后使用@RoutePage 注解你的页面类  
    例：
 
    ```Dart
    @RoutePage("router://example.router.aymtools.com/test1")
    class A {
      String name;
      bool flag;
      int age;
      double height;
      //必须包含name其他非必须
      A(this.name,{this.flag,this.age,this.height});
      //必须包含height 无需其他参数
      A(this.height);
    }
    ```
    更多用法请参考example内容
  
 2. 使用 **@AYMRouterRoot** 注解 **你自己**的 router 类
    例：
 
    ```Dart
    @AYMRouterRoot()
    class MyRouter {}
    ```
 
 3. 在你的工作目录下运行如下命令:  
    build:
 
    ```shell
     flutter packages pub run build_runner build --delete-conflicting-outputs
    ```
 
    建议在执行 build 命令前，先执行如下命令:  
     clean:
 
    ```shell
     flutter packages pub run build_runner clean
    ```
 
 4. 接下来修改main.dart中的App中的onGenerateRoute  
    例：
 
    ```Dart
      
    void main() {
      runApp(MyApp());
    }
    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Flutter Demo',
          initialRoute: "router://example.router.aymtools.com/test1",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
          //修改此处，将路由的表交给AYMRouter处理 当然您也可以自己处理
          onGenerateRoute: AYMRouter.instance.onGenerateRoute,
        );
      }
    }
    ```
    
 5. 使用的具体方式依然同默认的Navigator
 
   ```Dart
    @RoutePage("router://example.router.aymtools.com/test2")
    class Test2Page extends StatelessWidget{
     @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("第二个测试界面"),
          ),
          body: Center(
              child: GestureDetector(
            onTap: () { 
                Navigator.of(context).pushNamed(
                        'router://example.router.aymtools.com/test1',
                        arguments: "this is title"); 
                    
                //这是调用height参数
                Navigator.of(context).pushNamed(
                        "router://example.router.aymtools.com/test1",
                        arguments: 185); 
                //直接使用uri参数
                Navigator.of(context).pushNamed(
                        'router://example.router.aymtools.com/test1?title=mytitle'); 
                //使用map传入更多参数
                Navigator.of(context).pushNamed(
                        'router://example.router.aymtools.com/test1',
                        arguments: {'title':'this is title','flag':true}); 
            },
            child: Text(
              '更多内容',
            ),
          )),
        );
      }
   }
    
   ```


更多内容可以参考 example/\*下的文件
 
 # 安装
 
 ## 从 pub 安装
 
 在你的 pubspec.yaml 文件下声明  
 例：
 
 ```yaml
  dependencies:
    aym_router: any

  dev_dependencies:
    aym_router_generator: any
 ```
 