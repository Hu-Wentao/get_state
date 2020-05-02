// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/11
// Time  : 13:34

part of 'abs.dart';

///
/// 适用于无需进行耗时初始化的ViewModel
/// [M] :Model
/// 建议 M extends Equatable
abstract class ViewModel<M> extends _AbsViewModel {
  M model;

  ViewModel(this.model) : super(VmState.idle);

  /// 刷新状态
  /// 可以覆写本方法, 达到控制刷新粒度的目的
  @protected
  void refresh(M model) {
    if (vmCheckAndSetBusy) return;

    if (this.model != model) {
      this.model = model;
      vmSetIdleAndNotify;
    }
  }
}
//
/////
///// 配合GetIt使用的基础View类
///// 如果某View的 [_isRootView] == true,那么在它被销毁时, 将会释放对应的VM
//abstract class View<VM extends ViewModel> extends _AbsView<VM> {
//  final bool _isRootView;
//
//  View({bool isRoot: false}) : this._isRootView = isRoot;
//
//  Widget builder(BuildContext ctx, VM vm);
//
//  @override
//  State<StatefulWidget> createState() => _ViewState<VM, View<VM>>();
//}
//
//class _ViewState<VM extends ViewModel, V extends View<VM>>
//    extends _AbsViewState<VM, V> {
//  @override
//  Widget build(BuildContext context) {
//    return widget.builder(context, _g<VM>());
//  }
//
//  @override
//  void dispose() {
//    if (widget._isRootView) _g.unregister<VM>();
//    super.dispose();
//  }
//}
