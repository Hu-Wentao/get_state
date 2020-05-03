// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_state/get_state.dart';
import 'package:injectable/injectable.dart';

import 'main3.dart';

///
/// 示例5: Vm异步初始化
/// 使用injectable, 单View, 自定义Model,
///
/// 要点提示:
///   ViewModel构造中的 initModel即[vmOnInit]中的 initModel

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
          title: Text('演示:5.Vm异步初始化'),
        ),
        body: Column(children: <Widget>[
          MyCounterV(),
        ]),
      );
}
//----------------------------------------

///
/// 3. View
@lazySingleton
class MyCounterV extends View<MyCounterVm> {
  @override
  Widget build(BuildContext c, MyCounterVm vm) => vm.vmState == VmState.unInit
      ? CircularProgressIndicator()
      : ListTile(
          leading: Text('测试5: ${vm.counter}'),
          title: Text('${vm.str}'),
          trailing: RaisedButton(
            child: Icon(Icons.add),
            onPressed: () => vm.incrementCounter(),
          ),
        );
}

///
/// 2. ViewModel
@lazySingleton
class MyCounterVm extends ViewModel<CounterM> {
  MyCounterVm() : super(initModel: CounterM(5, '- -'), state: VmState.unInit);

  @override
  vmOnInit(CounterM initModel) async {
    await Future.delayed(Duration(seconds: 4));
    m = initModel;
    vmSetIdleAndNotify;
  }

  int get counter => m?.number;

  String get str => m?.str;

  void incrementCounter() {
    vmOnUpdate(CounterM(m.number + 1, '新的值'));
  }
}

///
/// 1. Model
class CounterM extends Equatable {
  final int number;
  final String str;

  CounterM(this.number, this.str);

  // 1. 这里需要将所有的属性值都放入 props中
  @override
  List<Object> get props => [number, str];
}
