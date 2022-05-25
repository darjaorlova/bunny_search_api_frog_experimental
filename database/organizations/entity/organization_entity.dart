class OrganisationEntity {
  const OrganisationEntity({
    required this.orgId,
    required this.title,
    required this.brandsCount,
    required this.website,
  });

  factory OrganisationEntity.fromJson(Map<String, dynamic> json) =>
      OrganisationEntity(
        orgId: json['orgId'] as String,
        title: json['title'] as String,
        brandsCount: json['brandsCount'] as int,
        website: json['website'] as String,
      );

  final String orgId;
  final String title;
  final int brandsCount;
  final String website;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'orgId': orgId,
        'title': title,
        'brandsCount': brandsCount,
        'website': website
      };
}
