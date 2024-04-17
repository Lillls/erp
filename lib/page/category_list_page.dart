import 'package:flutter/material.dart';

import '../utils/my_style.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Map<String, String>> dataList = [
    {"name": "名称", "type": "分类", "attribute": "属性"},
    {
      "name": "decorativepillowcover",
      "type": "decorative pillow covers",
      "attribute": "size-color"
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: 2,
              color: const Color(0xFFFAFAFA)),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: const Text(
              "品类列表",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          Expanded(child: _buildProductListView())
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => const ProductAddPage(),
      //       ),
      //     );
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  ListView _buildProductListView() {
    return ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: _buildProductItemView(index),
          );
        });
  }

  List<Widget> _buildProductItemView(int index) {
    return [
      Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          dataList[index]["name"]!,
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          dataList[index]["attribute"]!,
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 250,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          dataList[index]["type"]!,
          style: MyStyle.commonStyle,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
