import 'package:firebase_auth/firebase_auth.dart';
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
import 'screens/notification_screen.dart';

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
      title: 'FindMyGym',

      theme: ThemeData(
        useMaterial3: true,

        primaryColor: const Color(0xFF7C3AED),

        scaffoldBackgroundColor:
            const Color(0xFFF5F3FF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7C3AED),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7C3AED),
          foregroundColor: Colors.white,
        ),

        cardTheme: CardThemeData(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),

          focusedBorder: const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(
              color: Color(0xFF7C3AED),
              width: 2,
            ),
          ),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return const SignInScreen();
          }
          return const MainScreen();
        },

        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/submitgym': (context) => const SubmissionGymScreen(), 
        '/adminapproval': (context) => AdminApprovalScreen(),
        '/admincategory': (context) => const AdminCategoryScreen(),
        '/notifications': (context) => const NotificationScreen(),
      },
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