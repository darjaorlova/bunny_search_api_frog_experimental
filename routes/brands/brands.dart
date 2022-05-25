import 'package:dart_frog/dart_frog.dart';

import '../../database/brands/dao/brands_dao.dart';
import '../../database/brands/entity/brand_entity.dart';
import '../../model/brands/brands_response.dart';

Future<Response> onRequest(RequestContext context) async {
  final queryParams = context.request.url.queryParameters;
  final type = queryParams['type'];
  final status = queryParams['status'];

  final brandsDao = context.read<BrandsDao>();
  await brandsDao.connection.open();
  var brands = <BrandEntity>[];
  // TODO(daria): request that honors both status & type
  if (status != null) {
    brands = await brandsDao.getByStatus(status);
  } else if (type != null) {
    brands = await brandsDao.getByType(type);
  } else {
    brands = await brandsDao.getAll();
  }
  await brandsDao.connection.close();

  return Response.json(
    body: BrandsResponse(
      brands.map((e) => e.toJson()).toList(),
    ).toJson(),
  );
}
