import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// One simple action: Increment
enum Actions { Increment, Decrement, Square, Reset }

// The reducer, which takes the previous count and increments it in response
// to an Increment action.

int counterReducer(int state, dynamic action) {
  if (action == Actions.Increment) {
    return state + 1;
  }
  if (action == Actions.Decrement) {
    return state - 1;
  }
  if (action == Actions.Square) {
    return state * state;
  }
  if (action == Actions.Reset) {
    state = 0;
    return state;
  }

  return state;
}

void main() {
  // Create your store as a final variable in the main function or inside a
  // State object. This works better with Hot Reload than creating it directly
  // in the `build` function.
  final store = Store<int>(counterReducer, initialState: 0);

  runApp(FlutterReduxApp(
    title: 'Flutter Redux Demo',
    store: store,
  ));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<int> store;
  final String title;

  FlutterReduxApp({
    Key? key,
    required this.store,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return StoreProvider<int>(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Connect the Store to a Text Widget that renders the current
                // count.
                //
                // We'll wrap the Text Widget in a `StoreConnector` Widget. The
                // `StoreConnector` will find the `Store` from the nearest
                // `StoreProvider` ancestor, convert it into a String of the
                // latest count, and pass that String  to the `builder` function
                // as the `count`.
                //
                // Every time the button is tapped, an action is dispatched and
                // run through the reducer. After the reducer updates the state,
                // the Widget will be automatically rebuilt with the latest
                // count. No need to manually manage subscriptions or Streams!
                StoreConnector<int, String>(
                  converter: (store) => store.state.toString(),
                  builder: (context, count) {
                    return Text(
                      'The button has been pushed this many times: $count',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                )
              ],
            ),
          ),
          // Connect the Store to a FloatingActionButton. In this case, we'll
          // use the Store to build a callback that will dispatch an Increment
          // Action.
          //
          // Then, we'll pass this callback to the button's `onPressed` handler.
          floatingActionButton: StoreConnector<int, Function(Actions type)>(
            converter: (store) {
              // Return a `VoidCallback`, which is a fancy name for a function
              // with no parameters and no return value.
              // It only dispatches an Increment action.
              return (type) => store.dispatch(type);
            },
            builder: (context, callback) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  // Attach the `callback` to the `onPressed` attribute
                  onPressed: () => callback(Actions.Increment),
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
                // SpeedDialChild(
                //   child: const Icon(Icons.add),
                //   label: 'Increment',
                //   backgroundColor: Colors.amberAccent,
                //   onTap: callback(Actions.Increment),
                // ),
                FloatingActionButton(
                  // Attach the `callback` to the `onPressed` attribute
                  onPressed: () => callback(Actions.Decrement),
                  tooltip: 'Decrement',
                  child: Icon(Icons.west_rounded),
                ),
                // SpeedDialChild(
                //   child: const Icon(Icons.west_rounded),
                //   label: 'Decrement',
                //   backgroundColor: Colors.amberAccent,
                //   onTap: callback(Actions.Decrement),
                // ),
                FloatingActionButton(
                  // Attach the `callback` to the `onPressed` attribute
                  onPressed: () => callback(Actions.Square),
                  tooltip: 'Square',
                  child: Icon(Icons.crop_square),
                ),
                // SpeedDialChild(
                //   child: const Icon(Icons.crop_square),
                //   label: 'Square',
                //   backgroundColor: Colors.amberAccent,
                //   onTap: callback(Actions.Square),
                // ),
                FloatingActionButton(
                  // Attach the `callback` to the `onPressed` attribute
                  onPressed: () => callback(Actions.Reset),
                  tooltip: 'Reset',
                  child: Icon(Icons.restore_outlined),
                ),
                // SpeedDialChild(
                //   child: const Icon(Icons.restore_outlined),
                //   label: 'Reset',
                //   backgroundColor: Colors.amberAccent,
                //   onTap: callback(Actions.Reset),
                // ),
              ],
              // StoreConnector<int, VoidCallback>(
              //   converter: (store) {
              //     // Return a `VoidCallback`, which is a fancy name for a function
              //     // with no parameters and no return value.
              //     // It only dispatches an Increment action.
              //     return () => store.dispatch(Actions.Increment);
              //   },
              //   builder: (context, callback) {
              // return FloatingActionButton(
              //   // Attach the `callback` to the `onPressed` attribute
              //   onPressed: callback,
              //   tooltip: 'Increment',
              //   child: Icon(Icons.add),
              // );
              //   },
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
