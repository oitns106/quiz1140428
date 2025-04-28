import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class mainModel with ChangeNotifier {
  int _counter=0;
  int get counter=>_counter;
  set counter(int v) {
    if (v!=_counter) {
      _counter=v;
      notifyListeners();
    }
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if (_counter<=0) _counter=0;
    else _counter--;
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
          ChangeNotifierProvider(create: (context)=>mainModel()),
        ],
        child: MyHomePage(title: 'Flutter Provider Demo 1'),
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

  @override
  Widget build(BuildContext context) {
    final counterModel=Provider.of<mainModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:',),
            Text('${counterModel.counter}', style: Theme.of(context).textTheme.headlineMedium,),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Increment',
            //onPressed: ()=>counterModel.counter++),
            onPressed: ()=>counterModel.incrementCounter(),
          ),
          SizedBox(height: 10,),
          FloatingActionButton(
            child: Icon(Icons.horizontal_rule),
            tooltip: 'Decrement',
            //onPressed: ()=>counterModel.counter--),
            onPressed: ()=>counterModel.decrementCounter(),
          ),
        ],
      ),
    );
  }
}






import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class IndexController with ChangeNotifier {
  int currentQuestionIndex=1;
  List<int> selectedOptionList=[0,1,2,3,4];
  int optionSelected=0;

  void updateIndexForQuestion() {
    currentQuestionIndex++;
    notifyListeners();
  }

  void selectedOptionIndex(int optionIndex) {
    optionSelected=selectedOptionList[optionIndex];
    notifyListeners();
  }

  void restartIndexForQuestion() {
    currentQuestionIndex=1;
  }
}

List<String> questionsList = [
  '',
  'Consensus',
  'Premise',
  'Dispute',
];

List<String> OptionOne = [
  '',
  '衝突',
  '先進',
  '放棄',
];

List<String> OptionTwo = [
  '',
  '矛盾',
  '智慧',
  '分派',
];

List<String> OptionThree = [
  '',
  '共識',
  '推薦',
  '爭執',
];

List<String> OptionFour = [
  '',
  '感應',
  '前題',
  '釋放',
];

//顯示目前作答進度
class QuestionNumberIndex extends StatelessWidget {
  int questionNumber;

  QuestionNumberIndex({Key? key, required this.questionNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 240, top: 10),
      child: Container(
        width: 80,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(1,5,),
              blurRadius: 1.5,
              spreadRadius: 1,),
          ],
        ),
        child: Center(
          child: Text('$questionNumber / 3', style: GoogleFonts.mulish(fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3),),
        ),
      ),
    );
  }
}

//顯示? icon
class QuestionMarkIcon extends StatelessWidget {
  const QuestionMarkIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 80,
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),),
      child: Image.asset('assets/logo1.png', fit: BoxFit.fill,),
    );
  }
}

//show出題目
class QuestionBox extends StatelessWidget {
  String question;
  QuestionBox({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18, right: 80),
      child: SizedBox(
        width: 270,
        height: 70,
        child: Text(question, textAlign: TextAlign.left,
          style: GoogleFonts.mulish(fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3),),
      ),
    );
  }
}

//show出分隔線
class DividerToDivideQuestionAndAnswer extends StatelessWidget {
  const DividerToDivideQuestionAndAnswer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 10, top: 12),
      child: Divider(thickness: 1.2,),
    );
  }
}

//show出選項
class OptionBox extends StatelessWidget {

  final String optionIndex;
  final int indexForQuestionNumber;
  final List optionParameter;
  int optionSelected;
  final int providerIndexForOption;

