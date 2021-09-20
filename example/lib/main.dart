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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brad\'s Button Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Slide this button to left or right.'),
            SizedBox(height: 16.0),
            IncrementButton(
              width: MediaQuery.of(context).size.width,
              buttonWidth: 60.0,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              buttonColor: Theme.of(context).primaryColor,
              dismissible: false,
              label: Center(child: Text('🏈')),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('-10'),
                    Text('-5'),
                    Text('-1'),
                    Text('+1'),
                    Text('+5'),
                    Text('+10'),
                  ],
                ),
              ),
              onDelta: (change) {
                setState(() {
                  i = i + change;
                  result = 'New value is $i ';
                  print(result);
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
