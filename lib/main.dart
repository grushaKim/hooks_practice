import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useState(''); // Value notifier

    useEffect(() {
      controller.addListener(() {
        text.value = controller.text;
      });
      return null;
    }, [controller]); // controller as a key

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Column(children: [
          TextFormField(
            controller: controller,
          ),
          Text('You typed - ${text.value}'),
        ]),
      ),
    );
  }
}
