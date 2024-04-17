import 'dart:math';

import 'package:erp/data/category_response.dart';
import 'package:erp/data/product_size.dart';
import 'package:erp/data/sts_response.dart';
import 'package:erp/network/api_constants.dart';
import 'package:erp/network/http_client.dart';
import 'package:erp/utils/log.dart';
import 'package:erp/utils/upload_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/product_response.dart';
import '../utils/my_style.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final List<ProductSize> _sizeItems = [];
  final List<CategoryResponseEntity> _categoryList = [];
  final List<String> _imgUrls = [];
  String? _mainElement;
  String? _caption;
  String _searchKeyword = "";
  String? _keyFeature1;
  String? _keyFeature2;
  String? _keyFeature3;
  String? _keyFeature4;
  String? _keyFeature5;
  CategoryResponseEntity? _categorySelectValue;
  String? _designNumber;
  String? _mainImageUrl;
  late FToast fToast;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _searchKeywordController =
      TextEditingController();
  final TextEditingController _mainElementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initOssStsToken();
    _initCategoryList();
    fToast = FToast();
    fToast.init(context);
    // 添加监听
    _captionController.addListener(() {
      _caption = _captionController.text.toLowerCase();
      _captionController.value = _captionController.value.copyWith(
        text: _caption,
      );
    });

    _searchKeywordController.addListener(() {
      _searchKeyword = _searchKeywordController.text.toLowerCase();
      _searchKeywordController.value = _searchKeywordController.value.copyWith(
        text: _searchKeyword,
      );
    });

    _mainElementController.addListener(() {
      _mainElement = _mainElementController.text.toLowerCase();
      _mainElementController.value = _mainElementController.value.copyWith(
        text: _mainElement,
      );
    });
  }

  void _initOssStsToken() async {
    StsResponse entry =
        StsResponse.fromJson(await httpGet(ApiConstants.ossSts));

    Client.init(
        ossEndpoint: "oss-cn-beijing.aliyuncs.com",
        bucketName: "xiaoyu-ipic",
        authGetter: () {
          return _authGetter(entry);
        });
  }

  void _initCategoryList() async {
    CategoryResponse categoryResponse = CategoryResponse.fromJson(
        await httpPost(ApiConstants.categoryList, body: {"size": -1}));
    setState(() {
      _categoryList.addAll(categoryResponse.dataList);
    });
  }

  Future<Auth> _authGetter(StsResponse entry) async {
    return Auth(
      accessKey: entry.credentials.accessKeyId,
      accessSecret: entry.credentials.accessKeySecret,
      expire: entry.credentials.expiration,
      secureToken: entry.credentials.securityToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTitle(), //标题
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(minHeight: 700),
                margin: const EdgeInsets.all(20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: const Color(0xFFFAFAFA),
                child: Column(
                  children: [
                    _buildCategorySelector(context), //选择品类
                    buildContentWithCategory(context)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.only(right: 50, bottom: 50, top: 10),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("取消"),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: () {
                  _addProduct();
                },
                child: const Text("保存"),
              )
            ],
          ),
        )
      ],
      persistentFooterAlignment: AlignmentDirectional.centerStart,
    );
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFFAFAFA), width: 2))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Text(
        "添加商品",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
      ),
    );
  }

  Widget buildContentWithCategory(BuildContext context) {
    if (_categorySelectValue == null) {
      return Container();
    }
    List<Widget> imageRow = [];
    imageRow.add(Text(
      "* ",
      style: MyStyle.commonStyle.apply(color: Colors.red),
    ));
    imageRow.add(Text(
      "产品主图:",
      style: MyStyle.commonStyle,
    ));
    imageRow.add(const SizedBox(
      width: 10,
    ));
    for (var value1 in _imgUrls) {
      imageRow.add(Container(
          margin: const EdgeInsets.all(10),
          width: 120,
          height: 120,
          child: Image.network(value1, fit: BoxFit.cover)));
    }
    imageRow.add(IconButton(
      onPressed: () async {
        List<PlatformFile>? fileList =
            await UploadFileUtils.selectFile(["png"]);
        if (fileList != null) {
          List<String> fileUrls = await UploadFileUtils.uploadFiles(fileList);
          fileUrls.removeWhere((_element) {
            if (_element.contains("主图")) {
              _mainImageUrl = _element;
              return true;
            }
            return false;
          });
          setState(() {
            _designNumber ??= fileList.first.name.split(".")[0];
            _imgUrls.addAll(fileUrls);
          });
        }
      },
      icon: const Icon(Icons.add),
    ));
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          children: imageRow,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              "* ",
              style: MyStyle.commonStyle.apply(color: Colors.red),
            ),
            Text(
              "核心元素:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _mainElementController,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              "* ",
              style: MyStyle.commonStyle.apply(color: Colors.red),
            ),
            Text(
              "标题:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _captionController,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              "搜索关键词:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _searchKeywordController,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _sizeItems.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "尺寸:",
                    style: MyStyle.commonStyle,
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    Text(
                        "${_sizeItems[index - 1].width}*${_sizeItems[index - 1].height}"),
                    Checkbox(
                      value: _sizeItems[index - 1].isSelected, // 当前选项的状态
                      onChanged: (bool? value) {
                        setState(() {
                          _sizeItems[index - 1].isSelected =
                              value ?? false; // 更新状态
                        });
                      },
                      activeColor: Colors.blue, // 选中时的颜色
                      checkColor: Colors.white, // 选中标记的颜色
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              "描述1:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton(
              value: _keyFeature1, // 当前选中的值
              items: _categorySelectValue!.keyFeature1
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      value,
                      style: MyStyle.commonStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _keyFeature1 = newValue;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "描述2:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton(
              value: _keyFeature2, // 当前选中的值
              items: _categorySelectValue!.keyFeature2
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      value,
                      style: MyStyle.commonStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _keyFeature2 = newValue;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "描述3:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton(
              value: _keyFeature3, // 当前选中的值
              items: _categorySelectValue!.keyFeature3
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      value,
                      style: MyStyle.commonStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _keyFeature3 = newValue;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "描述4:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton(
              value: _keyFeature4, // 当前选中的值
              items: _categorySelectValue!.keyFeature4
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      value,
                      style: MyStyle.commonStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _keyFeature4 = newValue;
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "描述5:",
              style: MyStyle.commonStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton(
              value: _keyFeature5, // 当前选中的值
              items: _categorySelectValue!.keyFeature5
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      value,
                      style: MyStyle.commonStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                _keyFeature5 = newValue;
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Row(
      children: [
        Text(
          "* ",
          style: MyStyle.commonStyle.apply(color: Colors.red),
        ),
        Text(
          "品类: ",
          style: MyStyle.commonStyle,
        ),
        const SizedBox(
          width: 30,
        ),
        DropdownButton(
          value: _categorySelectValue,
          hint: Text(
            "请先选择商品品类",
            style: MyStyle.commonStyle,
          ),
          dropdownColor: Colors.white,
          items: _categoryList.map<DropdownMenuItem<CategoryResponseEntity>>(
              (CategoryResponseEntity value) {
            return DropdownMenuItem<CategoryResponseEntity>(
              value: value,
              child: Text(
                value.categoryName,
                style: MyStyle.commonStyle,
              ),
            );
          }).toList(),
          onChanged: (CategoryResponseEntity? newValue) {
            setState(() {
              _categorySelectValue = newValue;
              _categorySelectValue!.keyFeature1 =
                  _categorySelectValue!.keyFeature1.toSet().toList();
              _categorySelectValue!.keyFeature2 =
                  _categorySelectValue!.keyFeature2.toSet().toList();
              _categorySelectValue!.keyFeature3 =
                  _categorySelectValue!.keyFeature3.toSet().toList();
              _categorySelectValue!.keyFeature4 =
                  _categorySelectValue!.keyFeature4.toSet().toList();
              _categorySelectValue!.keyFeature5 =
                  _categorySelectValue!.keyFeature5.toSet().toList();
              _keyFeature1 =
                  getRandomValueFromList(_categorySelectValue!.keyFeature1);
              _keyFeature2 =
                  getRandomValueFromList(_categorySelectValue!.keyFeature2);
              _keyFeature3 =
                  getRandomValueFromList(_categorySelectValue!.keyFeature3);
              _keyFeature4 =
                  getRandomValueFromList(_categorySelectValue!.keyFeature4);
              _keyFeature5 =
                  getRandomValueFromList(_categorySelectValue!.keyFeature5);
              _sizeItems.addAll(_categorySelectValue!.sizes);
            });
          },
        ),
      ],
    );
  }

  String? getRandomValueFromList(List<String>? list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    var nextInt = Random().nextInt(list.length);
    Log.d("Random int $nextInt, size ${list.length}");
    return list[nextInt];
  }

  void _addProduct() async {
    String? category = _categorySelectValue?.categoryName;
    if (category == null || category.isEmpty) {
      _showToast("分类名称不能为空");
      return;
    }
    if (_imgUrls.isEmpty) {
      _showToast("请上传产品主图");
      return;
    }
    if (_mainImageUrl == null || _mainImageUrl!.isEmpty) {
      _showToast("产品图中不包含主图");
      return;
    }
    if (_caption == null || _caption!.isEmpty) {
      _showToast("标题不能为空");
      return;
    }
    if (_mainElement == null || _mainElement!.isEmpty) {
      _showToast("主体元素不能为空");
      return;
    }
    List<ProductDataEntity> dataList = _sizeItems
        .where((element) => element.isSelected)
        .map((e) => ProductDataEntity(
              category: category,
              designNumber: _designNumber!,
              genericKeywords: _searchKeyword,
              caption: _caption!,
              description: _caption!,
              price: 19.9,
              descriptionPictures: _imgUrls,
              mainImageUrl: _mainImageUrl!,
              mainElement: _mainElement!,
              keyFeature1: _keyFeature1!,
              keyFeature2: _keyFeature2!,
              keyFeature3: _keyFeature3!,
              keyFeature4: _keyFeature4!,
              keyFeature5: _keyFeature5!,
              categoryId: _categorySelectValue!.id,
              sizeId: e.id,
              parentage: "child",
              categoryInfo: SimpleCategoryEntity(
                  _categorySelectValue!.categoryName,
                  _categorySelectValue!.categoryAlias1,
                  _categorySelectValue!.categoryAlias2),
            ))
        .toList();
    if (dataList.isEmpty) {
      _showToast("请选择尺寸");
      return;
    }
    ProductResponse response = ProductResponse.fromJson(
        await httpPut(ApiConstants.addProductList, body: dataList));
    Navigator.pop(context, response.records);
  }

  _showToast(String msg) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color(0xFF2a5eb7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
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
