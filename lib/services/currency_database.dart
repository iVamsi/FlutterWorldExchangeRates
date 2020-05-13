import 'package:worldexchangerates/models/currency_entity.dart';
import 'package:worldexchangerates/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyDatabase {
  CurrencyDatabase._();

  static final CurrencyDatabase db = CurrencyDatabase._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'currency_database.db'),
      // When the database is first created, create a table to store currencies.
      onCreate: (db, version) async {
        await db.execute(
          """CREATE TABLE ${Constants.TABLE_CURRENCIES}(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Constants.KEY_COLUMN_CURRENCY_ID} TEXT,
            ${Constants.KEY_COLUMN_CURRENCY_NAME} TEXT, 
            ${Constants.KEY_COLUMN_CURRENCY_VALUE} REAL, 
            ${Constants.KEY_COLUMN_CURRENCY_FAVORITE} TEXT, 
            ${Constants.KEY_COLUMN_CURRENCY_BASE} TEXT)""",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertCurrency(CurrencyEntity currency) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the currency into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same currency is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      Constants.TABLE_CURRENCIES,
      currency.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CurrencyEntity>> getCurrenciesFromDatabase() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all the currencies.
    final List<Map<String, dynamic>> maps =
        await db.query(Constants.TABLE_CURRENCIES);

    // Convert the List<Map<String, dynamic> into a List<CurrencyEntity>.
    return List.generate(maps.length, (i) {
      return CurrencyEntity(
          currencyId: maps[i][Constants.KEY_COLUMN_CURRENCY_ID],
          currencyName: maps[i][Constants.KEY_COLUMN_CURRENCY_NAME],
          currencyValue: maps[i][Constants.KEY_COLUMN_CURRENCY_VALUE],
          currencyFavorite: maps[i][Constants.KEY_COLUMN_CURRENCY_FAVORITE],
          baseCurrency: maps[i][Constants.KEY_COLUMN_CURRENCY_BASE]);
    });
  }

  Future<void> updateCurrency(CurrencyEntity currencyEntity) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given currency.
    await db.update(
      Constants.TABLE_CURRENCIES,
      currencyEntity.toMap(),
      // Ensure that the Currency has a matching id.
      where: "id = ?",
      // Pass the Currency's id as a whereArg to prevent SQL injection.
      whereArgs: [currencyEntity.currencyId],
    );
  }

  Future<void> deleteCurrency(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Currency from the database.
    await db.delete(
      Constants.TABLE_CURRENCIES,
      // Use a `where` clause to delete a specific currency.
      where: "id = ?",
      // Pass the Currency's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
