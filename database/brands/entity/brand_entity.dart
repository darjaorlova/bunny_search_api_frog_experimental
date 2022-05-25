class BrandEntity {
  const BrandEntity({
    required this.brandId,
    required this.title,
    required this.organizationType,
    required this.organizationWebsite,
    required this.hasVeganProducts,
    required this.logoUrl,
    required this.status, // e.g. popular
  });

  factory BrandEntity.fromJson(Map<String, dynamic> json) => BrandEntity(
        brandId: json['id'] as String,
        title: json['title'] as String,
        organizationType: json['organizationType'] as String,
        organizationWebsite: json['organizationWebsite'] as String,
        hasVeganProducts: json['hasVeganProducts'] as bool? ?? false,
        logoUrl: json['logoUrl'] as String?,
        status: json['status'] as String?,
      );

  final String brandId;
  final String title;
  final String organizationType;
  final String organizationWebsite;
  final bool? hasVeganProducts;
  final String? logoUrl;
  final String? status;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'brandId': brandId,
        'title': title,
        'organizationType': organizationType,
        'organizationWebsite': organizationWebsite,
        'hasVeganProducts': hasVeganProducts,
        'logoUrl': logoUrl,
        'status': status
      };
}
