// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/15
// Time  : 23:54
import 'package:ca_presentation_example/counter_view_model.dart';
import 'package:ca_presentation_example/di_config.dart';
import 'package:ca_presentation_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

main() async {
  setUpAll(() async {
    await setUpDi();
  });

  test('测试 CounterViewModel', () async {
    var start = sl<CounterViewModel>().counter;
    print('开始: $start');

    sl<CounterViewModel>().incrementCounter();

    var end = sl<CounterViewModel>().counter;
    print('结束: $end');

    expect(start, 1);
    expect(end - start, 0);
  });

  test('\n测试 Counter2ViewModel', () async {
    var start = sl<Counter2ViewModel>().counter;
    print('开始: $start');

    // 如果要确保点击有效, 则需要isReady<T>();或者 allReady();
    await sl.isReady<Counter2ViewModel>();
    sl<Counter2ViewModel>().incrementCounter();

    var end = sl<Counter2ViewModel>().counter;
    print('结束: $end');

    expect(start, 2);
    expect(end - start, 2);
  });

  test('\n测试 Counter3ViewModel', () async {
    var start = sl<Counter3ViewModel>().counter;
    print('开始: $start');

    sl<Counter3ViewModel>().incrementCounter();

    var end = sl<Counter3ViewModel>().counter;
    print('结束: $end');

    expect(start, 3);
    expect(end - start, 2);
  });

  test('\n测试 Counter4ViewModel', () async {
    var start = sl<Counter4ViewModel>().counter;
    print('开始: $start');

    sl<Counter4ViewModel>().incrementCounter();

    var end = sl<Counter4ViewModel>().counter;
    print('结束: $end');

    expect(start, 4);
    expect(end - start, 2);
  });
}
