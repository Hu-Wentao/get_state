// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/2
// Time  : 18:09

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

final _g = GetIt.instance;

typedef ViewBuilder<VM extends ViewModel> = Widget Function(
    BuildContext c, VM m);

///-----------------------------------------------------------------------------
///
///
/// 配合GetIt使用的基础View类
/// 如果某View的 [_isRootView] == true,那么在它被销毁时, 将会释放对应的VM
abstract class View<VM extends ViewModel> extends StatefulWidget {
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
class _ViewState<VM extends ViewModel, V extends View<VM>> extends State<V> {
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

///-----------------------------------------------------------------------------
/// 创建Model的函数, 可以是异步的, 这样就能够异步初始化ViewModel了
typedef Create<T> = Future<T> Function();

/// ViewModel 的状态
/// [unInit]  只有需要 异步init()的VM才需要这个状态
/// [idle]     非异步VM的初始状态, 或者异步init的VM 初始化完成后的状态
/// [busy] VM正在执行某个方法, 并且尚未执行完毕, 此时VM已阻塞,将忽略任何方法调用
enum VmState {
  unInit,
  idle,
  busy,
}

///
/// 抽象ViewModel
/// [M] :Model
/// 建议 M extends Equatable
abstract class ViewModel<M> extends ChangeNotifier {
  VmState vmState;
  M _m;

  M get m => _m;

  @protected
  set m(M m) => _m = m;

  ViewModel(Create<M> create, {this.vmState: VmState.unInit}) {
    create == null ? vmSetIdle : vmCreate(create);
  }

  /// VM是否正在初始化(Model创建方法正在执行)
  bool get vmIsCreating => vmState == VmState.unInit;

  /// VM是否处于锁定状态
  bool get vmIsBusy => vmState != VmState.idle;

  @Deprecated('请使用vmCreate')
  vmInit(M initModel) => vmCreate(() async => initModel);
  @Deprecated('请使用vmCreate')
  vmInitModel(Create<M> create) => vmCreate(create);

  ///
  /// If you create a Model without getting parameters from the View,
  ///   then provide the model in the construction method of the ViewModel.
  /// 如果创建Model 无需从View中获取参数,
  ///     则直接在ViewModel的构造方法中提供Model即可
  /// ```dart
  /// class BarVm extends ViewModel<BarM> {
  ///   final int someVmParamFromGetIt
  ///   BarVm(this.someVmParamFromGetIt) : super(() async => BarM());
  /// }
  /// ```
  ///
  /// If you create a model, you also need to get parameters from the View (e.g., parameters passed from the page jump),
  ///   It is recommended to call vmUpdate() to update the model in the onInitState() method of [View].
  /// 如果创建Model时,还需要从View中获取参数(如页面跳转传来的参数),
  ///     推荐在[View]的 onInitState()方法中,调用 vmUpdate()更新Model
  /// ```dart
  /// class BarV extends View<BarVm> {
  ///   final String someParamFromRoute;
  ///   BarV(this.someParamFromRoute);
  ///
  ///   @override
  ///   void onInitState(BarVm vm) => vm.vmUpdate(BarM(data: someParamFromRoute));
  ///
  ///   @override
  ///   Widget build(BuildContext c, BarVm vm) => ... some ui code ...;
  /// }
  /// ```
  vmCreate(Create<M> create) async =>
      await create().then((model) => vmUpdate(model, ignoreBusy: true));

  /// 刷新状态
  /// 覆写本方法, 以控制刷条件
  /// [newModel] 新的状态
  ///   get_state的[Model]也可以是非immutable的,
  ///   immutable通过对象替换来更新m, 类似Redux, BLoC <推荐>
  ///   非immutable可以直接更新m的字段, 类似Provider
  /// [ignoreBusy] 是否忽略[VmState.Busy]状态对vmUpdate()的拦截
  vmUpdate(M newModel, {bool ignoreBusy: false}) {
    if (!ignoreBusy && vmCheckAndSetBusy) return;

    if (this.m != newModel) {
      this.m = newModel;
      vmSetIdleAndNotify;
    } else {
      vmSetIdle;
    }
  }

  /// 检查状态是否为Busy，
  /// 如果否，则设置为busy并返回false
  @protected
  bool get vmCheckAndSetBusy {
    if (!kReleaseMode) print('[$runtimeType].vmCheckAndSetBusy :[$vmState]');
    if (vmIsBusy) return true;
    vmSetBusy;
    return false;
  }

  /// 通知监听者的同时,将VM设为[VmState.idle]
  void get vmSetIdleAndNotify {
    if (!kReleaseMode) print('[$runtimeType].vmSetIdleAndNotify');
    vmSetIdle;
    notifyListeners();
  }

  /// 设置VM状态为 [VmState.busy]
  void get vmSetBusy {
    if (!kReleaseMode) print('[$runtimeType].vmSetBusy');
    vmState = VmState.busy;
  }

  /// 设置VM状态为 [VmState.idle]
  void get vmSetIdle {
    if (!kReleaseMode) print('[$runtimeType].vmSetIdle');
    vmState = VmState.idle;
  }

  @protected
  void vmDispose() {
    m = null;
  }

  /// 相当于 State<>类中的 dispose();方法
  @protected
  void onDispose(View widget) {}
}

///-----------------------------------------------------------------------------

// Model类推荐 extends Equatable, 或者使用freezed, 这里不便做出约束
