// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_state/get_state.dart';

import 'main3.dart';

///
/// 示例4: 页面级注册
///   使用injectable, 单View, 自定义Model,
///
/// 要点提示:
///  (4)处为本例重点, 如果怕写错依赖注入代码, 可以先用injectable自动生成代码,
///  然后再剪切到 (4)的位置. 注意, 不能复制, 因为重复注册会报错.

/// 本文件内容依赖于 main3
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 5. 添加依赖注入
  configDi();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('演示:4.性能优化(页面级VM的使用)'),
        ),
        body: Column(children: <Widget>[
          RaisedButton(
            child: Text('跳转到新页面'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => Page2(),
            )),
          )
        ]),
      );
}
//----------------------------------------

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  void initState() {
    /// 4. 手动注册 VM
    g.registerLazySingleton<Pg2Vm>(() => Pg2Vm());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FooView(),
        ),
      );
}

///
/// 3. View
/// 注意, 这里设置了 [isRoot] = true,
/// 如果该View被dispose,那么对应的VM也会被销毁
class FooView extends View<Pg2Vm> {
  FooView() : super(isRoot: true);

  @override
  Widget build(BuildContext c, Pg2Vm vm) => RaisedButton(
        child: Text('${vm.val}'),
        onPressed: () => vm.add,
      );
}

///
/// 2. ViewModel
/// 注意, 本ViewModel不使用注解进行全局注册,
/// 而是在Page的 initView中手动注册
class Pg2Vm extends ViewModel {
  int _model = 4;

  int get val => _model;

  get add => vmRefresh(() => _model += 1);
}

/// 1. Model
/// 这里直接摔死int作为Model
