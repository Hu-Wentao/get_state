import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'di_config.dart';

GetIt sl = GetIt.instance;

Future<void> main() async {
//  sl.registerSingleton<CounterViewModel>(CounterViewModel(),
//      signalsReady: true);
//  sl.registerSingleton<TestModel>(TestModel(), signalsReady: true);
//  sl.registerSingleton<Counter2ViewModel>(Counter2ViewModel());
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(),
        body: Column(children: <Widget>[
//          ReadySlView<Counter2ViewModel>(
//            builder: (ctx, m) => Center(
//                child: Text(
//              'Counter value: ${m.counter}',
//              style: Theme.of(context).textTheme.display1,
//            )),
//            loading: (BuildContext ctx) => Center(
//              child: CircularProgressIndicator(),
//            ),
//            error: (BuildContext ctx, error) => Container(child: Text('erorr')),
//          ),
//          MyCounterView(),
//          MyCounter2View(),
          MyCounter3View(),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
//              sl<CounterViewModel>().incrementCounter();
              sl<Counter2ViewModel>().incrementCounter();
//              sl<Counter3ViewModel>().incrementCounter();
            }),
      ),
    );
  }
}

class MyCounterView extends ReadyView<CounterViewModel> {
  @override
  Widget Function(BuildContext ctx, CounterViewModel m) get builder =>
          (ctx, m) {
        return ListTile(
          title: Text('${m.counter} -'),
          trailing: RaisedButton(
            child: Icon(Icons.add),
            onPressed: () {
              sl<CounterViewModel>().incrementCounter();
            },
          ),
        );
      };

  @override
  Widget Function(BuildContext ctx) get loading =>
          (c) =>
          Center(
            child: CircularProgressIndicator(),
          );
}

class MyCounter2View extends ReadyView<Counter2ViewModel> {
  @override
  Widget Function(BuildContext ctx, Counter2ViewModel m) get builder =>
          (ctx, m) {
            return ListTile(
              title: Text('${m.counter} -'),
              trailing: RaisedButton(
                child: Icon(Icons.add),
                onPressed: () {
                  sl<Counter2ViewModel>().incrementCounter();
                },
              ),
            );
//        return Center(child: Text('${m.counter} ---'));
      };

  @override
  Widget Function(BuildContext ctx) get loading =>
          (c) =>
          Center(
            child: CircularProgressIndicator(),
          );
}

class MyCounter3View extends View<Counter3ViewModel> {
  MyCounter3View()
      : super(builder: (c, vm) {
    return ListTile(
      title: Text('${vm.counter} -'),
      trailing: RaisedButton(
        child: Icon(Icons.add),
        onPressed: () {
          sl<Counter3ViewModel>().incrementCounter();
        },
      ),
    );
//    return Center(child: Text('${vm.counter} ---'));
  });

//  @override
//  Widget Function(BuildContext ctx, Counter2ViewModel m) get builder =>
//      (ctx, m) {
//        return Center(child: Text('${m.counter} ---'));
//      };

  @override
  Widget Function(BuildContext ctx, Object error) get error => null;
}
