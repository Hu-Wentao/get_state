// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/2
// Time  : 18:09

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
            '$runtimeType<VM>是一个View,它必须添加ViewModel泛型!'),
        assert(isRoot != null, 'isRoot不能为空'),
        this._isRootView = isRoot,
        super(key: key);

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
  update() => setState(() => {});

  @override
  void initState() {
    super.initState();
    _g<VM>().addListener(update);
    _g<VM>().onInitState(widget, this);
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
///
/// 检查是否处于阻塞状态,
/// 如果是,则返回true,
/// 如果否,返回false,同时设置VM状态为 [VmState.busy]
///
///
/// ```dart
///   void incrementCounter() {
///     // check里面同时执行了 setVMBlocking;
///     if (vmCheckAndSetBusy ) return;
///
///     ... method body ...
///
///     vmSetIdleAndNotify;
///   }
/// ```
///
/// 适用于无需进行耗时初始化的ViewModel
/// [M] :Model
/// 建议 M extends Equatable
abstract class ViewModel<M> extends ChangeNotifier {
  VmState vmState;
  M _m;

  M get m => _m;

  @protected
  set m(M m) => _m = m;

  ViewModel({M initModel, this.vmState: VmState.idle}) {
    vmInit(initModel);
  }

  /// VM是否处于锁定状态
  bool get vmIsBusy => vmState != VmState.idle;

  /// 初始化ViewModel中的Model
  /// [initModel]的值从构造方法中传入
  /// 可以覆写本方法, 在本方法内为 [m]赋值
  @protected
  vmInit(M initModel) => m = initModel;

  /// 刷新状态
  /// 可以覆写本方法, 达到控制刷新粒度的目的
  @protected
  vmUpdate(M newModel) {
    if (vmCheckAndSetBusy) return;

    if (this.m != newModel) {
      this.m = newModel;
      vmSetIdleAndNotify;
    }
  }

  /// 检查状态是否为Busy，
  /// 如果否，则设置为busy并返回false
  @protected
  bool get vmCheckAndSetBusy {
    if (vmIsBusy) return true;
    vmSetBusy;
    return false;
  }

  /// 通知监听者的同时,将VM设为[VmState.idle]
  get vmSetIdleAndNotify {
    vmSetIdle;
    notifyListeners();
  }

  /// 设置VM状态为 [VmState.busy]
  get vmSetBusy => vmState = VmState.busy;

  /// 设置VM状态为 [VmState.idle]
  get vmSetIdle => vmState = VmState.idle;

  @protected
  void vmDispose() {
    m = null;
  }

  /// 相当于 State<>类中的 initState();方法
  /// [widget] 即 State实例的 get widget,
  /// 不推荐使用该变量, 建议将所有的数据都存放在 ViewModel中操作
  /// 如果一个VM对应多个View, 则可以通过widget分辨不同的View
  @protected
  void onInitState(View widget, State widgetState) {}

  /// 相当于 State<>类中的 dispose();方法
  @protected
  void onDispose(View widget) {}
}
