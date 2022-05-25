import 'package:dart_frog/dart_frog.dart';

import '../../database/organizations/dao/organizations_dao.dart';
import '../../model/organizations/organizations_response.dart';

Future<Response> onRequest(RequestContext context) async {
  final organizationsDao = context.read<OrganizationsDao>();
  await organizationsDao.connection.open();
  final organizations = await organizationsDao.getAll();
  await organizationsDao.connection.close();

  return Response.json(
    body: OrganizationsResponse(
      organizations.map((e) => e.toJson()).toList(),
    ).toJson(),
  );
}
