// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/23
// Time  : 22:39
part of '../abs.dart';

///
/// 推荐配合一个或多个 [LiveData] / [LiveModel] 使用
/// 数据刷新逻辑都转移到 [LiveData] / [LiveModel] 中
/// todo 后期实现与LiveData绑定, 当没有ViewModel没有被任何View使用时,VM应当让LiveData感知到
abstract class BaseViewModel extends ChangeNotifier {

  bool get hasListeners => super.hasListeners;

  /// 相当于 State<>类中的 dispose();方法
  @protected
  void onDispose(View widget) {}

  @protected
  void vmDispose() {}
}
