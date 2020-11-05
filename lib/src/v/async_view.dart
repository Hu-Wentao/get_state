// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/8/5
// Time  : 0:19

part of '../abs.dart';

/// 配合需要进行异步初始化的ViewModel使用

typedef AsyncViewBuilder<VM> = Widget Function(
    BuildContext context, AsyncSnapshot<Failure> initFailureSnap, VM vm);

class VmUnInitFailure<VM extends BaseViewModel> implements Failure {
  @override
  String get msg => '[$VM] UnInit';
  @override
  void onCreate() {}
  @override
  List<Object> get props => [msg];
  @override
  final String reportFailureType = 'VmUnInitFailure';
  @override
  bool get stringify => true;
  const VmUnInitFailure._();

  VmUnInitFailure();
}

const vmUnInit = VmUnInitFailure._();

///
/// todo 没有解决: 当初始化失败时, 如何重新初始化?
abstract class AsyncView<VM extends ViewModel> extends StatefulWidget {
  final Failure initialData;

  final bool isRoot;
  @protected
  VM registerVmInstance() => null;

  /// 初始化ViewModel的函数,
  /// 返回Failure实例表示初始化发生错误, 返回null表示初始化成功
  Future<Failure> initFunc(VM vm);

  /// 正在初始化时的展示的Widget
  Widget onInitBuilder(BuildContext ctx, VM vm) =>
      Center(child: CircularProgressIndicator());

  /// 当初始化出错时展示的Widget
  Widget onFailureBuilder(BuildContext ctx, VM vm, Failure f);

  /// 当初始化成功时展示的Widget
  Widget builder(BuildContext ctx, VM vm);

  const AsyncView({
    Key key,
    this.isRoot: false,
    this.initialData: vmUnInit,
  }) : super(key: key);
  @override
  _AsyncViewState<VM, AsyncView<VM>> createState() =>
      _AsyncViewState<VM, AsyncView<VM>>();
}

class _AsyncViewState<VM extends ViewModel, V extends AsyncView<VM>>
    extends State<V> {
  /// VM
  VM _vm;

  ///
  Failure failure;

  /// 刷新内部状态
  update([Function() fn]) => mounted ? setState(fn ?? () => {}) : null;

  @override
  void initState() {
    super.initState();
    failure = widget.initialData;
    // 注册ViewModel
    if (!_g.isRegistered<VM>()) widget.registerVmInstance();
    _vm = _g<VM>();
    // 添加监听
    // todo 或许可以在这里根据状态值选择性拦截刷新命令
    _vm.addListener(update);

    widget.initFunc(_vm).then((v) => setState(() => failure = v));
  }

  @override
  Widget build(BuildContext context) => failure == widget.initialData
      ? widget.onInitBuilder(context, _vm)
      : failure == null
          ? widget.builder(context, _vm)
          : widget.onFailureBuilder(context, _vm, failure);

  @override
  void dispose() {
    _g<VM>().removeListener(update);
    if (widget.isRoot) {
      _g<VM>().onDispose(widget);
      _g.unregister<VM>();
    }
    super.dispose();
  }
}

