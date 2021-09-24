# increment_button 


[![Pub](https://img.shields.io/pub/v/slidable_button.svg?style=flat-square)](https://pub.dartlang.org/packages/increment_button)


A simple flutter plugin for Slidable Button.

<img src="https://github.com/bradintheusa/increment_button/master/screenshots/screenshot_1.png?raw=true" width="300px"/> &nbsp; 




## Getting Started

### Add dependency

```yaml
dependencies:
  increment_button : 0.0.2
```

### Simple to use

```dart
import 'package:increment_button/increment_button.dart';
```

Code:

```dart
    IncrementButton(
        width: MediaQuery.of(context).size.width,
        buttonWidth: 45.0,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        buttonColor: Theme.of(context).primaryColor,
        label: Center(child: Text('🏀')),
        onDelta: (change) {
        setState(() {
            delta = change;
            i = i + change;
            result = 'New value is $i ';
        });
        },
    ),
```

Video of the component:

https://raw.githubusercontent.com/bradintheusa/increment_button/master/screenshot/untitled.webm

based on : https://github.com/husainazkas/slidable_button
