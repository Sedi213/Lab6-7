import 'package:flutter/material.dart';
import 'package:lab6a7/BiometricService.dart';
import 'package:lab6a7/myManager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return 
       MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab 6'),
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
  BiometricsService biometric =
      BiometricsService(localAuthentication: LocalAuthentication());
  String _text = '';
  bool failedAuth = false;
  double blurr = 20;
  double opacity = 0.6;

  void changeText(String text) {
    setState(() {
      _text = text;
    });
  }
@override
  void initState() {
      MyManager.read().then((value) => setState(() { _text=value?? 'void';})) ;
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      nativeRemoveDelay: 100,
      autoUnlockNative: true,
      child: Builder(builder: (context) {
        return SecureGate(
          blurr: blurr,
          opacity: opacity,
          lockedBuilder: (context, secureNotifier) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                child: const Text('Turn off safety'),
                onPressed: () {
                  secureNotifier?.authSuccess(unlock: true);
                  changeText('Safety is off');
                  MyManager.write('Safety is off');
                },
              ),
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: Text(
                widget.title,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _text,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      child: const Text('Block'),
                      onPressed: () {
                        changeText('Blocked');
                         MyManager.write('Blocked');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      child:  const Text('Unblock'),
                      onPressed: () async {
                        if (await biometric.isFingerPrintEnabled) {
                          await biometric.authenticateWithFingerPrint();
                        } else {
                          debugPrint('no fingerprint biometrics');
                        }
                        changeText('Authenticated');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      child: const Text('Turn on safety'),
                      onPressed: () {
                        SecureApplicationProvider.of(context, listen: false)
                            ?.lock();
                        changeText('Safety is on');
                         MyManager.write('Safety is on');
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      child: const Text('Turn off safety'),
                      onPressed: () {
                        changeText('Safety is off');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}