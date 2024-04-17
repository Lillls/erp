import 'package:erp/data/product_size.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category_response.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse extends Object {
  @JsonKey(name: 'records')
  List<ProductDataEntity> records;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'size')
  int size;

  @JsonKey(name: 'current')
  int current;

  @JsonKey(name: 'pages')
  int pages;

  ProductResponse(
    this.records,
    this.total,
    this.size,
    this.current,
    this.pages,
  );

  factory ProductResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable()
class ProductDataEntity extends Object {
  @JsonKey(name: 'id')
  int id = 0;

  @JsonKey(name: 'createTime')
  String createTime = "";

  @JsonKey(name: 'creatorName', defaultValue: "")
  String creatorName = "";

  @JsonKey(name: 'category')
  String category;

  @JsonKey(name: 'sku', defaultValue: "")
  String? sku;

  @JsonKey(name: 'mainImageUrl', defaultValue: "")
  String mainImageUrl;

  @JsonKey(name: 'designNumber', defaultValue: "")
  String designNumber;

  @JsonKey(name: 'price', defaultValue: 0.0)
  double price;

  @JsonKey(name: 'descriptionPictures', defaultValue: [])
  List<String> descriptionPictures;

  @JsonKey(name: 'keyFeature1', defaultValue: '')
  String keyFeature1;

  @JsonKey(name: 'keyFeature2', defaultValue: '')
  String keyFeature2;

  @JsonKey(name: 'keyFeature3', defaultValue: '')
  String keyFeature3;

  @JsonKey(name: 'keyFeature4', defaultValue: '')
  String keyFeature4;

  @JsonKey(name: 'keyFeature5', defaultValue: '')
  String keyFeature5;

  @JsonKey(name: 'parentage', defaultValue: "")
  String parentage;

  @JsonKey(name: 'parentSku', defaultValue: "")
  String? parentSku;

  @JsonKey(name: 'genericKeywords', defaultValue: '')
  String genericKeywords;

  @JsonKey(name: 'caption', defaultValue: "")
  String caption;

  @JsonKey(name: 'description', defaultValue: "")
  String description;

  @JsonKey(name: 'categoryId')
  int categoryId;

  @JsonKey(name: 'exportCount', defaultValue: 0)
  int exportCount = 0;

  @JsonKey(name: 'sizeInfo')
  ProductSize? sizeInfo;

  @JsonKey(name: 'categoryInfo')
  SimpleCategoryEntity? categoryInfo;

  @JsonKey(name: 'sizeId')
  int? sizeId;

  @JsonKey(name: 'parentId')
  int? parentId;

  @JsonKey(name: 'mainElement', defaultValue: "")
  String mainElement;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isSelected = false;

  ProductDataEntity(
      {required this.category,
      required this.designNumber,
      required this.price,
      required this.descriptionPictures,
      required this.mainImageUrl,
      required this.keyFeature1,
      required this.keyFeature2,
      required this.keyFeature3,
      required this.keyFeature4,
      required this.keyFeature5,
      required this.genericKeywords,
      required this.caption,
      required this.description,
      required this.mainElement,
      required this.categoryId,
      required this.sizeId,
      required this.parentage,
      this.categoryInfo});

  factory ProductDataEntity.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductDataEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductDataEntityToJson(this);
}
