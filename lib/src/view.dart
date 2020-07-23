// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/14
// Time  : 22:16

part of 'abs.dart';

///-----------------------------------------------------------------------------
///
///
/// 配合GetIt使用的基础View类
/// 如果某View的 [_isRootView] == true,那么在它被销毁时, 将会释放对应的VM
abstract class View<VM extends BaseViewModel> extends StatefulWidget {
  final bool _isRootView;

  View({Key key, bool isRoot: false})
      : assert(VM.toString() != 'ViewModel<dynamic>',
            '$runtimeType<$VM>是一个View,它必须添加ViewModel泛型!'),
        assert(isRoot != null, 'isRoot不能为空'),
        this._isRootView = isRoot,
        super(key: key);

  /// 如果你希望在该View创建的同时,注册VM, 请覆写本方法
  @protected
  VM get registerVM => null;

  /// 如果你希望在View创建的时候, 做一些初始化工作, 例如初始化Model, 请覆写本方法
  /// ```dart
  /// void onInitState(FooVm vm){
  ///   vm.vmInitModel(BarModel());
  /// }
  /// ```
  void onInitState(VM vm) {}

  Widget build(BuildContext c, VM vm);

  @override
  State<StatefulWidget> createState() => _ViewState<VM, View<VM>>();
}

/// ViewSate
/// [VM] View所绑定的ViewModel
/// [V] ViewState所绑定的View
class _ViewState<VM extends BaseViewModel, V extends View<VM>>
    extends State<V> {
  @override
  Widget build(BuildContext context) => widget.build(context, _g<VM>());

  /// 刷新内部状态
  update() => mounted ? setState(() => {}) : null;

  @override
  void initState() {
    super.initState();
    // 注册ViewModel
    if (widget.registerVM != null && !_g.isRegistered<VM>())
      _g.registerSingleton<VM>(widget.registerVM);
    // 添加监听
    // todo 或许可以在这里根据状态值选择性拦截刷新命令
    _g<VM>().addListener(update);
    // 来自View的onInit()
    widget.onInitState(_g<VM>());
  }

  @override
  void dispose() {
    _g<VM>().onDispose(widget);
    _g<VM>().removeListener(update);
    if (widget._isRootView) _g.unregister<VM>();
    super.dispose();
  }
}
