// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/12
// Time  : 23:47

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// 一些第三方插件(例如 Hive）
/// (特别是一些需要耗时初始化的插件)
@registerModule
abstract class RegisterModule {
  /// 测试3, 这里用 preResolve, 可以生成await 代码 <<成功>>
  @preResolve
  Future<Test2> get testTwo => Test2.numberTwo();

  @preResolve
  Future<Test> get testOne => Test.numberOne();

  @preResolve
  @Named('str') // 可选
  Future<Test3<String>> get testThree => Test3.numberThree();

  @preResolve
  Future<Test3<int>> get testThreeInt => Test3.numberThree();
}

/// 测试2, 可能应当直接在Test类上标注
/// @injectable
///  : 使用 @injectable, 并且implements WillSignalReady,GetIt报错, "不能使用async Factory"...
///   去除了 implement还是报一样的错, 尝试改为 @lazySingleton
///   修改为 @lazy.., 提示Test类没有 Ready, 于是又加上 impl..Will...
///   又添加外
/// 经过上面的多次尝试, 已经说明了: 异步返回结果的类, 只能使用registerModule+preResolve解决, 而不能自己添加注解
class Test implements WillSignalReady {
  final int number;
  Test(this.number);
  static Future<Test> numberOne() async =>
      Future.delayed(const Duration(seconds: 1)).then((_) => Test(1));
}

//@lazySingleton
class Test2 implements WillSignalReady {
  final int number;

  Test2(this.number);

//  @factoryMethod
  static Future<Test2> numberTwo() async {
    return Future.delayed(const Duration(seconds: 1)).then((_) => Test2(2));
  }
}

/// test3 类仅使用 registerModule 来注册
class Test3<T> implements WillSignalReady {
  final T msg;
  final int number;

  Test3(this.number, this.msg);

  static Future<Test3<T>> numberThree<T>() async {
    T tt;
    return Future.delayed(const Duration(seconds: 1))
        .then((_) => Test3<T>(2, tt));
  }
}
