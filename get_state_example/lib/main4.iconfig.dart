// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_state_example/main3.dart';
import 'package:get_state_example/register_moduls.dart';
import 'package:get_it/get_it.dart';

Future<void> $initGetIt(GetIt g, {String environment}) async {
  final registerModule = _$RegisterModule();
  g.registerLazySingleton<MyCounterViewModel>(() => MyCounterViewModel());
  g.registerLazySingleton<Pg2Vm>(() => Pg2Vm());
  final test = await registerModule.testOne;
  g.registerFactory<Test>(() => test);
  final test2 = await registerModule.testTwo;
  g.registerFactory<Test2>(() => test2);
  final test3 = await registerModule.testThree;
  g.registerFactory<Test3<String>>(() => test3, instanceName: 'str');
  final test31 = await registerModule.testThreeInt;
  g.registerFactory<Test3<int>>(() => test31);
}

class _$RegisterModule extends RegisterModule {}
