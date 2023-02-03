import 'package:fluttertest/database/entities/attribute.dart';
import 'package:fluttertest/database/entities/teamUser.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'entities/team.dart';
import 'entities/user.dart';

class AppDatabase{
  static Database? database;

  static List<User>? users;
  static List<Attribute>? attributes;
  static List<Team>? teams;
  static List<User>? teamUsers;

  static const String userSQL = 'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);';
  static const String attributeSQL = 'CREATE TABLE attributes(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, threshold INTEGER, rangeStart INTEGER, rangeEnd INTEGER);';
  static const String teamSQL = 'CREATE TABLE teams(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);';
  static const String teamUserSQL = 'CREATE TABLE teamUser(id INTEGER PRIMARY KEY AUTOINCREMENT, teamId INTEGER REFERENCES teams(id), userId INTEGER REFERENCES users(id));';

   static openAppDatabase() async {
     database = await openDatabase(
       join(await getDatabasesPath(), 'database.db'),
       onCreate: (db, version) async{
         await db.execute(userSQL);
         await db.execute(attributeSQL);
         await db.execute(teamSQL);
         await db.execute(teamUserSQL);
         },
         version: 2,
     );
   }

   static Future<void> insertUser(User user) async{
     await database?.insert(
         'users',
          user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
     );
   }

  static Future<void> insertTeam(Team team) async{
    await database?.insert(
      'teams',
      team.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertAttribute(Attribute attribute) async{
    await database?.insert(
      'attributes',
      attribute.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertTeamUser(TeamUser teamUser) async{
    await database?.insert(
      'teamUser',
      teamUser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateAttribute(Attribute attribute) async{
     await database?.update(
         "attributes",
         attribute.toMap(),
         where: 'id = ?',
         whereArgs: [attribute.id]
     );
  }

   static Future<void> getUsers() async{
     final List<Map<String, Object?>>? maps = await database?.query('users');
     if(maps == null){
       return;
     }
     users = List.generate(maps.length, (index) {
       return User(
         maps[index]['id'] as int,
         maps[index]['name'] as String,
       );
     });
   }

  static Future<void> getAttributes() async{

    final List<Map<String, Object?>>? maps = await database?.query('attributes');
    if(maps == null){
      return;
    }
    attributes = List.generate(maps.length, (index) {
      return Attribute(
        maps[index]['id'] as int,
        maps[index]['name'] as String,
        maps[index]['threshold'] as int,
        maps[index]['rangeStart'] as int,
        maps[index]['rangeEnd'] as int,
      );
    });
  }

  static Future<void> getTeams() async{
    final List<Map<String, Object?>>? maps = await database?.query('teams');
    if(maps == null){
      return;
    }
    teams = List.generate(maps.length, (index) {
      return Team(
        maps[index]['id'] as int,
        maps[index]['name'] as String,
      );
    });
  }

  static Future<void> getTeamUsers(int teamId) async{
    final List<Map<String, Object?>>? maps = await database?.rawQuery('SELECT users.* FROM teamUser JOIN users ON teamUser.userId == users.id WHERE teamUser.teamId == $teamId;');
    if(maps == null){
      return;
    }
    teamUsers = List.generate(maps.length, (index) {
      return User(
        maps[index]['id'] as int,
        maps[index]['name'] as String,
      );
    });
  }

  static Future<void> deleteEntry(int id, String table) async {
     await database?.delete(
       table,
       where: 'id = ?',
       whereArgs: [id]
     );
  }
}