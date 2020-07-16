// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:get_state/get_state.dart';

///
/// 示例2: 初级使用方法2 - 自定义Model类型,适用于较简单的状态
///   不使用injectable, 单View, 自定义Model
///
/// 要点提示:
/// 1. 自定义 Model类务必覆写 == 与 hashCode方法
/// 2. 可以使用 Equatable, 省去手动覆写

GetIt _g = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 手动依赖注入
  _g.registerSingleton<MyCounterViewModel>(MyCounterViewModel());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('演示:2.简单使用方法'),
          ),
          body: Column(children: <Widget>[
            MyCounterView(),
          ]),
        ),
      );
}

///
/// 3. View
class MyCounterView extends View<MyCounterViewModel> {
  @override
  Widget build(BuildContext c, MyCounterViewModel vm) => ListTile(
        leading: Text('测试2: ${vm.counter}'),
        title: Text('${vm.m.str}'),
        trailing: RaisedButton(
          child: Icon(Icons.add),
          onPressed: () => vm.incrementCounter(),
        ),
      );
}

///
/// 2. ViewModel
class MyCounterViewModel extends ViewModel<CounterModel> {
  MyCounterViewModel() : super(() async => CounterModel(2, '- -'));

  int get counter => m.number;

  void incrementCounter() {
    vmUpdate(CounterModel(m.number + 1, '新的值'));
  }
}

///
/// 1. Model
/// 写法1: 自定义Model类型, 内部存放两个类型
class CounterModel {
  final int number;
  final String str;

  CounterModel(this.number, this.str);

  // todo 注意, 这里务必覆写==与hashCode, 否则无法正常刷新
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterModel &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          str == other.str;

  @override
  int get hashCode => number.hashCode ^ str.hashCode;
}

/// 1. Model
/// 写法2: 使用 Equatable
class CounterModel2 extends Equatable {
  final int number;
  final String str;

  CounterModel2(this.number, this.str);

  // todo 这里需要将所有的属性值都放入 props中
  @override
  List<Object> get props => [number, str];
}
