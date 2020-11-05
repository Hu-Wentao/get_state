// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/14
// Time  : 22:17

part of '../abs.dart';

/// 创建Model的函数, 可以是异步的, 这样就能够异步初始化ViewModel了
typedef Create<T> = Future<T> Function();

///
/// 抽象ViewModel
/// [M] :Model
/// 建议 M extends Equatable
/// 4.0.0 以后, 新增BaseViewModel, 不再绑定某一个Model, 一个BaseViewModel可以管理多个Model,
///   因此泛型[M] 不再有意义
abstract class ViewModel<M> extends ChangeNotifier implements BaseViewModel {
  void get vmNotify => super.notifyListeners();

  VmState vmState;
  M _m;

  ViewModel({Create<M> create, this.vmState: VmState.unInit}) {
    create == null ? vmSetIdle : vmCreate(create);
  }

  M get m => _m;
  @protected
  set m(M m) => _m = m;
  @protected
  bool get hasListeners => super.hasListeners;

  /// VM是否正在初始化(Model创建方法正在执行)
  bool get vmIsCreating => vmState == VmState.unInit;

  /// VM是否处于锁定状态
  bool get vmIsBusy => vmState != VmState.idle;

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

  /// 相当于 State<>类中的 dispose();方法
  @protected
  void onDispose(Widget widget) {}

  @protected
  void vmDispose() {
    m = null;
  }

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
  ///   get_state的[Model]也可以是mutable的,
  ///   immutable通过对象替换来更新m, 类似Redux, BLoC <推荐>
  ///   mutable可以直接更新m的字段, 类似Provider
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

  @Deprecated('请使用vmCreate')
  vmInit(M initModel) => vmCreate(() async => initModel);
  @Deprecated('请使用vmCreate')
  vmInitModel(Create<M> create) => vmCreate(create);
}
