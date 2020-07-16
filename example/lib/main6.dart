// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/24
// Time  : 19:35

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_state/get_state.dart';
import 'package:injectable/injectable.dart';

import 'main3.dart';

///
/// 示例6:
///  使用 [Recorder], 使用injectable, 多View, 自定义Model
///
/// 要点提示:
///   1.一般情况下, 不推荐(2.1)的用法,推荐使用(2.2), 或者直接(3.1)
///

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 4. 添加依赖注入
  configDi();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('演示:6. Recorder的使用'),
        ),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Center(child: Text('左右滑动可以在历史状态间切换')),
            Center(child: Text('点击按钮获取一个新的随机值')),
            // View 1
            MyCounterView(),
          ]),
        ),
      );
}

///
/// 3. View
class MyCounterView extends View<RandomDataViewModel> {
  @override
  Widget build(BuildContext c, RandomDataViewModel vm) => GestureDetector(
        child: ListTile(
          leading: Text('${vm.m.str}', style: TextStyle(fontSize: 18)),
          title: Text(
            '${vm.m.number}',
            style: TextStyle(fontSize: 30),
          ),
          trailing: FlatButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              vm.getRandomNumber();
              Scaffold.of(c).hideCurrentSnackBar();
              Scaffold.of(c).showSnackBar(SnackBar(
                content: Text('获取新的随机数'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(milliseconds: 4000),
              ));
            },
          ),
        ),
        onHorizontalDragEnd: (v) {
          print(v.primaryVelocity);
          if (v.primaryVelocity < 0) {
            vm.next();
            Scaffold.of(c).hideCurrentSnackBar();
            Scaffold.of(c).showSnackBar(
              SnackBar(
                content: Text(vm.isLatest ? '已经时最新的值了!' : '展示下一个值'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(milliseconds: 4000),
              ),
            );
          } else if (v.primaryVelocity > 0) {
            // 3.1 直接重设状态为上一个,效果等同于 vm.previous();
            vm.mPrevious;
            Scaffold.of(c).hideCurrentSnackBar();
            Scaffold.of(c).showSnackBar(SnackBar(
              content: Text(vm.isOriginal ? '已经时最初的值了!' : '展示上一个值'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(milliseconds: 4000),
            ));
          }
        },
      );
}

///
/// 2. ViewModel
@lazySingleton
class RandomDataViewModel extends ViewModel<RandomDataModel>
    with Recorder<RandomDataModel> {
  RandomDataViewModel() : super(() async => RandomDataModel(3, '初始值'));
  Random _r = Random();

  int get number => m.number;

  void getRandomNumber() {
    // 还可以使用freezed, 通过copyWith赋值, 详见 main5.dart
    vmUpdate(RandomDataModel(_r.nextInt(100), '随机值'));
  }

  // 2.1 <不推荐> 调用 mPrevious,将会返回上一个[m]的值
  RandomDataModel previous() {
    return this.mPrevious;
  }

  // 2.2 <推荐> 实际上, 如果要获取历史记录中的Model,并不一定需要 [mPrevious]或者[mNext]的返回值
  // 直接调用 [mNext]/[mPrevious]后, [m]的值将会自动切换到下一个/上一个
  void next() {
    this.mNext;
  }
}

///
/// 1. Model
class RandomDataModel extends Equatable {
  final int number;
  final String str;

  RandomDataModel(this.number, this.str);

  @override
  List<Object> get props => [number, str];
}
