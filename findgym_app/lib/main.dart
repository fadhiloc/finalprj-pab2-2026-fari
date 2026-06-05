import 'package:flutter/material.dart';
import 'package:aplikasi_gym_palembang/screens/signin_Screens.dart';
import 'package:aplikasi_gym_palembang/screens/SignUp_Screens.dart';
import 'package:aplikasi_gym_palembang/screens/detail_screens.dart';
import 'package:aplikasi_gym_palembang/screens/favorite_screens.dart';
import 'package:aplikasi_gym_palembang/screens/home_screens.dart';
import 'package:aplikasi_gym_palembang/screens/profile_screens.dart';
import 'package:aplikasi_gym_palembang/screens/search_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Gym',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.blueGrey),
          titleTextStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey).copyWith(
          primary: Colors.blueGrey,
          surface: Colors.blueGrey[50],
        ),
        useMaterial3: true,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blueGrey[50],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.blueGrey[100],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.grey),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.grey),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.grey),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.grey),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
