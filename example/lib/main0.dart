// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_state/get_state.dart';

///
/// 示例0:  本例仅供了解 get_state原理, 并不推荐本例中的写法
/// 不使用injectable, 不使用View, 不使用自定义Model
///
/// 注:
///   请 自下而上 查看本例源码
///
/// 1. 编写ViewModel类
///   ViewModel负责业务逻辑和操作视图
///   这里的操作Model的方法相当于BLoC中的Event
///
/// 2. 在main方法中注册ViewModel,
///   使用 GetIt g = GetIt.instance; 获取GetIt实例
///   添加 WidgetsFlutterBinding.ensureInitialized(); 以防止ViewModel注册失败
///   使用 registerSingleton<T>(<构造方法>) 以懒单例的方式使用ViewModel
///   get_it 还有更多的注册方式, 这里暂时只介绍这一种

GetIt g = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 4.手动注入依赖, 确保View可以获取到ViewModel
  g.registerSingleton<CounterVm>(CounterVm());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('演示:0.极简使用方法'),
          ),
          body: Center(
            child: Text('测试0: ${g<CounterVm>().counter()}'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => g<CounterVm>().incrementCounter(),
          ),
        ),
      );
}

///
/// ViewModel
/// 1. ViewModel主要负责业务逻辑,
/// 在泛型中指定ViewModel所使用的Model类型, 本例使用int类型
class CounterVm extends ViewModel<int> {
  // 1.1 在ViewModel的构造中, 提供默认的初始值
  CounterVm() : super(initModel: 0);

  // 1.2 获取Model方法, 这里的model时父类中的属性,其类型用本类泛型指定
  int counter() => m;

  // 1.3 操作Model方法,
  // 调用 父类中的vmUpdate()方法更新model的值
  void incrementCounter() {
    vmUpdate(m + 1);
  }
}
