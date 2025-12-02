import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../tarefa.dart';

class TaskFormScreen extends StatefulWidget {
  final Tarefa? tarefa;

  const TaskFormScreen({Key? key, this.tarefa}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  late String _titulo;
  late String _descricao;
  late int _prioridade;
  late String _departamento;

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _prioridadeController = TextEditingController();
  final _departamentoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      final tarefa = widget.tarefa!;
      _tituloController.text = tarefa.titulo;
      _descricaoController.text = tarefa.descricao;
      _prioridadeController.text = tarefa.prioridade.toString();
      _departamentoController.text = tarefa.departamento;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _prioridadeController.dispose();
    _departamentoController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final now = DateTime.now().toIso8601String();

      if (widget.tarefa == null) {
        // Inserir nova tarefa
        final novaTarefa = Tarefa(
          titulo: _titulo,
          descricao: _descricao,
          prioridade: _prioridade,
          departamento: _departamento,
          criadoEm: now,
        );
        await dbHelper.insert(novaTarefa);
      } else {
        // Atualizar tarefa existente
        final tarefaAtualizada = Tarefa(
          id: widget.tarefa!.id,
          titulo: _titulo,
          descricao: _descricao,
          prioridade: _prioridade,
          departamento: _departamento,
          criadoEm: widget.tarefa!.criadoEm, // Mantém a data de criação original
        );
        await dbHelper.update(tarefaAtualizada);
      }
      
      Navigator.pop(context, true); // Retorna true para recarregar a lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( // Usando ListView para evitar overflow em telas pequenas
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? 'O título é obrigatório' : null,
                onSaved: (value) => _titulo = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty) ? 'A descrição é obrigatória' : null,
                onSaved: (value) => _descricao = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prioridadeController,
                decoration: const InputDecoration(labelText: 'Prioridade', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'A prioridade é obrigatória';
                  if (int.tryParse(value) == null) return 'Insira um número válido';
                  return null;
                },
                onSaved: (value) => _prioridade = int.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departamentoController,
                decoration: const InputDecoration(labelText: 'Departamento', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? 'O departamento é obrigatório' : null,
                onSaved: (value) => _departamento = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
