// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/23
// Time  : 22:39
part of '../abs.dart';

///
/// 适用于一个或多个 [LiveData] / [LiveModel] 使用
/// 数据刷新逻辑都转移到 [LiveData] / [LiveModel] 中
abstract class BaseViewModel {
  /// 相当于 State<>类中的 dispose();方法
  @protected
  @mustCallSuper
  void onDispose(Widget widget) => null;
}
