// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/2
// Time  : 16:41

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_state/get_state.dart';

///
/// 示例1: 初级使用方法 - 适用于数量较少,类型较简单的状态
/// 不使用injectable, 单View, 不使用自定义Model
///
/// 注:
///   请自下而上查看本例源码
///
/// 1. 编写 Model类
///   Model类就是供View展示的数据
///   本例使用int类型作为Model, 因此无需编写
///
/// 2. 编写 ViewModel类
///   ViewModel负责业务逻辑和操作视图
///   这里的操作 Model的方法相当于 BLoC中的 Event
///
/// 3. 编写 View类
///   View类负责视图展示, 尽量将所有的视图动作移动到 ViewModel中
///
/// 4. 将 View放到 Widget树中
///
/// 5. 在 main方法中注册依赖,
///   使用 registerSingleton<T>()方法以懒单例的方式使用ViewModel
///   get_it 还有更多的注册方式, 这里暂时只介绍这一种

GetIt _g = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 5.依赖注入, 确保View可以获取到ViewModel
  _g.registerSingleton<MyCounterViewModel>(MyCounterViewModel());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '演示:1.初级使用方法',
        home: Scaffold(
          appBar: AppBar(),
          body: Column(children: <Widget>[
            // 4. 将视图放入需要的地方
            MyCounterView(),
          ]),
        ),
      );
}

///
/// View
/// 3. View就是最终展示出来的Widget
class MyCounterView extends View<MyCounterViewModel> {
  @override
  Widget build(BuildContext c, MyCounterViewModel vm) => ListTile(
        title: Text('测试1: ${vm.counter}'),
        trailing: RaisedButton(
          child: Icon(Icons.add),
          onPressed: () => vm.incrementCounter(),
        ),
      );
}

///
/// ViewModel
/// 2. ViewModel主要负责业务逻辑, 在泛型中指定ViewModel所使用的Model类型
class MyCounterViewModel extends ViewModel<int> {
  // 2.1 在ViewModel的构造中, 提供默认的初始值
  MyCounterViewModel() : super(()async=> 1);

//  MyCounterViewModel(int initModel) : super(()async=> initModel);

  // 2.2 获取Model方法
  int get counter => m;

  // 2.3 操作Model方法,
  // 调用 父类中的vmRefresh()方法更新model的值
  void incrementCounter() => vmUpdate(m + 1);
}

///
/// Model
/// 1. Model类就是视图所展示的数据,
/// 本例直接使用int类型作为model
