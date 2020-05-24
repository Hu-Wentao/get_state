// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/21
// Time  : 9:26

import 'package:get_state/get_state.dart';

///
/// 状态记录
/// <使用方法见 example/main6.dart>
/// 通过[Recorder],将允许应用在过去的状态之间自由切换
/// 类比浏览器的"后退","前进"功能
mixin Recorder<M> on ViewModel<M> {
  int _cur = -1;
  List<M> _record = <M>[];

  set m(M m) {
    if(m == null) return;
    // 当指向最新的元素时
    if(_cur == _record.length-1) {
      _record.add(m);
      _cur++;
    }else{
      // 当指向中间的元素时
      _record.removeRange(_cur+1, _record.length);
      this.m = m;
    }
  }

  // 当前状态 <建议只使用本方法获取Model>
  M get m {
    if (_cur == -1 || _record.length == 0) return null;
    return _record[_cur];
  }

  // 上一个状态
  M get mPrevious {
    if (_cur == -1) return null;
    if (_cur != 0) _cur--;
    vmSetIdleAndNotify;
    return m;
  }

  // 下一个状态
  M get mNext {
    if (_cur == _record.length) return null;
    if (_cur != _record.length - 1) _cur++;
    vmSetIdleAndNotify;
    return m;
  }

  // 是否为最新的值
  bool get isLatest => _cur == _record.length - 1;

  // 是否为最初值
  bool get isOriginal => _cur == 0;
}
