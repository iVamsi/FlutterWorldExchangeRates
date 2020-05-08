import 'package:flutterworldexchangerates/models/currency_entity.dart';
import 'package:flutterworldexchangerates/strings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyDatabase {

  //TODO: Optimize the way we create and initialize database
  Future<Database> _database; 

  CurrencyDatabase() {
    createDatabase();
  }

  void createDatabase() async {
    _database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'currency_database.db'),
    // When the database is first created, create a table to store currencies.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE ${Strings.TABLE_CURRENCIES}(id INTEGER PRIMARY KEY, name TEXT, value REAL, favorite TEXT, base TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  }
     

  Future<void> insertCurrency(CurrencyEntity currency) async {
    // Get a reference to the database.
    final Database db = await _database;

    // Insert the currency into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same currency is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      Strings.TABLE_CURRENCIES,
      currency.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CurrencyEntity>> getCurrenciesFromDatabase() async {
    // Get a reference to the database.
    final Database db = await _database;

    // Query the table for all the currencies.
    final List<Map<String, dynamic>> maps = await db.query(Strings.TABLE_CURRENCIES);

    // Convert the List<Map<String, dynamic> into a List<CurrencyEntity>.
    return List.generate(maps.length, (i) {
      return CurrencyEntity(
        currencyId: maps[i][Strings.KEY_COLUMN_CURRENCY_ID],
        currencyName: maps[i][Strings.KEY_COLUMN_CURRENCY_NAME],
        currencyValue: maps[i][Strings.KEY_COLUMN_CURRENCY_VALUE],
        currencyFavorite: maps[i][Strings.KEY_COLUMN_CURRENCY_FAVORITE],
        baseCurrency: maps[i][Strings.KEY_COLUMN_CURRENCY_BASE]
      );
    });
  }

  Future<void> updateCurrency(CurrencyEntity currencyEntity) async {
    // Get a reference to the database.
    final db = await _database;

    // Update the given currency.
    await db.update(
      Strings.TABLE_CURRENCIES,
      currencyEntity.toMap(),
      // Ensure that the Currency has a matching id.
      where: "id = ?",
      // Pass the Currency's id as a whereArg to prevent SQL injection.
      whereArgs: [currencyEntity.currencyId],
    );
  }

  Future<void> deleteCurrency(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Remove the Currency from the database.
    await db.delete(
      Strings.TABLE_CURRENCIES,
      // Use a `where` clause to delete a specific currency.
      where: "id = ?",
      // Pass the Currency's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}