// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/23
// Time  : 22:42

/// ViewModel 的状态
/// [unInit]  只有需要 异步init()的VM才需要这个状态
/// [idle]    非异步VM的初始状态, 或者异步init的VM 初始化完成后的状态
/// [busy]    VM正在执行某个方法, 并且尚未执行完毕, 此时VM已阻塞,将忽略任何方法调用
enum VmState {
  unInit,
  idle,
  busy,
}