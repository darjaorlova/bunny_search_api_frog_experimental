import 'package:postgres/postgres.dart';

import '../entity/brand_entity.dart';

class BrandsDao {
  BrandsDao(this.connection) {
    table = 'brands';
  }

  late PostgreSQLConnection connection;
  late String table;

  Future<void> insert(BrandEntity entity,
      {PostgreSQLExecutionContext? tx,}) async {
    await (tx ?? connection).query(
        'INSERT INTO $table (brandId, title, organizationType, '
        'organizationWebsite, hasVeganProducts, logoUrl, status) '
        'VALUES (@brandId, @title, @organizationType, '
        '@organizationWebsite, @hasVeganProducts, @logoUrl, @status)',
        substitutionValues: <String, dynamic>{
          'brandId': entity.brandId,
          'title': entity.title,
          'organizationType': entity.organizationType,
          'organizationWebsite': entity.organizationWebsite,
          'hasVeganProducts': entity.hasVeganProducts,
          'logoUrl': entity.logoUrl,
          'status': entity.status,
        },);
  }

  Future<void> insertAll(List<BrandEntity> entities) async {
    await connection.transaction((tx) async {
      for (final entity in entities) {
        await insert(entity, tx: tx);
      }
    });
  }

  Future<void> update(
      {required String title,
      required String status,
      required String logoUrl,
      PostgreSQLExecutionContext? tx,}) async {
    await (tx ?? connection).query(
        'UPDATE $table SET status=@status, logoUrl=@logoUrl WHERE title=@title',
        substitutionValues: <String, dynamic>{
          'title': title,
          'logoUrl': logoUrl,
          'status': status,
        },);
  }

  Future<List<BrandEntity>> getAll() async {
    final List<List<dynamic>> results =
        await connection.query('SELECT * FROM $table');

    final brands = <BrandEntity>[];

    for (final row in results) {
      brands.add(
        BrandEntity(
          brandId: row[7] as String,
          title: row[1] as String,
          organizationType: row[2] as String,
          organizationWebsite: row[3] as String,
          hasVeganProducts: row[4] as bool?,
          logoUrl: row[5] as String?,
          status: row[6] as String?,
        ),
      );
    }

    return brands;
  }

  Future<List<BrandEntity>> getByType(String type) async {
    final List<List<dynamic>> results = await connection.query(
      'SELECT * FROM $table WHERE organizationType=@type',
      substitutionValues: <String, dynamic>{'type': type},
    );

    final brands = <BrandEntity>[];

    for (final row in results) {
      brands.add(
        BrandEntity(
          brandId: row[7] as String,
          title: row[1] as String,
          organizationType: row[2] as String,
          organizationWebsite: row[3] as String,
          hasVeganProducts: row[4] as bool?,
          logoUrl: row[5] as String?,
          status: row[6] as String?,
        ),
      );
    }

    return brands;
  }

  Future<List<BrandEntity>> getByStatus(String status) async {
    final List<List<dynamic>> results = await connection.query(
      'SELECT * FROM $table WHERE status=@status',
      substitutionValues: <String, dynamic>{'status': status},
    );

    final brands = <BrandEntity>[];

    for (final row in results) {
      brands.add(
        BrandEntity(
          brandId: row[7] as String,
          title: row[1] as String,
          organizationType: row[2] as String,
          organizationWebsite: row[3] as String,
          hasVeganProducts: row[4] as bool?,
          logoUrl: row[5] as String?,
          status: row[6] as String?,
        ),
      );
    }

    return brands;
  }
}
