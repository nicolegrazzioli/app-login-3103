import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:app_final/core/app_database.dart';

import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("--- Iniciando Aplicativo ---");

  try {
    if (kIsWeb) {
      print("Configurando databaseFactory para Web...");
      databaseFactory = databaseFactoryFfiWeb;
    }
    
    print("Tentando inicializar o banco de dados...");
    // Inicialização do banco de dados conforme o PDF
    await AppDatabase().database;
    print("Banco de dados inicializado com sucesso!");
  } catch (e) {
    print("ERRO ao inicializar banco de dados: $e");
    // Mesmo com erro no banco, chamamos o runApp para não ficar tela branca
  }

  runApp(const MyApp());
}
