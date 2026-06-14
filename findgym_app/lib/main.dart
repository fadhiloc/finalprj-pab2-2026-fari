import 'package:flutter/material.dart';
import 'package:aplikasi_gym_palembang/screens/signin_Screens.dart';
import 'package:aplikasi_gym_palembang/screens/SignUp_Screens.dart';
import 'package:aplikasi_gym_palembang/screens/home_screens.dart';
import 'package:aplikasi_gym_palembang/screens/favorite_screens.dart';
import 'package:aplikasi_gym_palembang/screens/profile_screens.dart';
import 'package:aplikasi_gym_palembang/screens/search_screens.dart';
import 'package:aplikasi_gym_palembang/screens/submission_gym_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:aplikasi_gym_palembang/screens/admin_approval_screens.dart';
import 'screens/admin_category_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Gym Palembang',

      initialRoute: '/',

      routes: {
        '/': (context) => const MainScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/submitgym': (context) => const SubmissionGymScreen(), 
        '/adminapproval': (context) => const AdminApprovalScreen(),
        '/admincategory': (context) => const AdminCategoryScreen(),
      },

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}