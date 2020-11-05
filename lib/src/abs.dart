// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/2
// Time  : 18:09

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_it/get_it.dart';
import 'package:get_state/src/vm/vm_state.dart';

part 'v/view.dart';
part 'v/async_view.dart';
part 'vm/view_model.dart';
part 'vm/base_view_model.dart';
part 'model.dart';

final _g = GetIt.instance;

// Model类推荐 extends Equatable, 或者使用freezed, 这里不便做出约束
