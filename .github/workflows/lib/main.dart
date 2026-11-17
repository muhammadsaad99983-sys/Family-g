import 'package:flutter/material.dart';

void main() {
  runApp(const FamilyApp());
}

// ================= POST MODEL =================

class Post {
  String name;
  String text;
  String time;

  Post({
    required this.name,
    required this.text,
    required this.time,
  });
}

// ================= APP STORE =================

class Store extends ChangeNotifier {
  bool isLoggedIn = false;
  String myName = '';

  List<Post> posts = [
    Post(
      name: 'Aftab',
      text: 'Welcome to Family Group!',
      time: 'Now',
    ),
  ];

  void login(String name) {
    myName = name;
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    myName = '';
    notifyListeners();
  }

  void addPost(String text) {
    if (text.trim().isEmpty) return;

    posts.insert(
      0,
      Post(
        name: myName,
        text: text.trim(),
        time: DateTime.now().toString().substring(0, 16),
      ),
    );

    notifyListeners();
  }

  void deletePost(int index) {
    posts.removeAt(index);
    notifyListeners();
  }
}

final Store store = Store();

// ================= MAIN APP =================

class FamilyApp extends StatefulWidget {
  const FamilyApp({super.key});

  @override
  State<FamilyApp> createState() => _FamilyAppState();
}

class _FamilyAppState extends State<FamilyApp> {
  @override
  void initState() {
    super.initState();
    store.addListener(_update);
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: store.isLoggedIn
          ? const HomePage()
          : const LoginPage(),
    );
  }
}

// ================= LOGIN PAGE =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void login() {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
        ),
      );
      return;
    }

    store.login(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.family_restroom,
                size: 100,
                color: Colors.teal,
              ),

              const SizedBox(height: 20),

              const Text(
                'Family Group',
                style: TextStyle(
                  fontSize: 30
