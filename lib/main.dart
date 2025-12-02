import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart'; // Tela principal que vamos criar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      // Tema "temaTechBlue" conforme solicitado
      theme: ThemeData(
        brightness: Brightness.dark, // Para um visual "Tech"
        primaryColor: Colors.indigo, // Cor primária
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.blueAccent, // Cor secundária
        ),
        scaffoldBackgroundColor: const Color(0xFF0A192F), // Fundo azul escuro
        cardColor: const Color(0xFF172A45), // Cor dos cards
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF172A45),
          elevation: 0,
        ),
      ),
      home: const TaskListScreen(), // A tela de listagem de tarefas
      debugShowCheckedModeBanner: false,
    );
  }
}
