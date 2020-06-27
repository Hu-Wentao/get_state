// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_state/get_state.dart';
import 'package:injectable/injectable.dart';
import 'main3.dart';

part 'main5.freezed.dart';

///
/// 示例5: 继承Model类实现, (Freezed的使用)
/// 使用injectable, 单View, 自定义Model,
///
/// 要点提示:
///   ViewModel构造中的 initModel即[vmInit]中的 initModel;
///   copyWith的使用;

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
          title: Text('演示:5.freezed的使用'),
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
  Widget build(BuildContext c, MyCounterVm vm) => ListTile(
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
  MyCounterVm() : super(initModel: CounterM(number: 5, str: '- -'));

  int get counter => m?.number;

  String get str => m?.str;

  void incrementCounter() {
    //    vmUpdate(CounterM(m.number + 1, '新的值'));
    /// 1.1 使用 copyWith
    vmUpdate(m.copyWith(number: m.number + 1));
  }
}

///
/// 1. Model 第三种实现方式 freezed
/// freezed会自动覆写toString, ==和 hashCode
@freezed
abstract class CounterM with _$CounterM {
  factory CounterM({int number, String str}) = _CounterM;
}
