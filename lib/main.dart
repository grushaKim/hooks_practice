import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const url =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmMGZnowGWA2mhq9SEa3jpvGgWOiKfLM-eug&usqp=CAU";

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() {
      NetworkAssetBundle(Uri.parse(url))
          .load(url)
          .then((data) => data.buffer.asUint8List())
          .then((data) => Image.memory(data));
    });

    final snapshot = useFuture(future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Column(
          children: <Widget>[snapshot.data].compactMap().toList(),
        ),
      ),
    );
  }
}
