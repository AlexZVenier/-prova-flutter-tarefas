import 'package:flutter/material.dart';
import 'tarefa.dart'; 
import 'db_helper.dart'; 
import 'task_form_screen.dart'; 

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>(); 
  final dbHelper = DatabaseHelper.instance;

  Future<List<Tarefa>> _loadTasks() async {
    return await dbHelper.queryAllRows();
  }

  Future<void> _refreshTaskList() async {
    setState(() {});
  }

  void _deleteTask(int id) async {
    await dbHelper.delete(id);
    _refreshTaskList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa excluída com sucesso!')),
    );
  }

  void _navigateToForm({Tarefa? tarefa}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(tarefa: tarefa),
      ),
    );
    
    if (result == true) { 
      _refreshTaskList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Cadastro de Tarefas'),
        backgroundColor: Colors.indigo,
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshTaskList,
        child: FutureBuilder<List<Tarefa>>(
          future: _loadTasks(), 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar tarefas: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
            }

            final tarefas = snapshot.data!;

            if (tarefas.isEmpty) {
              return const Center(child: Text('Nenhuma tarefa cadastrada.'));
            }

            return ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(tarefa.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tarefa.descricao),
                        Text('Departamento: ${tarefa.departamento}', style: const TextStyle(fontStyle: FontStyle.italic)),
                        Text('Prioridade: ${tarefa.prioridade}', style: TextStyle(color: _getPriorityColor(tarefa.prioridade))),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => _navigateToForm(tarefa: tarefa),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(tarefa.id!),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToForm(tarefa: tarefa),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.amber;
      case 1:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}