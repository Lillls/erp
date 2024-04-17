// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    var baseOptions = BaseOptions();
    Dio dio = new Dio(baseOptions);
    Client.init(
        ossEndpoint: "oss-cn-beijing.aliyuncs.com",
        bucketName: "xiaoyu-ipic",
        authGetter: _authGetter);
  }

  Auth _authGetter() {
    return Auth(
      accessKey: "STS.NT4kFHpBY1KMuvsRofG6bj12f",
      accessSecret: '5CvXF4bU3L3ym5978ZG7PDK3BDBtiyor2sSJNDw6X27d',
      expire: "2024-04-16T11:53:23Z",
      secureToken: 'CAISzAJ1q6Ft5B2yfSjIr5eBIPz8nZ14hommd1DCtm8zS7lOhfSZhDz2IHhMfnloCe0Wt/k0nmtS7P8dlqNJQppiXlf4YNBstn3mHd0nOtivgde8yJBZoqPHcDHhMnyW9cvWZPqDA7G5U/yxalfCuzZuyL/hD1uLVECkNpv77vwCac8MDDGlcR1MBtpdOnEVyqkgOGDWKOymPzPzn2PUFzAIgAdnjn5l4qnNqa/1qDim1QGhk7NE/tivfsj5NJU9Zq0SCYnlgLZEEYPayzNV5hRw86N7sbdJ4z+vvKvGWwELs03WbrqNr4Y1d1UjP/cgebRNqf/njuF1ofDDCwMUAY+YkIu/Ogaop+DIqKOscIvBvdatrrxYaF+EVFzbg31ZZ5/mheYhdWIsNZNoYQRrQkcnKVK5YdTM80vxQVyAJsbIrudYmPQawT3WymyNeTDnKxqAAY0zb5nnfnzGvCifDq/W8PZii1QKj939trQkpE9WovbIO/ZNpKMy/HGy6eF5siCaegEPKOPmbx6v8YMlw8d6+7xfVid6fNdboanrfJjK6OkUQJDTnomgUXquB/B64BzqxucuIFJj1yPp/AkrsBFqHS00gFk3wbo5de0m6S2/UWZ7IAA=',
    );
  }

  @override
  Widget build(BuildContext context) {
    var map = {'Access-Control-Allow-Origin':'*','Access-Control-Allow-Credentials':'true'};
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter aliyun oss example"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                final bytes = "Hello World".codeUnits;
                await Client().putObject(
                  bytes,
                  "filename.txt",
                  option: PutRequestOption(
                    onSendProgress: (count, total) {
                      if (kDebugMode) {
                        print("send: count = $count, and total = $total");
                      }
                    },
                    onReceiveProgress: (count, total) {
                      if (kDebugMode) {
                        print("receive: count = $count, and total = $total");
                      }
                    },
                    override: false,
                    aclModel: AclMode.private,
                    storageType: StorageType.standard,
                    callback: const Callback(
                      callbackUrl: "callbackUrl",
                      callbackBody:
                      "{\"mimeType\":\${mimeType}, \"filepath\":\${object},\"size\":\${size},\"bucket\":\${bucket},\"phone\":\${x:phone}}",
                      callbackVar: {"x:phone": "android"},
                      calbackBodyType: CalbackBodyType.json,
                    )
                  ),
                );
              },
              child: const Text("Upload object"),
            ),
            TextButton(
              onPressed: () async {
                await Client().getObject(
                  "filename.txt",
                  onReceiveProgress: (count, total) {
                    debugPrint("received = $count, total = $total");
                  },
                );
              },
              child: const Text("Get object"),
            ),
            TextButton(
              onPressed: () async {
                await Client().downloadObject(
                  "filename.txt",
                  "./example/savePath.txt",
                  onReceiveProgress: (count, total) {
                    debugPrint("received = $count, total = $total");
                  },
                );
              },
              child: const Text("Download object"),
            ),
            TextButton(
              onPressed: () async {
                await Client().deleteObject("filename.txt");
              },
              child: const Text("Delete object"),
            ),
            TextButton(
              onPressed: () async {
                await Client().putObjects(
                  [
                    AssetEntity(
                      filename: "filename1.txt",
                      bytes: "files1".codeUnits,
                      option: PutRequestOption(
                        onSendProgress: (count, total) {
                          if (kDebugMode) {
                            print("send: count = $count, and total = $total");
                          }
                        },
                        onReceiveProgress: (count, total) {
                          if (kDebugMode) {
                            print(
                                "receive: count = $count, and total = $total");
                          }
                        },
                        override: true,
                        aclModel: AclMode.inherited,
                      ),
                    ),
                    AssetEntity(
                        filename: "filename2.txt", bytes: "files2".codeUnits),
                  ],
                );
              },
              child: const Text("Batch upload object"),
            ),
            TextButton(
              onPressed: () async {
                await Client()
                    .deleteObjects(["filename1.txt", "filename2.txt"]);
              },
              child: const Text("Batch delete object"),
            ),
          ],
        ),
      ),
    );
  }
}