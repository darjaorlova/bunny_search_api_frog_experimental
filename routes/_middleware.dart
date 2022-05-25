import 'package:dart_frog/dart_frog.dart';

import '../database/brands/dao/brands_dao.dart';
import '../database/connection.dart';
import '../database/organizations/dao/organizations_dao.dart';

Handler middleware(Handler handler) {
  final db = DB();

  return handler
      .use(requestLogger())
      .use(provider<DB>((_) => db))
      .use(provider<OrganizationsDao>((_) => OrganizationsDao(db.connection)))
      .use(provider<BrandsDao>((_) => BrandsDao(db.connection)));
}
