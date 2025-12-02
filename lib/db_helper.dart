import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// Importe sua classe Tarefa
import 'tarefa.dart'; 

class DatabaseHelper {
  // ⚠️ ATUALIZE SEU RA AQUI ⚠️
  static const String RA = '202310290'; 
  
  static const String _databaseName = 'tarefas_$RA.db';
  static const int _databaseVersion = 1;

  static const String tabela = 'tarefas';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  
  // Getter para o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // MÉTODO createDatabase() - Requisito obrigatório para o print
  _initDatabase() async {
    // path_provider para obter o diretório de documentos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    
    // Constrói o caminho completo do arquivo .db com o RA
    String path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Define a estrutura da tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        prioridade INTEGER NOT NULL,
        criadoEm TEXT NOT NULL,
        departamento TEXT NOT NULL 
      )
    ''');
    print('Tabela "$tabela" criada com sucesso!');
  }
  
  // --- Métodos CRUD (Commit 3) ---

  // C - INSERIR
  Future<int> insert(Tarefa tarefa) async {
    Database db = await instance.database;
    // O id é ignorado se for null
    return await db.insert(tabela, tarefa.toMap()); 
  }

  // R - LISTAR TODOS
  Future<List<Tarefa>> queryAllRows() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tabela);
    
    // Converte a List<Map> em List<Tarefa>
    return List.generate(maps.length, (i) {
      return Tarefa.fromMap(maps[i]);
    });
  }

  // U - ATUALIZAR
  Future<int> update(Tarefa tarefa) async {
    Database db = await instance.database;
    int id = tarefa.id!;
    return await db.update(
      tabela,
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // D - EXCLUIR
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}