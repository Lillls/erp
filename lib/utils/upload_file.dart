import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';

import 'log.dart';

class UploadFileUtils {
  static Future<List<PlatformFile>?> selectFile(List<String> fileSuffix) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: fileSuffix,
    );
    if (pickedFile != null) {
      return pickedFile.files;
    }
    return null;
  }

  static Future<String?> upload(PlatformFile file) async {
    Response<dynamic> response = await Client().putObject(
      file.bytes as List<int>,
      "${DateTime
          .now()
          .millisecondsSinceEpoch}-${file.name}",
      option: PutRequestOption(
        onSendProgress: (count, total) {
          Log.d("send: count = $count, and total = $total");
        },
        onReceiveProgress: (count, total) {
          Log.d("receive: count = $count, and total = $total");
        },
        override: false,
        aclModel: AclMode.publicRead,
        storageType: StorageType.ia,
      ),
    );
    return response.requestOptions.path;
  }

  static Future<List<String>> uploadFiles(List<PlatformFile> fileList) async {
    List<AssetEntity> assetEntities = fileList.map((file) =>
        AssetEntity(filename: file.name, bytes: file.bytes as List<int>))
        .toList();
    List<Response> responses = await Client().putObjects(assetEntities);
    return responses.map((e) => e.requestOptions.path).toList();
  }
}
