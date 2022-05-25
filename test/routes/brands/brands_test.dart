import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

import '../../../database/brands/dao/brands_dao.dart';
import '../../../database/brands/entity/brand_entity.dart';
import '../../../routes/brands/brands.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockBrandsDao extends Mock implements BrandsDao {}

class _MockPostgreSQLConnection extends Mock implements PostgreSQLConnection {}

class _MockPostgreSQLExecutionContext extends Mock
    implements PostgreSQLExecutionContext {}

void main() {
  late _MockRequestContext context;
  late _MockBrandsDao dao;

  setUp(() {
    context = _MockRequestContext();
    dao = _MockBrandsDao();
    final connection = _MockPostgreSQLConnection();
    when(() => context.read<BrandsDao>()).thenReturn(dao);
    when(() => dao.connection).thenReturn(connection);
    when(connection.open).thenAnswer(
      (_) => Future<PostgreSQLExecutionContext>.value(
        _MockPostgreSQLExecutionContext(),
      ),
    );
    when(connection.close).thenAnswer(
      (_) => Future<dynamic>.value(),
    );
  });

  group('GET /', () {
    test('responds with a 200 and allBrandsResponse if query params are empty',
        () async {
      const allBrands = <BrandEntity>[
        BrandEntity(
          brandId: '1',
          title: 'brand 1',
          organizationType: 'peta',
          organizationWebsite: 'peta.com',
          hasVeganProducts: true,
          logoUrl: null,
          status: null,
        ),
        BrandEntity(
          brandId: '2',
          title: 'brand 2',
          organizationType: 'peta',
          organizationWebsite: 'peta.com',
          hasVeganProducts: true,
          logoUrl: null,
          status: null,
        ),
        BrandEntity(
          brandId: '3',
          title: 'brand 3',
          organizationType: 'peta',
          organizationWebsite: 'peta.com',
          hasVeganProducts: true,
          logoUrl: null,
          status: 'popular',
        ),
        BrandEntity(
          brandId: '4',
          title: 'brand 4',
          organizationType: 'bunny',
          organizationWebsite: 'bunny.com',
          hasVeganProducts: true,
          logoUrl: null,
          status: 'popular',
        ),
      ];

      when(dao.getAll).thenAnswer(
        (_) => Future<List<BrandEntity>>.value(allBrands),
      );

      const allBrandsResponse = <String, dynamic>{
        'brands': [
          <String, dynamic>{
            'brandId': '1',
            'title': 'brand 1',
            'organizationType': 'peta',
            'organizationWebsite': 'peta.com',
            'hasVeganProducts': true,
            'logoUrl': null,
            'status': null,
          },
          <String, dynamic>{
            'brandId': '2',
            'title': 'brand 2',
            'organizationType': 'peta',
            'organizationWebsite': 'peta.com',
            'hasVeganProducts': true,
            'logoUrl': null,
            'status': null,
          },
          <String, dynamic>{
            'brandId': '3',
            'title': 'brand 3',
            'organizationType': 'peta',
            'organizationWebsite': 'peta.com',
            'hasVeganProducts': true,
            'logoUrl': null,
            'status': 'popular',
          },
          <String, dynamic>{
            'brandId': '4',
            'title': 'brand 4',
            'organizationType': 'bunny',
            'organizationWebsite': 'bunny.com',
            'hasVeganProducts': true,
            'logoUrl': null,
            'status': 'popular',
          },
        ]
      };

      when(() => context.request).thenReturn(
        Request(
          'GET',
          Uri.https(
            '',
            '/brands',
          ),
        ),
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(equals(allBrandsResponse)),
      );
    });

    test('responds with a 200 and popularBrandsResponse if status == popular',
        () async {
      const popularBrands = <BrandEntity>[
        BrandEntity(
          brandId: '3',
          title: 'brand 3',
          organizationType: 'peta',
          organizationWebsite: 'peta.com',
          hasVeganProducts: true,
          logoUrl: null,
          status: 'popular',
        ),
        BrandEntity(
          brandId: '4',
          title: 'brand 4',
          organizationType: 'bunny',
          organizationWebsite: 'bunny.com',
          hasVeganProducts: true,
          logoUrl: null,
          status: 'popular',
        ),
      ];

      when(() => dao.getByStatus('popular')).thenAnswer(
        (_) => Future<List<BrandEntity>>.value(popularBrands),
      );

      const popularBrandsResponse = <String, dynamic>{
        'brands': [
          <String, dynamic>{
            'brandId': '3',
            'title': 'brand 3',
            'organizationType': 'peta',
            'organizationWebsite': 'peta.com',
            'hasVeganProducts': true,
            'logoUrl': null,
            'status': 'popular',
          },
          <String, dynamic>{
            'brandId': '4',
            'title': 'brand 4',
            'organizationType': 'bunny',
            'organizationWebsite': 'bunny.com',
            'hasVeganProducts': true,
            'logoUrl': null,
            'status': 'popular',
          },
        ]
      };

      when(() => context.request).thenReturn(
        Request(
          'GET',
          Uri.https('', '/brands', <String, String>{'status': 'popular'}),
        ),
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(equals(popularBrandsResponse)),
      );
    });
  });

  test('responds with a 200 and bunnyBrandsResponse if type == bunny',
      () async {
    const bunnyBrands = <BrandEntity>[
      BrandEntity(
        brandId: '4',
        title: 'brand 4',
        organizationType: 'bunny',
        organizationWebsite: 'bunny.com',
        hasVeganProducts: true,
        logoUrl: null,
        status: 'popular',
      ),
    ];

    when(() => dao.getByType('bunny')).thenAnswer(
      (_) => Future<List<BrandEntity>>.value(bunnyBrands),
    );

    const bunnyBrandsResponse = <String, dynamic>{
      'brands': [
        <String, dynamic>{
          'brandId': '4',
          'title': 'brand 4',
          'organizationType': 'bunny',
          'organizationWebsite': 'bunny.com',
          'hasVeganProducts': true,
          'logoUrl': null,
          'status': 'popular',
        },
      ]
    };

    when(() => context.request).thenReturn(
      Request(
        'GET',
        Uri.https('', '/brands', <String, String>{'type': 'bunny'}),
      ),
    );
    final response = await route.onRequest(context);
    expect(response.statusCode, equals(HttpStatus.ok));
    expect(
      response.json(),
      completion(equals(bunnyBrandsResponse)),
    );
  });
}
