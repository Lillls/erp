import 'package:json_annotation/json_annotation.dart';

part 'response_wrapper.g.dart';

@JsonSerializable()
class ResponseWrapper extends Object {
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Map<String, dynamic>? data;

  ResponseWrapper(
    this.code,
    this.data,
  );

  factory ResponseWrapper.fromJson(Map<String, dynamic> srcJson) =>
      _$ResponseWrapperFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResponseWrapperToJson(this);
}
