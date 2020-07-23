// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/6/23
// Time  : 21:22

import 'package:flutter/material.dart';
import 'package:get_state/get_state.dart';

import 'main3.dart';

///
/// 示例7: 使用页面传参初始化Model
/// 使用injectable, 多View, 自定义Model, 页面传参初始化

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
          title: Text('演示:7.使用页面传参初始化Model'),
        ),
        body: Column(children: <Widget>[
          RaisedButton(
            child: Text('跳转到新页面'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => Page7(),
            )),
          )
        ]),
      );
}

class Page7 extends StatelessWidget {
  /// [param]通过路由传递到Page7, 接下来通过build()传递给View
  final int param;

  const Page7({Key key, this.param}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ParamView(param);
  }
}

class ParamView extends View<ParamVm> {
  final int param;
  ParamView(this.param);

  /// 关键代码!
  /// 在这里初始化ViewModel持有的Model
  void onInitState(ParamVm vm) {
    vm.vmUpdate(param);
  }

  @override
  Widget build(BuildContext c, ParamVm vm) {
    return Container(
      child: Text('处理参数后得到的结果是: ${vm.info}'),
    );
  }
}

/// 这个ViewModel没有什么业务逻辑, 只有一个获取model的功能,
/// 简单包装成一个 get 方法
class ParamVm extends ViewModel<int> {
  String get info => '信息内容[$m]';
}
