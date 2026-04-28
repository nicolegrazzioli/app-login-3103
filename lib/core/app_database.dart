import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database; //? = pode ser nulo

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!; //! = nao nulo
    _database = await _initDatabase();
    return _database!;
  }
 
  Future<Database> _initDatabase() async {
    /* final path = join(
        await getDatabasesPath(), 'database.db'); //onde tem que abrir/criar
        */

    final String path;
    if (kIsWeb) {
      path = 'database.db';
    } else {
      path = join(await getDatabasesPath(), 'database.db');
    }
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabela de Usuários (Perfil e Autenticação)
        await db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              email TEXT,
              password TEXT,
              phone TEXT,
              profile_image TEXT
            )
            ''');
            
        // Tabela de Viagens
        await db.execute('''
            CREATE TABLE trips(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER,
              title TEXT,
              start_date TEXT,
              end_date TEXT,
              cover_type TEXT,
              FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
            ''');
            
        // Tabela de Gastos por Viagem
        await db.execute('''
            CREATE TABLE expenses(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              trip_id INTEGER,
              title TEXT,
              amount REAL,              -- valor na moeda estrangeira
              currency TEXT,            -- código da moeda (USD, EUR, etc)
              category TEXT,
              date TEXT,
              is_average_cost INTEGER,  -- 1 para usar VET, 0 para câmbio manual
              exchange_rate REAL,       -- preenchido se is_average_cost for 0
              amount_brl REAL,          -- valor convertido em R$ no momento do gasto
              description TEXT,
              photo_path TEXT,
              FOREIGN KEY (trip_id) REFERENCES trips (id) ON DELETE CASCADE
            )
            ''');
            
        // Tabela de Transações de Câmbio (Compra de Moedas)
        await db.execute('''
            CREATE TABLE currency_transactions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER,
              amount REAL,
              currency TEXT,
              amount_brl REAL,
              source TEXT,
              date TEXT,
              vet_rate REAL,
              description TEXT,
              photo_path TEXT,
              FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
            ''');
            
        // Tabela de Carteira (Saldo de cada moeda por usuário)
        await db.execute('''
            CREATE TABLE wallets(
              user_id INTEGER,
              currency TEXT,
              balance REAL,             -- Saldo total na moeda
              average_vet REAL,         -- Custo médio (VET) atual desta moeda
              PRIMARY KEY (user_id, currency),
              FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
            ''');
      },
    );
  }
}
