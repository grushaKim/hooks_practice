import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

void testIt() {
  final values = [1, 2, null, 3];
  final nonNullValues = values.compactMap((e) {
    if (e != null && e > 10) {
      return e;
    } else {
      return null;
    }
  });
}

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomeScreen(),
    );
  }
}

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;
  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(const Duration(seconds: 1), (v) => from - v)
        .takeWhile((e) => e >= 0)
        .listen((event) {
      value = event;
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useMemoized(() => CountDown(from: 20));
    final notifier = useListenable(counter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Container(
          alignment: Alignment.center,
          child: Text(notifier.value.toString(),
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 20,
              )),
        ),
      ),
    );
  }
}
