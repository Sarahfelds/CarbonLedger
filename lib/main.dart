import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:greenchain_3/bitcoin_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:greenchain_3/screens/BookmarkScreen.dart';
import 'screens/LiveIndexScreen.dart';
import 'screens/CalculateScreen.dart';
import 'onboarding_screen.dart';
import 'package:greenchain_3/ethereum_service.dart';
import 'package:greenchain_3/solana_service.dart';
import 'package:greenchain_3/algorand_service.dart';
import 'package:greenchain_3/polkadot_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBYCJk5fa4H2Wsnq2b-segyR4LQXbgegrI',
      appId: '1:1020067372650:android:9a6c68e41ca6d39da9f413',
      messagingSenderId: '1020067372650',
      projectId: 'green-chain-8890f',
      databaseURL: 'https://green-chain-8890f-default-rtdb.firebaseio.com/',
    ),
  );

  // Start background updater
  Timer.periodic(Duration(minutes: 30), (timer) async {
    try {
      final btcData = await getSmartBitcoinData();
      final ethData = await EthereumService().getBlockchainData(); // Changed
      final solData = await SolanaService().getBlockchainData(); // Changed
      final algoData = await AlgorandService().getBlockchainData(); // Changed
      final dotData = await PolkadotService().getBlockchainData(); // Changed

      final databaseRef = FirebaseDatabase.instance.ref();

      await databaseRef.child('liveData/bitcoin').set(btcData);
      await databaseRef.child('liveData/ethereum').set(ethData);
      await databaseRef.child('liveData/solana').set(solData);
      await databaseRef.child('liveData/algorand').set(algoData);
      await databaseRef.child('liveData/polkadot').set(dotData);

      print('✅ Updated Bitcoin and Ethereum data in Firebase');
    } catch (e) {
      print('❌ Error updating blockchain data: $e');
    }
  });
  final databaseRef = FirebaseDatabase.instance.ref();
  await databaseRef.child("test").set("Hello, world!");

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    // Optionally, use SharedPreferences here to check if onboarding was shown before
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _showOnboarding
          ? OnboardingScreen(onFinish: () {
        setState(() => _showOnboarding = false);
      })
          : MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Bottom navigation item tapped: $index');
    });
  }
  final List<Widget> _pages = <Widget>[
    CalculateScreen(),
    LiveIndexScreen(),
    BookmarkScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _pages[_selectedIndex], // Shows the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: ''),

          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        backgroundColor: Color(0xF50E0F10),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
