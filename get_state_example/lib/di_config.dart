// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/5
// Time  : 20:41

import 'package:injectable/injectable.dart';

import 'di_config.iconfig.dart';
import 'main.dart';

@injectableInit
Future<void> setUpDi({String env}) async {
  await $initGetIt(sl, environment: env);
}
