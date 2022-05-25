import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

import '../../../database/organizations/dao/organizations_dao.dart';
import '../../../database/organizations/entity/organization_entity.dart';
import '../../../routes/organizations/organizations.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockOrganizationsDao extends Mock implements OrganizationsDao {}

class _MockPostgreSQLConnection extends Mock implements PostgreSQLConnection {}

class _MockPostgreSQLExecutionContext extends Mock
    implements PostgreSQLExecutionContext {}

void main() {
  late _MockRequestContext context;
  late _MockOrganizationsDao dao;

  setUp(() {
    context = _MockRequestContext();
    dao = _MockOrganizationsDao();
    final connection = _MockPostgreSQLConnection();
    when(() => context.read<OrganizationsDao>()).thenReturn(dao);
    when(() => dao.connection).thenReturn(connection);
    when(connection.open).thenAnswer(
          (_) =>
      Future<PostgreSQLExecutionContext>.value(
        _MockPostgreSQLExecutionContext(),
      ),
    );
    when(connection.close).thenAnswer(
          (_) => Future<dynamic>.value(),
    );
  });

  group('GET /', () {
    test('responds with a 200 and organizationsResponse', () async {
      const organizations = <OrganisationEntity>[
        OrganisationEntity(
          orgId: '1',
          title: 'PETA',
          brandsCount: 50,
          website: 'www.peta.com',
        ),
        OrganisationEntity(
          orgId: '2',
          title: 'BUNNY',
          brandsCount: 100,
          website: 'www.bunny.com',
        ),
      ];

      when(dao.getAll).thenAnswer(
            (_) => Future<List<OrganisationEntity>>.value(organizations),
      );

      const organizationsResponse = <String, dynamic>{
        'organizations': <dynamic>[
          <String, dynamic>{
            'orgId': '1',
            'title': 'PETA',
            'brandsCount': 50,
            'website': 'www.peta.com'
          },
          <String, dynamic>{
            'orgId': '2',
            'title': 'BUNNY',
            'brandsCount': 100,
            'website': 'www.bunny.com'
          }
        ]
      };
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(equals(organizationsResponse)),
      );
    });
  });
}
