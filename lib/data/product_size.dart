import 'package:json_annotation/json_annotation.dart';

part 'product_size.g.dart';

@JsonSerializable()
class ProductSize extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'unit')
  String unit;

  @JsonKey(name: 'categoryId')
  int categoryId;

  @JsonKey(name: 'symbol')
  String symbol;

  @JsonKey(name: 'sizeUrl')
  String sizeUrl;

  @JsonKey(name: 'packageWeight')
  double packageWeight;

  ProductSize(this.id, this.width, this.height, this.unit, this.categoryId,
      this.packageWeight, this.symbol, this.sizeUrl);

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isSelected = true;

  factory ProductSize.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductSizeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductSizeToJson(this);
}
