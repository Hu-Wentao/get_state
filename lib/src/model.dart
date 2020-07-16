// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/7/14
// Time  : 22:22

part of 'abs.dart';

///
/// GetState 可以使用多种Model方案
///   1. 基本类型: 直接使用基本类型, int, String作为Model
///   2. 自定义mutable类型: mutable类型可以方便的更新属性
///   3. 自定义immutable类型: immutable类型可以使用[Recorder]来切换之前的状态,推荐结合freezed使用
///
