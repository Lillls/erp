import 'dart:collection';

import 'package:erp/data/product_response.dart';
import 'package:erp/network/api_constants.dart';
import 'package:erp/network/http_client.dart';
import 'package:erp/page/product_add_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/export_utils.dart';
import '../utils/my_style.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<ProductDataEntity> _productDataList = [];
  final LinkedHashMap<String, List<ProductDataEntity>>
      _productMapByDesignNumber = LinkedHashMap();

  @override
  void initState() {
    super.initState();
    _initProductList();
  }

  void _initProductList() async {
    ProductResponse response = ProductResponse.fromJson(
        await httpPost(ApiConstants.productList, body: {"size": -1}));
    setState(() {
      _productDataList.addAll(response.records);
      _convertList2MapByDesignNumber();
    });
  }

  void _convertList2MapByDesignNumber() {
    _productMapByDesignNumber.clear();
    for (var element in _productDataList) {
      _productMapByDesignNumber[element.designNumber] =
          _productMapByDesignNumber[element.designNumber] ?? [];
      _productMapByDesignNumber[element.designNumber]?.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "商品列表",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFFFAFAFA),
            child: Row(
              children: [
                TextButton(
                  onPressed: () async {
                    List<ProductDataEntity> exportList = [];
                    List<int> exportListParentIds = [];
                    for (var element in _productDataList) {
                      if (element.isSelected == true) {
                        exportListParentIds.add(element.parentId!);
                        exportList.addAll(
                            _productMapByDesignNumber[element.designNumber]!);
                      }
                    }
                    ProductResponse productResponse = ProductResponse.fromJson(
                        await httpPost(ApiConstants.listByIds,
                            body: exportListParentIds));
                    exportList.addAll(productResponse.records);
                    List<Map<String, dynamic>> mapList = exportList.map((e) {
                      Map<String, dynamic> map = e.toJson();
                      for (int i = 0; i < e.descriptionPictures.length; i++) {
                        map["otherImageUrl${i + 1}"] = e.descriptionPictures[i];
                      }
                      e.sizeInfo?.toJson().forEach((key, value) {
                        map[key] = value;
                      });
                      if (e.sizeInfo != null) {
                        map["sizeName"] =
                            "${e.sizeInfo!.width}x${e.sizeInfo!.height} ${e.sizeInfo!.unit}";
                      }
                      e.categoryInfo?.toJson().forEach((key, value) {
                        map[key] = value;
                      });
                      return map;
                    }).toList();
                    ExportUtils.export(mapList);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2a5eb7),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      "导出",
                      style: MyStyle.commonStyle.apply(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () async {
                    List<ProductDataEntity> mergeList = [];
                    for (var element in _productDataList) {
                      if (element.isSelected == true) {
                        mergeList.addAll(
                            _productMapByDesignNumber[element.designNumber]!);
                      }
                    }
                    await httpPost(ApiConstants.mergeProduct, body: mergeList);
                    _showToast("合并成功");
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2a5eb7),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Text(
                      "合并",
                      style: MyStyle.commonStyle.apply(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 20,
            color: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          _buildProductListView()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<ProductDataEntity> list = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProductAddPage(),
            ),
          );
          if (list.isNotEmpty) {
            setState(() {
              _productDataList.addAll(list);
              _convertList2MapByDesignNumber();
            });
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductListView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 1160),
        color: const Color(0xFFFAFAFA),
        child: ListView.separated(
          itemCount: _productMapByDesignNumber.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildProductItemTitleView();
            }
            return _buildProductItemView(index - 1);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 1,
              color: Color(0xFFF2F2F2),
              indent: 20,
              endIndent: 20,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductItemTitleView() {
    return Row(children: [
      Container(
        width: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          "选择",
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          "产品主图",
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 200,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          "分类",
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 200,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          "设计编号",
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 250,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          "搜索关键词",
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 150,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          "属性",
          style: MyStyle.commonStyle,
        ),
      ),
      Container(
        width: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          border: Border.all(color: Color(0xFFD7D7D7), width: 1),
        ),
        child: Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          "价格",
          style: MyStyle.commonStyle,
        ),
      ),
    ]);
  }

  Widget _buildProductItemView(int index) {
    var key = _productMapByDesignNumber.keys.toList()[index];
    ProductDataEntity entity = _productMapByDesignNumber[key]![0];
    return Row(
      children: [
        Container(
          width: 120,
          alignment: Alignment.center,
          child: Checkbox(
            value: entity.isSelected,
            onChanged: (bool? value) {
              entity.isSelected = value ?? false;
              setState(() {});
            },
          ),
        ),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: Image.network(
            entity.mainImageUrl,
            width: 80,
            height: 80,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: 200,
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                entity.category,
                style: MyStyle.commonStyle,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: 200,
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                entity.designNumber,
                style: MyStyle.commonStyle,
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: 250,
          alignment: Alignment.center,
          child: Text(
            entity.genericKeywords,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: MyStyle.commonStyle,
          ),
        ),
        Container(
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          alignment: Alignment.center,
          child: Text(
            entity.mainElement,
            style: MyStyle.commonStyle,
          ),
        ),
        Expanded(
          child: Container(
            width: 250,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            alignment: Alignment.center,
            child: Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                "${entity.price}",
                style: MyStyle.commonStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showToast(String msg) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12.0,
          ),
          Text(
            msg,
            style: MyStyle.commonStyle.apply(color: Colors.white),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
