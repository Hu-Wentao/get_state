// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_state/get_state.dart';
import 'package:injectable/injectable.dart';
import 'main3.dart';

part 'main5.freezed.dart';

///
/// 示例5: 继承Model类实现, (Freezed的使用)
/// 使用injectable, 单View, 自定义Model,
///
/// 要点提示:
/// * ViewModel构造中的 initModel即[vmInit]中的 initModel;
/// * copyWith的使用;

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
        title: Text('${vm.strVal}'),
        trailing: RaisedButton(
          child: Icon(Icons.add),
          onPressed: () => vm.incrementCounter(),
        ),
      );
}

///
/// 2. ViewModel
@lazySingleton
class MyCounterVm extends ViewModel {
  CounterM _model;

  MyCounterVm() : _model = CounterM(number: 5, str: '- -');

  int get counter => _model.number;
  String get strVal => _model.str;

  void incrementCounter() =>
      vmRefresh(() => _model = _model.copyWith(number: _model.number + 1));
}

///
/// 1. Model 第三种实现方式 freezed
/// freezed会自动覆写toString, ==和 hashCode
/// * freezed使用:
///   1.0 添加 @freezed 注解
///   1.1 将Model改为抽象类
///   1.2 with _$[类名],
///   1.3 添加带可选参数的工厂构造, 并指向 _[类名], 参数即稍后生成的类的字段.
///   (此时相关文件尚未生成, _$[类名], _[类名] 都不存在)
///   1.4 在控制台输入 flutter pub run build_runner watch, 自动生成代码
///   (注意检查yaml是否添加了相关的依赖, freezed, build_runner等)
///
@freezed
abstract class CounterM with _$CounterM {
  factory CounterM({int number, String str}) = _CounterM;
}
