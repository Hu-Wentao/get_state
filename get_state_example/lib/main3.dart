// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:get_state/getstate.dart';
import 'package:injectable/injectable.dart';

import 'main3.iconfig.dart';

///
/// 示例3:
/// 使用injectable, 多View, 自定义Model, 跨页状态更改
///
/// 要点提示:
///   1.务必在(2)处为ViewModel添加注解, 这里使用@lazySingleton
///   适用于绝大多数情况
///
///   2. 务必在(4)处添加 @injectableInit 注解, 让injectable识别初始化入口
///   完成1到5的代码编写之后, 打开terminal, 输入
///   flutter pub run build_runner watch --delete-conflicting-outputs
///   启动代码生成工具, 自动生成 "${本文件名}.iconfig.dart"文件

GetIt _g = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 5. 添加依赖注入
  configDi();
  runApp(MaterialApp(home: MyApp()));
}

// 4. 添加注解
@injectableInit
Future<void> configDi() async {
  await $initGetIt(_g);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('演示:3.标准使用方法'),
        ),
        body: Column(children: <Widget>[
          // View 1
          MyCounterView(),
          RaisedButton(
            child: Text('跳转到新页面'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => Page2(),
            )),
          ),
          RaisedButton(
            child: Text('点击更改另一个页面的值'),
            onPressed: () => _g<Pg2Vm>().add,
          ),
        ]),
      );
}

///
/// 3. View
class MyCounterView extends View<MyCounterViewModel> {
  @override
  Widget build(BuildContext c, MyCounterViewModel vm) => ListTile(
        leading: Text('测试3: ${vm.counter}'),
        title: Text('${vm.model.str}'),
        trailing: RaisedButton(
          child: Icon(Icons.add),
          onPressed: () => vm.incrementCounter(),
        ),
      );
}

///
/// 2. ViewModel
@lazySingleton
class MyCounterViewModel extends ViewModel<CounterModel2> {
  MyCounterViewModel() : super(initModel: CounterModel2(2, '- -'));

  int get counter => model.number;

  void incrementCounter() {
    vmRefresh(CounterModel2(model.number + 1, '新的值'));
  }
}

///
/// 1. Model
class CounterModel2 extends Equatable {
  final int number;
  final String str;

  CounterModel2(this.number, this.str);

  // 1. 这里需要将所有的属性值都放入 props中
  @override
  List<Object> get props => [number, str];
}
//----------------------------------------

class Page2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FooView(),
        ),
      );
}

class FooView extends View<Pg2Vm> {
  @override
  Widget build(BuildContext c, Pg2Vm vm) => RaisedButton(
        child: Text('${vm.strVal}'),
        onPressed: () => vm.add,
      );
}

@lazySingleton
class Pg2Vm extends ViewModel<int> {
  Pg2Vm() : super(initModel: 666);

  String get strVal => "$model";

  get add => vmRefresh(model + 1);
}
