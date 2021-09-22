import 'package:flutter/material.dart';
import 'package:increment_button/increment_button.dart';

void main() {
  runApp(MaterialApp(home: IncrementButtonDemo()));
}

class IncrementButtonDemo extends StatefulWidget {
  const IncrementButtonDemo({Key? key}) : super(key: key);

  @override
  _IncrementButtonDemoState createState() => _IncrementButtonDemoState();
}

class _IncrementButtonDemoState extends State<IncrementButtonDemo> {
  String result = "Let's slide!";
  int i = 0;
  int _delta = 0;

  _transitionBuilder(Widget child, Animation<double> animation, String key) {
    final inAnimation =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);
    final outAnimation =
        Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation);

    if (child.key == ValueKey(key)) {
      return ClipRect(
        child: SlideTransition(
          position: inAnimation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      );
    } else {
      return ClipRect(
        child: SlideTransition(
          position: outAnimation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Increment Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return _transitionBuilder(child, animation, i.toString());
              },
              child: Text(
                i.toString(),
                key: ValueKey<int>(i),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Text('Slide this button to left or right.'),
            SizedBox(height: 16.0),
            IncrementButton(
              width: MediaQuery.of(context).size.width,
              buttonWidth: 45.0,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              buttonColor: Theme.of(context).primaryColor,
              label: Center(child: Text('🏈')),
              onDelta: (change) {
                setState(() {
                  _delta = change;
                  i = i + change;
                  result = 'New value is $i ';
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Result:\n$result', textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
