import 'dart:html';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _addProduct() {
    _showDialog();
  }

  Future<void> _addProduct2() async {
    /// Use FilePicker to pick files in Flutter Web
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['xlsx'],
    );

    /// 文件被选择时
    if (pickedFile != null) {
      var newExcel = Excel.createExcel();
      var bytes = pickedFile.files.single.bytes;
      var bytes2 = bytes as List<int>;
      var excel = Excel.decodeBytes(bytes2);
      for (var table in excel.tables.keys) {
        Sheet sheetObject = newExcel[table];
        CellStyle cellStyle =
            CellStyle(fontFamily: getFontFamily(FontFamily.Calibri));
        for (int rowIndex = 0; rowIndex < excel.tables[table]!.rows.length; rowIndex++) {
          var row = excel.tables[table]!.rows[rowIndex];
          for (int columnIndex = 0; columnIndex < row.length; columnIndex++) {
            var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: rowIndex));
            var originCell = row[columnIndex];
            cell.value = originCell?.value;
            cell.cellStyle = cellStyle;
          }
        }
      }
      excel.save(fileName: 'My_Excel_File_Name.xlsx');
    }
  }

  @override
  void initState() {
    super.initState();
    var baseOptions = BaseOptions();
    Dio dio = new Dio(baseOptions);
    Client.init(
        ossEndpoint: "oss-cn-beijing.aliyuncs.com",
        bucketName: "xiaoyu-ipic",
        dio: dio,
        authGetter: _authGetter);
  }

  Auth _authGetter() {
    return const Auth(
      accessKey: "STS.NT4kFHpBY1KMuvsRofG6bj12f",
      accessSecret: '5CvXF4bU3L3ym5978ZG7PDK3BDBtiyor2sSJNDw6X27d',
      expire: "2024-04-16T11:53:23Z",
      secureToken: 'CAISzAJ1q6Ft5B2yfSjIr5eBIPz8nZ14hommd1DCtm8zS7lOhfSZhDz2IHhMfnloCe0Wt/k0nmtS7P8dlqNJQppiXlf4YNBstn3mHd0nOtivgde8yJBZoqPHcDHhMnyW9cvWZPqDA7G5U/yxalfCuzZuyL/hD1uLVECkNpv77vwCac8MDDGlcR1MBtpdOnEVyqkgOGDWKOymPzPzn2PUFzAIgAdnjn5l4qnNqa/1qDim1QGhk7NE/tivfsj5NJU9Zq0SCYnlgLZEEYPayzNV5hRw86N7sbdJ4z+vvKvGWwELs03WbrqNr4Y1d1UjP/cgebRNqf/njuF1ofDDCwMUAY+YkIu/Ogaop+DIqKOscIvBvdatrrxYaF+EVFzbg31ZZ5/mheYhdWIsNZNoYQRrQkcnKVK5YdTM80vxQVyAJsbIrudYmPQawT3WymyNeTDnKxqAAY0zb5nnfnzGvCifDq/W8PZii1QKj939trQkpE9WovbIO/ZNpKMy/HGy6eF5siCaegEPKOPmbx6v8YMlw8d6+7xfVid6fNdboanrfJjK6OkUQJDTnomgUXquB/B64BzqxucuIFJj1yPp/AkrsBFqHS00gFk3wbo5de0m6S2/UWZ7IAA=',
    );
  }


  void _showDialog() {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    CellStyle cellStyle =
        CellStyle(fontFamily: getFontFamily(FontFamily.Calibri));
    var keys = [
      "Product Type",
      "Seller SKU",
      "Brand Name",
      "Update Delete",
      "Product Exemption Reason",
      ""
    ];
    for (var i = 0; i < keys.length; i++) {
      print("A$i");
      var cell = sheetObject.cell(CellIndex.indexByString("A${i + 1}"));
      cell.value = TextCellValue(keys[i]);
      cell.cellStyle = cellStyle;
    }
    excel.save(fileName: 'My_Excel_File_Name.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct2,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
            ),
          ),
        ),
      ],
    );
  }
}
