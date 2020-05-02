// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/2
// Time  : 18:09
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

part 'impl.dart';

final _g = GetIt.instance;

typedef ViewBuilder<VM extends _AbsViewModel> = Widget Function(
    BuildContext ctx, VM m);

///-----------------------------------------------------------------------------
///
/// TODO: 后期可能需要使用 HOOK 插件来完成 在SlView中使用 TextField等功能
/// 抽象SlView
abstract class View<VM extends _AbsViewModel> extends StatefulWidget {
  final bool _isRootView;

  View({Key key, bool isRoot: false})
      : this._isRootView = isRoot,
        super(key: key);

  Widget builder(BuildContext ctx, VM vm);

  @override
  State<StatefulWidget> createState() => ViewState<VM, View<VM>>();
}

/// 抽象SlViewSate
/// [VM] View所绑定的ViewModel
/// [V] ViewState所绑定的View
class ViewState<VM extends _AbsViewModel, V extends View<VM>>
    extends State<V> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _g<VM>());
  }

  /// ViewState初始化时
  @mustCallSuper
  void onStateInit() {
    _g<VM>().addListener(update);
  }

  /// ViewState释放时
  @mustCallSuper
  void onStateDispose() {
    _g<VM>().removeListener(update);
    if (widget._isRootView) _g.unregister<VM>();
  }

  /// 刷新内部状态
  update() => setState(() => {});

  @override
  void initState() {
    onStateInit();
    super.initState();
  }

  @override
  void dispose() {
    onStateDispose();
    super.dispose();
  }
}

///-----------------------------------------------------------------------------
/// ViewModel 的状态
/// [unknown]  只有需要 异步init()的VM才需要这个状态
/// [idle]     非异步VM的初始状态, 或者异步init的VM 初始化完成后的状态
/// [busy] VM正在执行某个方法, 并且尚未执行完毕, 此时VM已阻塞,将忽略任何方法调用
enum VmState {
  unknown,
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
abstract class _AbsViewModel extends ChangeNotifier {
  VmState _vmState;

  _AbsViewModel([this._vmState = VmState.unknown]);

  /// VM是否处于锁定状态
  bool get vmIsBusy => _vmState != VmState.idle;

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
  get vmSetBusy => _vmState = VmState.busy;

  /// 设置VM状态为 [VmState.idle]
  get vmSetIdle => _vmState = VmState.idle;
}
