class OrganizationsResponse {
  OrganizationsResponse(this.organizations);

  final List<Map<String, dynamic>> organizations;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'organizations': organizations};
}
