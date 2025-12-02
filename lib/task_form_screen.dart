import 'package:flutter/material.dart';
// Importe as classes que você criou
import 'tarefa.dart'; 
import 'db_helper.dart'; 

class TaskFormScreen extends StatefulWidget {
  // A tarefa é opcional: se for null, é um novo cadastro; se não, é uma edição.
  final Tarefa? tarefa; 

  const TaskFormScreen({super.key, this.tarefa});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  // Chave Global para acessar o formulário e suas validações
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para os TextFields
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _departmentController; // Controller para o Campo Extra
  
  // Valor inicial para a prioridade
  int _selectedPriority = 1; // Padrão: Baixa

  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os dados da tarefa se for edição
    if (widget.tarefa != null) {
      _titleController = TextEditingController(text: widget.tarefa!.titulo);
      _descriptionController = TextEditingController(text: widget.tarefa!.descricao);
      _departmentController = TextEditingController(text: widget.tarefa!.departamento);
      _selectedPriority = widget.tarefa!.prioridade;
    } else {
      // Caso contrário, inicializa vazio para novo cadastro
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _departmentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  // Função principal para salvar ou atualizar a tarefa
  void _saveTask() async {
    // 1. Validação obrigatória
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Monta o objeto Tarefa com os dados do formulário
      final newOrUpdatedTask = Tarefa(
        id: widget.tarefa?.id, // Mantém o ID se for edição
        titulo: _titleController.text,
        descricao: _descriptionController.text,
        prioridade: _selectedPriority,
        departamento: _departmentController.text,
        criadoEm: widget.tarefa?.criadoEm ?? DateTime.now().toIso8601String(),
      );

      // 2. Lógica CRUD: Insert vs Update
      if (newOrUpdatedTask.id == null) {
        // C - INSERT (Novo Cadastro)
        await dbHelper.insert(newOrUpdatedTask);
      } else {
        // U - UPDATE (Edição)
        await dbHelper.update(newOrUpdatedTask);
      }

      // Retorna true para a tela anterior (TaskListScreen) para forçar o reload
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determina o título da tela
    final title = widget.tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.indigo, // Cor Primária
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // --- Campo Título ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título Profissional'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório.'; // Validação
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // --- Campo Descrição ---
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Detalhes da Tarefa'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória.'; // Validação
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // --- Campo EXTRA: DEPARTAMENTO ---
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Departamento (Campo Personalizado)',
                  icon: Icon(Icons.business_center, color: Colors.blueAccent), // Ícone para destaque
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O Departamento é um campo obrigatório (Requisito Individual).'; // Validação
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Campo Prioridade (Dropdown) ---
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedPriority,
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3 - Alta', style: TextStyle(color: Colors.red))),
                  DropdownMenuItem(value: 2, child: Text('2 - Média', style: TextStyle(color: Colors.amber))),
                  DropdownMenuItem(value: 1, child: Text('1 - Baixa', style: TextStyle(color: Colors.green))),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'A prioridade deve ser selecionada.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // --- Botão Salvar (Cor Secundária) ---
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Cor Secundária
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  widget.tarefa == null ? 'CADASTRAR TAREFA' : 'SALVAR EDIÇÃO',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}