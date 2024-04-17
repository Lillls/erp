import 'package:json_annotation/json_annotation.dart';

part 'sts_response.g.dart';

@JsonSerializable()
class StsResponse extends Object {

  @JsonKey(name: 'requestId')
  String requestId;

  @JsonKey(name: 'credentials')
  Credentials credentials;

  StsResponse(this.requestId,this.credentials,);

  factory StsResponse.fromJson(Map<String, dynamic> srcJson) => _$StsResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StsResponseToJson(this);

}


@JsonSerializable()
class Credentials extends Object {

  @JsonKey(name: 'securityToken')
  String securityToken;

  @JsonKey(name: 'accessKeySecret')
  String accessKeySecret;

  @JsonKey(name: 'accessKeyId')
  String accessKeyId;

  @JsonKey(name: 'expiration')
  String expiration;

  Credentials(this.securityToken,this.accessKeySecret,this.accessKeyId,this.expiration,);

  factory Credentials.fromJson(Map<String, dynamic> srcJson) => _$CredentialsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);

}


