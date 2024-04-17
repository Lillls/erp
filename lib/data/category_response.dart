import 'package:erp/data/product_size.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse extends Object {
  @JsonKey(name: 'records')
  List<CategoryResponseEntity> dataList;

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'size')
  int size;

  @JsonKey(name: 'current')
  int current;

  @JsonKey(name: 'orders')
  List<dynamic> orders;

  @JsonKey(name: 'optimizeCountSql')
  bool optimizeCountSql;

  @JsonKey(name: 'searchCount')
  bool searchCount;

  @JsonKey(name: 'pages')
  int pages;

  CategoryResponse(
    this.dataList,
    this.total,
    this.size,
    this.current,
    this.orders,
    this.optimizeCountSql,
    this.searchCount,
    this.pages,
  );

  factory CategoryResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}

@JsonSerializable()
class CategoryResponseEntity extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'createTime')
  String? createTime;

  @JsonKey(name: 'categoryName')
  String categoryName;

  @JsonKey(name: 'categoryAlias1')
  String categoryAlias1;

  @JsonKey(name: 'categoryAlias2')
  String categoryAlias2;

  @JsonKey(name: 'keyFeature1')
  List<String> keyFeature1;

  @JsonKey(name: 'keyFeature2')
  List<String> keyFeature2;

  @JsonKey(name: 'keyFeature3')
  List<String> keyFeature3;

  @JsonKey(name: 'keyFeature4')
  List<String> keyFeature4;

  @JsonKey(name: 'keyFeature5')
  List<String> keyFeature5;

  @JsonKey(name: 'sizeInfos')
  List<ProductSize> sizes;

  CategoryResponseEntity(
      this.id,
      this.createTime,
      this.categoryName,
      this.categoryAlias1,
      this.categoryAlias2,
      this.keyFeature1,
      this.keyFeature2,
      this.keyFeature3,
      this.keyFeature4,
      this.keyFeature5,
      this.sizes);

  factory CategoryResponseEntity.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryResponseEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryResponseEntityToJson(this);
}

@JsonSerializable()
class SimpleCategoryEntity extends Object {
  @JsonKey(name: 'categoryName')
  String categoryName;

  @JsonKey(name: 'categoryAlias1')
  String categoryAlias1;

  @JsonKey(name: 'categoryAlias2')
  String categoryAlias2;

  SimpleCategoryEntity(
      this.categoryName, this.categoryAlias1, this.categoryAlias2);

  factory SimpleCategoryEntity.fromJson(Map<String, dynamic> srcJson) =>
      _$SimpleCategoryEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SimpleCategoryEntityToJson(this);
}
