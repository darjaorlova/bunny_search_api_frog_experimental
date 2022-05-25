class BrandsResponse {
  BrandsResponse(this.brands);

  final List<Map<String, dynamic>> brands;

  Map<String, dynamic> toJson() => <String, dynamic>{'brands': brands};
}
