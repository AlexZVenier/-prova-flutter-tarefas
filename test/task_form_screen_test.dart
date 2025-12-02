import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prova_mobile/task_form_screen.dart';
import 'package:prova_mobile/tarefa.dart';

void main() {
  testWidgets('shows validation messages when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TaskFormScreen()));

    // Check that the save button exists and press it without filling fields
    final saveButton = find.byType(ElevatedButton);
    expect(saveButton, findsOneWidget);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // The validators in the form should show error messages
    expect(find.text('O título é obrigatório.'), findsOneWidget);
    expect(find.text('A descrição é obrigatória.'), findsOneWidget);
    expect(find.text('O Departamento é um campo obrigatório (Requisito Individual).'), findsOneWidget);
  });

  testWidgets('initial values are populated when editing a task', (WidgetTester tester) async {
    final tarefa = Tarefa(
      id: 42,
      titulo: 'Tarefa Teste',
      descricao: 'Descrição exemplo',
      prioridade: 2,
      departamento: 'RH',
      criadoEm: DateTime.now().toIso8601String(),
    );

    await tester.pumpWidget(MaterialApp(home: TaskFormScreen(tarefa: tarefa)));

    // The text fields should contain the values passed
    expect(find.text('Tarefa Teste'), findsOneWidget);
    expect(find.text('Descrição exemplo'), findsOneWidget);
    expect(find.text('RH'), findsOneWidget);

    // Priority should be set to the provided value (2 - should show '2 - Média' in dropdown somewhere)
    expect(find.textContaining('Média'), findsWidgets);
  });
}
