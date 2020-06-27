// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_state/get_state.dart';

import 'main3.dart';

///
/// 示例4x1: <v3.4.0+>视图级注册
///   使用injectable, 单View, 自定义Model,
///
/// 要点提示:
///   v3.4.0新增View级注册方式, 可以取代页面级注册 详见本例
///
/// (3.1)是本例重点

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
          title: Text('演示:4x1.视图级VM注册'),
        ),
        body: Column(children: <Widget>[
          RaisedButton(
            child: Text('跳转到新页面'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => Page4x1(),
            )),
          )
        ]),
      );
}
//----------------------------------------

class Page4x1 extends StatelessWidget {
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

  /// 3.1 在View创建的同时, 注册ViewModel
  /// 注意, 如果一个页面中, 有多个View共用同一个ViewModel, 推荐使用页面级别注册
  ///   如果使用视图级别注册, 只需要注册一次, 全局均可使用(同理, 如果多次注册同一个VM,则会报错)
  @override
  Pg2Vm get registerVM => Pg2Vm();

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
class Pg2Vm extends ViewModel<int> {
  Pg2Vm() : super(initModel: 4);

  int get val => m;

  get add => vmUpdate(val + 1);
}

/// 1. Model
/// 这里直接摔死int作为Model