/// [isRoot]
/// [initialData] 初始值, 默认为 [VmUnInitFailure]实例,表示当前尚未初始化
///   如果为null,表示已经初始化完成
/// [registerVm] 当ViewModel在View被构造时尚未注册, 则调用该函数注册ViewModel
//abstract class AsyncView<VM extends BaseViewModel> extends StatefulWidget {
//  final Failure initialData;
//
//  final bool isRoot;
//  final VM Function() registerVm;
//
//  /// 初始化ViewModel的函数,
//  /// 返回Failure实例表示初始化发生错误, 返回null表示初始化成功
//  Future<Failure> initFunc(VM vm);
//
//  /// 正在初始化时的展示的Widget
//  Widget onInitBuilder(BuildContext ctx, VM vm) =>
//      Center(child: CircularProgressIndicator());
//
//  /// 当初始化出错时展示的Widget
//  Widget onFailureBuilder(BuildContext ctx, VM vm, Failure f);
//
//  /// 当初始化成功时展示的Widget
//  Widget builder(BuildContext ctx, VM vm);
//
//  const AsyncView({
//    Key key,
//    this.isRoot: false,
//    this.registerVm,
//    this.initialData: vmUnInit,
//  }) : super(key: key);
//
//  State<AsyncView<VM>> createState() => _AsyncViewBuilderState<VM>();
//
//  @override
//  StatefulElement createElement() => StatefulElement(this);
//
//  @override
//  List<DiagnosticsNode> debugDescribeChildren() => const <DiagnosticsNode>[];
//
//  @override
//  DiagnosticsNode toDiagnosticsNode(
//          {String name, DiagnosticsTreeStyle style}) =>
//      DiagnosticableTreeNode(name: name, value: this, style: style);
//
//  @override
//  String toStringDeep(
//          {String prefixLineOne = '',
//          String prefixOtherLines,
//          DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
//      toDiagnosticsNode().toStringDeep(
//          prefixLineOne: prefixLineOne,
//          prefixOtherLines: prefixOtherLines,
//          minLevel: minLevel);
//
//  @override
//  String toStringShallow(
//      {String joiner = ', ',
//      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
//    if (kReleaseMode) {
//      return toString();
//    }
//    String shallowString;
//    assert(() {
//      final StringBuffer result = StringBuffer();
//      result.write(toString());
//      result.write(joiner);
//      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
//      debugFillProperties(builder);
//      result.write(
//        builder.properties
//            .where((DiagnosticsNode n) => !n.isFiltered(minLevel))
//            .join(joiner),
//      );
//      shallowString = result.toString();
//      return true;
//    }());
//    return shallowString;
//  }
//
//  @override
//  String toStringShort() {
//    final String type = objectRuntimeType(this, 'Widget');
//    return key == null ? type : '$type-$key';
//  }
//}
//
///// State for [FutureBuilder].
//class _AsyncViewBuilderState<VM extends BaseViewModel>
//    extends State<AsyncView<VM>> {
//  Object _activeCallbackIdentity;
//  AsyncSnapshot<Failure> _snapshot;
//  VM _vm;
//  @override
//  void initState() {
//    super.initState();
//    // 注册ViewModel
//    if (!_g.isRegistered<VM>()) {
//      final vm = widget.registerVm();
//      if (vm != null) _g.registerSingleton<VM>(vm);
//    }
//    // 添加监听
//    // todo 或许可以在这里根据状态值选择性拦截刷新命令
////    _g<VM>().addListener(update);
//    _snapshot = AsyncSnapshot<Failure>.withData(
//        ConnectionState.none, widget.initialData);
//    _vm = GetIt.I<VM>();
//    _subscribe();
//  }
//
//  @override
//  void didUpdateWidget(AsyncView<VM> oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.initFunc != widget.initFunc) {
//      if (_activeCallbackIdentity != null) {
//        _unsubscribe();
//        _snapshot = _snapshot.inState(ConnectionState.none);
//      }
//      _subscribe();
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (_snapshot.data is VmUnInitFailure) {
//      return widget.onInitBuilder(context, _vm);
//    } else if (_snapshot.data is Failure) {
//      return widget.onFailureBuilder(context, _vm, _snapshot.data);
//    } else {
//      return widget.builder(context, _vm);
//    }
//  }
//
//  @override
//  void dispose() {
//    _unsubscribe();
//    if (widget.isRoot) {
//      _g<VM>().onDispose(widget);
//      _g.unregister<VM>();
//    }
//    super.dispose();
//  }
//
//  void _subscribe() {
//    if (widget.initFunc != null) {
//      final Object callbackIdentity = Object();
//      _activeCallbackIdentity = callbackIdentity;
//      widget.initFunc(_vm).then<void>((Failure data) {
//        if (_activeCallbackIdentity == callbackIdentity) {
//          setState(() {
//            _snapshot =
//                AsyncSnapshot<Failure>.withData(ConnectionState.done, data);
//          });
//        }
//      }, onError: (Object error) {
//        if (_activeCallbackIdentity == callbackIdentity) {
//          setState(() {
//            _snapshot =
//                AsyncSnapshot<Failure>.withError(ConnectionState.done, error);
//          });
//        }
//      });
//      _snapshot = _snapshot.inState(ConnectionState.waiting);
//    }
//  }
//
//  void _unsubscribe() {
//    _activeCallbackIdentity = null;
//  }
//}

///
/// [initFunc] 一个Future, Failure代表初始化过程中发生的错误(如果是null,则代表初始化成功)
//abstract class AsyncView<VM extends BaseViewModel> extends StatefulWidget {
//  final bool _isRootView;
//
//  final Future<Failure> initFunc;
//
//  final AsyncViewBuilder<Failure> builder;
//
//  AsyncView({
//    Key key,
//    bool isRoot: false,
//    this.initFunc,
//    this.builder,
//  })  : assert(VM.toString() != 'ViewModel<dynamic>',
//            '$runtimeType<$VM>是一个View,它必须添加ViewModel泛型!'),
//        assert(isRoot != null, 'isRoot不能为空'),
//        this._isRootView = isRoot,
//        super(key: key);
//
//  /// 如果你希望在该View创建的同时,注册VM, 请覆写本方法
//  @protected
//  VM registerVmInstance() => null;
//
//
//  @override
//  State<StatefulWidget> createState() => _AsyncViewState<VM, AsyncView<VM>>();
//}

/// ViewSate
/// [VM] View所绑定的ViewModel
/// [V] ViewState所绑定的View
//class _AsyncViewState<VM extends BaseViewModel, V extends AsyncView<VM>>
//    extends State<V> {
//  @override
//  Widget build(BuildContext context) => widget.builder(context, );
//
//  /// 刷新内部状态
//  update() => mounted ? setState(() => {}) : null;
//
//  @override
//  void initState() {
//    super.initState();
//    // 注册ViewModel
//    if (widget.registerVmInstance() != null && !_g.isRegistered<VM>())
//      _g.registerSingleton<VM>(widget.registerVmInstance());
//    // 添加监听
//    // todo 或许可以在这里根据状态值选择性拦截刷新命令
//    _g<VM>().addListener(update);
//  }
//
//  @override
//  void dispose() {
//    _g<VM>().onDispose(widget);
//    _g<VM>().removeListener(update);
//    if (widget._isRootView) _g.unregister<VM>();
//    super.dispose();
//  }
//}