  OptionBox({Key? key,
    required this.optionIndex,
    required this.indexForQuestionNumber,
    required this.providerIndexForOption,
    required this.optionParameter,
    required this.optionSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<IndexController>(
        builder: (context, model, child) {

          Color changeColor() {
            if ((model.optionSelected==1 && providerIndexForOption==1) ||
                (model.optionSelected==2 && providerIndexForOption==2) ||
                (model.optionSelected==3 && providerIndexForOption==3) ||
                (model.optionSelected==4 && providerIndexForOption==4))
              return Colors.black;
            else
              return Colors.blue;
          }

          return Padding(
            padding: EdgeInsets.only(top:10, right: 15, left: 15),
            child: ListTile(
              onTap: ()=> model.selectedOptionIndex(providerIndexForOption),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: changeColor(),
              leading: Text(optionIndex, style: GoogleFonts.mulish(fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(212, 212, 212, 1)),),
              title: Text(optionParameter[indexForQuestionNumber], textAlign: TextAlign.left,
                style: GoogleFonts.mulish(fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: Color.fromRGBO(255, 248, 255, 1)),),),
          );
        });
  }
}

// 題示
class ChooseAnAnswerBox extends StatelessWidget {
  const ChooseAnAnswerBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5,),
      child: SizedBox(
        height: 25,
        width: 150,
        child: Text('請選擇一個答案~', textAlign: TextAlign.center,
          style: GoogleFonts.mulish(
            fontSize: 15,
            color: Color.fromRGBO(101, 99, 99, 1),
            fontWeight: FontWeight.w700,),),
      ),
    );
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (context)=> IndexController(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController=AnimationController(duration: Duration(seconds: 1), vsync: this,);
    final curvedAnimation=CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animation=Tween(begin:0.6, end: 0.8).animate(curvedAnimation)..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if (status==AnimationStatus.completed) animationController.reverse();
      else if (status==AnimationStatus.dismissed) animationController.forward();
    });
    animationController.forward();
    Timer(Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: animation.value,
                    alignment: FractionalOffset.center,
                    child: Image.asset('assets/logo1.png'),);
                }),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentTextStyle: GoogleFonts.mulish(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text('結束測驗?'),
                content: Text('確定離開!', textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 16),),
                actions: [
                  TextButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>exit(0))),
                    child: Text('是', style: TextStyle(color: Colors.red)),),
                  TextButton(onPressed: ()=>Navigator.pop(context, false),
                    child: Text('否',),),
                ],
              );
            });
      },
      child: Consumer<IndexController> (
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 150, height: 150,
                    child: Image.asset('assets/logo1.png'),),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),),
                    child: Text('開始測驗', style: GoogleFonts.mulish(fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),),
                    onPressed: () {
                      model.restartIndexForQuestion();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FirstPage()));
                    },),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {

  int indexForQuestionNumber=1;
  int selectedOption=0;
  List<int> correct_answers=[3,4,3];
  List<int> selected_answer=[0,0,0];
  int score=0;
  FlutterTts flutterTts=FlutterTts();

  late AnimationController controller;
  late Animation animation;
  double beginAnim=0.0;
  double endAnim=1.0;
  double currentvol=0.5;
  double _volumeListenerValue=0.5;
  var vols=['1','2','3','4','5','6','7','8','9','10'];
  String dropdownvalue='5';

  Future _speak(String text) async {
    await flutterTts.setVolume(_volumeListenerValue);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void initState() {
    super.initState();
    VolumeController.instance.addListener((volume) {
      _volumeListenerValue=volume;
      VolumeController.instance.setVolume(_volumeListenerValue);
    });

    score=0;
    _speak(questionsList[indexForQuestionNumber]);
    controller=AnimationController(duration: Duration(seconds: 20), vsync: this);
    animation=Tween(begin:0.0, end:1.0).animate(controller)..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if (status==AnimationStatus.completed) {
        var i=Provider.of<IndexController>(context, listen: false).currentQuestionIndex;
        print('i=$i');
        print('indexForQuestionNumber=$indexForQuestionNumber');
        if (i<3) {    //尚未答完3題
          _speak(questionsList[indexForQuestionNumber+1]);
          controller.reset();
          Provider.of<IndexController>(context, listen: false).selectedOptionIndex(0);
          Provider.of<IndexController>(context, listen: false).updateIndexForQuestion();
          print(selected_answer);
        }
        else {   //3題答完
          print(selected_answer);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ResultPage(totalScore: score),));
        }
      }
      else if (status==AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    VolumeController.instance.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentTextStyle: GoogleFonts.mulish(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text('結束測驗?'),
                content: Text('確定離開!', textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 16),),
                actions: [
                  TextButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen())),
                    child: Text('是', style: TextStyle(color: Colors.red)),),
                  TextButton(onPressed: ()=>Navigator.pop(context, false),
                    child: Text('否',),),
                ],
              );
            });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: Colors.white,
          title: Text('測驗中', style: GoogleFonts.mulish(color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 25,
              letterSpacing: -0.3),),
          centerTitle: true,
          elevation: 0,
          leading: DropdownButton(
            value: dropdownvalue,
            icon: Icon(Icons.volume_down),
            items: vols.map((i)=>DropdownMenuItem(value:i, child:Text(i),)).toList(),
            onChanged: (newValue) {
              setState(() {
                dropdownvalue=newValue!;
                _volumeListenerValue=double.parse(newValue)/10;
              });
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer<IndexController>(builder: (context, model, child) {
              indexForQuestionNumber=model.currentQuestionIndex;
              selectedOption=model.optionSelected;
              return QuestionNumberIndex(questionNumber: indexForQuestionNumber);
            }),
            Consumer<IndexController>(builder: (context, model, child) {
              indexForQuestionNumber=model.currentQuestionIndex;
              return QuestionBox(question: questionsList[indexForQuestionNumber],);
            }),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: LinearProgressIndicator(
                      value: animation.value,
                      minHeight: 10,
                      backgroundColor: Colors.lightGreenAccent,
                    ),
                  ),
                  Text('${20-(animation.value*20).round()}',),
                ],
              ),
            ),
            DividerToDivideQuestionAndAnswer(),
            QuestionMarkIcon(),
            ChooseAnAnswerBox(),
            Consumer<IndexController>(builder: (context, model, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OptionBox(optionIndex: 'A. ',
                      indexForQuestionNumber: model.currentQuestionIndex,
                      providerIndexForOption: 1,
                      optionParameter: OptionOne,
                      optionSelected: model.optionSelected),
                  OptionBox(optionIndex: 'B. ',
                      indexForQuestionNumber: model.currentQuestionIndex,
                      providerIndexForOption: 2,
                      optionParameter: OptionTwo,
                      optionSelected: model.optionSelected),
                  OptionBox(optionIndex: 'C. ',
                      indexForQuestionNumber: model.currentQuestionIndex,
                      providerIndexForOption: 3,
                      optionParameter: OptionThree,
                      optionSelected: model.optionSelected),
                  OptionBox(optionIndex: 'D. ',
                      indexForQuestionNumber: model.currentQuestionIndex,
                      providerIndexForOption: 4,
                      optionParameter: OptionFour,
                      optionSelected: model.optionSelected),
                ],
              );
            }),
            Consumer<IndexController>(builder: (context, model, child) {
              indexForQuestionNumber=model.currentQuestionIndex;
              selectedOption=model.optionSelected;
              return selectedOption>0?
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1,5),
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 1.5,
                                  spreadRadius: 1
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              selected_answer[indexForQuestionNumber-1]=selectedOption;
                              if (correct_answers[indexForQuestionNumber-1]==selected_answer[indexForQuestionNumber-1]) score++;
                              if (indexForQuestionNumber<3) {
                                controller.reset();
                                controller.forward();
                                _speak(questionsList[indexForQuestionNumber+1]);
                                model.updateIndexForQuestion();

                                print(selected_answer);
                              }
                              else {
                                print(selected_answer);

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultPage(totalScore: score,),));
                              }
                              model.selectedOptionIndex(0);
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                            tileColor: Colors.white,
                            leading: Text('下一題',  style: GoogleFonts.mulish(color: Color.fromRGBO(66, 130, 241, 1),
                              fontWeight: FontWeight.w700,),),
                            title: Padding(
                              padding: EdgeInsets.only(right:20, bottom:5),
                              child: Icon(Icons.arrow_forward, color: Color.fromRGBO(66, 130, 241, 1)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  :SizedBox(height: 65);
            }),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  int totalScore=0;
  ResultPage({Key? key, required this.totalScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentTextStyle: GoogleFonts.mulish(),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text('結束測驗?'),
                content: Text('確定離開!', textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 16),),
                actions: [
                  TextButton(onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>exit(0))),
                    child: Text('是', style: TextStyle(color: Colors.red)),),
                  TextButton(onPressed: ()=>Navigator.pop(context, false),
                    child: Text('否',),),
                ],
              );
            });
      },
      child: Consumer<IndexController>(
        builder: (context,model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: totalScore > 4 ?
              IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          insetPadding: EdgeInsets.zero,
                          contentTextStyle: GoogleFonts.mulish(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title: Text('返回?',),
                          content: Text('想重新測驗', textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.grey,
                                  fontSize: 16)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, '取消'),
                              child: Text('否', style: TextStyle(
                                  color: Color.fromRGBO(66, 130, 241, 1))),),
                            TextButton(onPressed: () =>
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen())),
                              child: Text('是', style: TextStyle(
                                  color: Color.fromRGBO(66, 130, 241, 1))),),
                          ],
                        ),);
                },
              ) :
              SizedBox(),
              centerTitle: true,
              title: Text('測驗結果', style: GoogleFonts.mulish(color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.3),),
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width:150,
                      height:150,
                      child: CircularPercentIndicator(
                        backgroundColor: Color.fromRGBO(230, 230, 230, 1),
                        animation: true,
                        radius: 70,
                        lineWidth: 13,
                        percent: totalScore/3,
                        animationDuration: 1000,
                        reverse: true,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text('$totalScore/3', style: GoogleFonts.mulish(color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                            letterSpacing: -0.3),),
                        progressColor: totalScore>4? Color.fromRGBO(82, 186, 0, 1):
                        Color.fromRGBO(254, 123, 30, 1),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        totalScore<2?
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(254, 123, 30, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('嗚嗚...!', style: GoogleFonts.mulish(color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                                letterSpacing: -0.3),),
                          ),
                        )
                            :Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(82, 186, 0, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('讚喔!', style: GoogleFonts.mulish(color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                                letterSpacing: -0.3),),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        totalScore<3?
                        Padding(
                          padding: EdgeInsets.only(top:23),
                          child: Container(
                            width: 160,
                            height: 37,
                            color: Colors.white,
                            child: InkWell(
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())),
                              child: Text('再試一次', textAlign: TextAlign.center,
                                style: GoogleFonts.mulish(color: Color.fromRGBO(66, 130, 241, 1),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    letterSpacing: -0.3,
                                    decoration: TextDecoration.underline),),
                            ),
                          ),
                        )
                            :Padding(
                          padding: EdgeInsets.only(top: 23),
                          child: Container(
                            width: 160,
                            height: 160,
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                children: [
                                  Text('恭喜您\n 通過測驗~', style: GoogleFonts.mulish(color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      letterSpacing: -0.3),),
                                  SizedBox(height: 30,),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: ElevatedButton(
                                        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())),
                                        child: Text('再來一次?', style: GoogleFonts.mulish(color: Colors.orange[800],
                                          fontSize: 16,),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
