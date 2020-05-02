
import 'register_moduls.dart';

///
/// 本类测试: 直接继承自ViewModel, 并且使用 lazySingleton注解
/// 测试结果证明: 继承自ViewModel的类不仅可以singleton,还可以使用 lazy..
@lazySingleton
class Counter4ViewModel extends ViewModel{
  final Test2 t;
  int _c = 4;

  Counter4ViewModel(this.t);

  int get counter => _c;

  void incrementCounter() {
    print('Counter4ViewModel.incrementCounter +${t.number} block: $isBlocking');
    if (checkAndSetBlocking) return;
    _c += t.number;
    notifyAndSetIdle;
  }
}
///
/// 本类测试: 直接继承自ViewModel
/// 结果证明: 可以使用 singleton注解
@singleton
class Counter3ViewModel extends ViewModel {
  final Test2 t;
  int _c = 3;

  Counter3ViewModel(this.t);

  int get counter => _c;

  void incrementCounter() {
    print('Counter3ViewModel.incrementCounter +${t.number} block: $isBlocking');
    if (checkAndSetBlocking) return;
    _c += t.number;
    notifyAndSetIdle;
  }
}

///
/// 示例Model
///  GetIt提示 ReadyViewModel不能异步标注. 尝试将 singleton改为 lazy..
///  改为使用 lazySingleton后居然没有报原来的错误了
///  还是报错, 又添加了  implements WillSignalReady
///
/// 结果证明: ReadyViewModel必须使用 @singleton, 否则会报错!
@singleton
class Counter2ViewModel extends ReadyViewModel {
  final Test2 t;
  int _counter = 2;

  Counter2ViewModel(this.t);

  @override
  Future<bool> init() async {
    print('这里使用delayed模拟了一些初始化工作');
    return Future.delayed(Duration(seconds: 1)).then((_) => super.init());
  }

  int get counter => _counter;

  void incrementCounter() {
    print('Counter2ViewModel.incrementCounter +${t.number} block: $isBlocking');
    if (checkAndSetBlocking) return;

    /// todo 在这里直接抛出异常并不合适,应当先判断
    /// 因为这个方法可能会通过sl<>()在其他地方调用,
    /// 其他地方不一定有try..catch
    _counter += t.number;
    notifyAndSetIdle;
  }
}

@singleton
class CounterViewModel extends ReadyViewModel {
  final Test t;

  /// 数据
  int counter = 1;

  CounterViewModel(this.t);

  /// 操作数据的方法
  void incrementCounter() {
    print('CounterViewModel.incrementCounter +${t.number} block: $isBlocking');
    if (checkAndSetBlocking) return;
    counter += t.number;
    setVMIdle;
    notifyListeners();
  }

  @override
  Future<bool> init() =>
      Future.delayed(Duration(seconds: 1)).then((_) => super.init());
}
