import 'package:postgres/postgres.dart';

import '../entity/organization_entity.dart';

class OrganizationsDao {
  OrganizationsDao(this.connection) {
    table = 'organizations';
  }

  late PostgreSQLConnection connection;
  late String table;

  Future<void> insert(
    OrganisationEntity entity, {
    PostgreSQLExecutionContext? tx,
  }) async {
    await (tx ?? connection).query(
      'INSERT INTO $table (orgId, title, brandsCount, website) '
      'VALUES (@orgId, @title, @brandsCount, @website)',
      substitutionValues: <String, dynamic>{
        'orgId': entity.orgId,
        'title': entity.title,
        'brandsCount': entity.brandsCount,
        'website': entity.website,
      },
    );
  }

  Future<void> insertAll(List<OrganisationEntity> entities) async {
    await connection.transaction((tx) async {
      for (final entity in entities) {
        await insert(entity, tx: tx);
      }
    });
  }

  Future<List<OrganisationEntity>> getAll() async {
    final List<List<dynamic>> results =
        await connection.query('SELECT * FROM $table');

    final organizations = <OrganisationEntity>[];

    for (final row in results) {
      organizations.add(
        OrganisationEntity(
          orgId: row[1] as String,
          title: row[2] as String,
          brandsCount: row[3] as int,
          website: row[4] as String,
        ),
      );
    }

    return organizations;
  }
}
