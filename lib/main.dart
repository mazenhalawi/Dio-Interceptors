import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio_proj/interceptor_retry_request.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio _dio;
  String txtToDisplay = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    BaseOptions baseOptions = BaseOptions(
      baseUrl: 'http://numbersapi.com/',
      headers: {'Content-Type': 'application/json'},
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.add(RetryRequestInterceptor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dio'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            txtToDisplay,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                  child: Text('Get Data'),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final response = await _dio.get('random');
                    setState(() {
                      isLoading = false;
                      txtToDisplay = response.data['text'];
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
