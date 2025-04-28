




/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  late Timer _timer;
  int _hour=0;
  int _minute=0;
  int _second=0;
  bool _startEnable=true;
  bool _stopEnable=false;
  bool _continueEnable=false;

  int get hour=>_hour;
  int get minute=>_minute;
  int get second=>_second;
  bool get startEnable=>_startEnable;
  bool get stopEnable=>_stopEnable;
  bool get continueEnable=>_continueEnable;

  void startTimer() {
    _hour=0;
    _minute=0;
    _second=0;
    _startEnable=false;
    _stopEnable=true;
    _continueEnable=false;

    _timer=Timer.periodic(Duration(seconds: 1), (timer) {
      if (_second<59) _second++;
      else if (_second==59) {
        _second=0;
        if (_minute==59) {
          _hour++;
          _minute=0;
        }
        else _minute++;
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    if (_startEnable==false) {
      _startEnable=true;
      _continueEnable=true;
      _stopEnable=false;
      _timer.cancel();
    }
    notifyListeners();
  }

  void continueTimer() {
    _startEnable=false;
    _stopEnable=true;
    _continueEnable=false;

    _timer=Timer.periodic(Duration(seconds: 1), (timer) {
      if (_second<59) _second++;
      else if (_second==59) {
        _second=0;
        if (_minute==59) {
          _hour++;
          _minute=0;
        }
        else _minute++;
      }
    });
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Provider Demo 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>TimerProvider()),
        ],
        child: MyHomePage(title: 'Flutter Clock Provider Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var timer;

  @override
  Widget build(BuildContext context) {
    timer=Provider.of<TimerProvider>(context);
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(height: 25,),
                Center(
                  child: Text('${timer.hour}:'+'${timer.minute}:'+'${timer.second}',
                              style: TextStyle(color: Colors.black,
                                               fontSize: 40,),),
                ),
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    timer.startEnable? ElevatedButton(onPressed: timer.startTimer, child: Text('Start'),)
                                     : ElevatedButton(onPressed: null, child: Text('Start'),),
                    timer.stopEnable? ElevatedButton(onPressed: timer.stopTimer, child: Text('Stop'),)
                                    : ElevatedButton(onPressed: null, child: Text('Stop'),),
                    timer.continueEnable? ElevatedButton(onPressed: timer.continueTimer, child: Text('Continue'),)
                                        : ElevatedButton(onPressed: null, child: Text('Continue'),),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}


 */