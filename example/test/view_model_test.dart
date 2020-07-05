// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/3
// Time  : 10:03
import 'package:flutter_test/flutter_test.dart';
import 'package:get_state_example/main3.dart';

main() async {
  setUpAll(() async {
    await configDi();
  });

  test('测试 CounterViewModel', () async {
    var start = g<MyCounterViewModel>().counter;
    print('开始: $start');

    g<MyCounterViewModel>().incrementCounter();

    var end = g<MyCounterViewModel>().counter;
    print('结束: $end');

    expect(start, 1);
    expect(end - start, 0);
  });

  test('\n测试 Counter2ViewModel', () async {
    var start = g<MyCounterViewModel>().counter;
    print('开始: $start');

    // 如果要确保点击有效, 则需要isReady<T>();或者 allReady();
    await g.isReady<MyCounterViewModel>();
    g<MyCounterViewModel>().incrementCounter();

    var end = g<MyCounterViewModel>().counter;
    print('结束: $end');

    expect(start, 2);
    expect(end - start, 2);
  });

  test('\n测试 Counter3ViewModel', () async {
    var start = g<MyCounterViewModel>().counter;
    print('开始: $start');

    g<MyCounterViewModel>().incrementCounter();

    var end = g<MyCounterViewModel>().counter;
    print('结束: $end');

    expect(start, 3);
    expect(end - start, 2);
  });

  test('\n测试 Counter4ViewModel', () async {
    var start = g<MyCounterViewModel>().counter;
    print('开始: $start');

    g<MyCounterViewModel>().incrementCounter();

    var end = g<MyCounterViewModel>().counter;
    print('结束: $end');

    expect(start, 4);
    expect(end - start, 2);
  });
}
