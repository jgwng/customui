import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gwui/alert_toast.dart';
import 'package:gwui/animated_tab_bar.dart';
import 'package:gwui/app_theme_util.dart';
import 'package:gwui/custom_app_bar.dart';
import 'package:gwui/custom_button.dart';
import 'package:gwui/custom_switch.dart';
import 'package:gwui/resources/size.dart';
import 'package:gwui/resources/styles.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  AppThemeUtil.instance.init(
    fontColor: Colors.white,
    backgroundColor: Colors.black,
    pointColor: Colors.green,
    iconColor: Colors.black,
    navigatorKey: navigatorKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      )
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      AlertToast.show(msg: '테스트 중입니다');
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AnimatedTabBar(
              tabs: const ["수입", "지출"],
              initIndex: 0,
              onTabSelected: (index) {

              },
            ),
            CustomSwitch(
              value: true,
              onChanged: (value){},
            ),
            Text(
              '안녕하세요',
              style: AppStyles.w500.copyWith(
                fontSize: 16.fs
              )),
            CustomButton(
                  onTap: (){},
                  buttonText: '수입 추가',
                  buttonColor: Colors.black,
                  buttonTextColor: Colors.white,
                  horizontalPadding: 0,
                  height: 40.s,
                )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
