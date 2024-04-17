import 'package:excel/excel.dart';

class ExportUtils {
  static List<String> row1TabName = [
    "Product Type",
    "Seller SKU",
    "Brand Name",
    "Update Delete",
    "Product Name",
    "Product Description",
    "Manufacturer",
    "Manufacturer Part Number",
    "Item Type Keyword",
    "model",
    "Model Name",
    "Your Price",
    "Quantity",
    "Other Image URL1",
    "Other Image URL2",
    "Other Image URL3",
    "Other Image URL4",
    "Other Image URL5",
    "Other Image URL6",
    "Main Image URL",
    "Parentage",
    "Parent SKU",
    "Relationship Type",
    "Variation Theme",
    "Key Product Features",
    "Key Product Features",
    "Key Product Features",
    "Key Product Features",
    "Key Product Features",
    "Search Terms",
    "Color",
    "Size",
    "Material Type",
    "Style Name",
    "Theme",
    "Additional Features",
    "Pattern",
    "Item Type",
    "Number of Boxes",
    "Product Compliance Certificate",
    "Shape",
    "Item Length Longer Edge",
    "Item Length Unit",
    "Item Width Shorter Edge",
    "Item Width Unit",
    "Package Height",
    "Package Width",
    "Package Length",
    "Package Length Unit Of Measure",
    "Package Weight",
    "Package Weight Unit Of Measure",
    "Package Height Unit Of Measure",
    "Package Width Unit Of Measure",
    "Cpsia Warning",
    "Fabric Type",
    "Country/Region of Origin",
    "Material/Fabric Regulations",
    "Shipping-Template",
    "List Price",
    "Item Condition",
    "Handling Time",
    "Number of Items",
  ];

  static List<String> row0TabName = [
    "feed_product_type",
    "item_sku",
    "brand_name",
    "update_delete",
    "item_name",
    "product_description",
    "manufacturer",
    "part_number",
    "item_type",
    "model",
    "model_name",
    "standard_price",
    "quantity",
    "other_image_url1",
    "other_image_url2",
    "other_image_url3",
    "other_image_url4",
    "other_image_url5",
    "other_image_url6",
    "main_image_url",
    "parent_child",
    "parent_sku",
    "relationship_type",
    "variation_theme",
    "bullet_point1",
    "bullet_point2",
    "bullet_point3",
    "bullet_point4",
    "bullet_point5",
    "generic_keywords",
    "color_name",
    "size_name",
    "material_type",
    "style_name",
    "theme",
    "special_features1",
    "pattern_name",
    "item_type_name",
    "number_of_boxes",
    "required_product_compliance_certificate",
    "item_shape",
    "length_longer_edge",
    "length_longer_edge_unit_of_measure",
    "width_shorter_edge",
    "width_shorter_edge_unit_of_measure",
    "package_height",
    "package_width",
    "package_length",
    "package_length_unit_of_measure",
    "package_weight",
    "package_weight_unit_of_measure",
    "package_height_unit_of_measure",
    "package_width_unit_of_measure",
    "cpsia_cautionary_statement",
    "fabric_type1",
    "country_of_origin",
    "supplier_declared_material_regulation1",
    "merchant_shipping_group_name",
    "list_price",
    "condition_type",
    "fulfillment_latency",
    "number_of_items",
  ];

  static Map<String, String> fixedData = {
    "brand_name": "Generic",
    "update_delete": "Update",
    "manufacturer": "Generic",
    "quantity": "500",
    "relationship_type": "Variation",
    "variation_theme": "size-color",
    "material_type": "Variation",
    "special_features1": "Bagged",
    "number_of_boxes": "1",
    "required_product_compliance_certificate": "Not Applicable",
    "item_shape": "Square",
    "length_longer_edge_unit_of_measure": "Inches",
    "width_shorter_edge_unit_of_measure": "Inches",
    "package_height": "0.8",
    "package_width": "10.25",
    "package_length": "11",
    "package_length_unit_of_measure": "IN",
    "package_weight_unit_of_measure": "LB",
    "package_height_unit_of_measure": "IN",
    "package_width_unit_of_measure": "IN",
    "cpsia_cautionary_statement": "NoWarningApplicable",
    "fabric_type1": "velvet",
    "country_of_origin": "China",
    "supplier_declared_material_regulation1": "Not Applicable",
    "condition_type": "New",
    "fulfillment_latency": "3",
    "number_of_items": "2",
    "merchant_shipping_group_name": "FBW",
  };

  static Map<String, List<String>> searchMap = {
    "sku": [
      "item_sku",
      "part_number",
      "model",
      "model_name",
    ],
    "category": ["feed_product_type"],
    "caption": ["item_name"],
    "description": ["product_description"],
    "categoryAlias1": ["item_type_name"],
    "categoryAlias2": ["item_type"],
    "otherImageUrl1": ["other_image_url1"],
    "otherImageUrl2": ["other_image_url2"],
    "otherImageUrl3": ["other_image_url3"],
    "otherImageUrl4": ["other_image_url4"],
    "otherImageUrl5": ["other_image_url5"],
    "mainImageUrl": ["main_image_url"],
    "parentage": ["parent_child"],
    "parentSku": ["parent_sku"],
    "price": ["standard_price", "list_price"],
    "mainElement": ["style_name", "theme", "pattern_name"],
    "genericKeywords": ["generic_keywords"],
    "sizeName": ["size_name"],
    "keyFeature1": ["bullet_point1"],
    "keyFeature2": ["bullet_point2"],
    "keyFeature3": ["bullet_point3"],
    "keyFeature4": ["bullet_point4"],
    "keyFeature5": ["bullet_point5"],
    "unit": ["length_longer_edge_unit_of_measure","width_shorter_edge_unit_of_measure",""],
    "packageWeight": ["package_weight"],
    "sizeUrl": ["other_image_url6"],
    "width": ["width_shorter_edge"],
    "height": ["length_longer_edge"],
  };

  static Future<void> export(List<Map<String, dynamic>> data) async {
    Excel excel = Excel.createExcel();
    Sheet sheet = excel["Sheet1"];
    insertTableHeader(sheet);

    insertDynamicData(sheet, data);

    insertFixedData(sheet, data);

    //
    excel.save();
  }

  ///用_的数据作为检索的key
  ///动态数据插入
  static void insertDynamicData(Sheet sheet, List<Map<String, dynamic>> data) {
    for (var searchKey in searchMap.keys) {
      //动态数据对应的列,string类型
      List<String> searchValue = searchMap[searchKey]!;
      //对应的列,index类型
      List<int> matchColumn = [];
      for (int columnIndex = 0;
          columnIndex < sheet.rows[1].length;
          columnIndex++) {
        Data cellData = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: 0));
        if (searchValue.contains(cellData.value.toString())) {
          matchColumn.add(columnIndex);
        }
      }
      //根据对应的列,index类型从3行插入数据
      for (int index = 0; index < data.length; index++) {
        //需要插入的数据
        String? value = data[index][searchKey]?.toString();
        if (value == null) {
          break;
        }
        for (var columIndex in matchColumn) {
          Data cellData = sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: columIndex, rowIndex: 2 + index));
          cellData.value = TextCellValue(value);
          cellData.cellStyle = CellStyle(
              fontFamily: getFontFamily(FontFamily.Calibri),
              horizontalAlign: HorizontalAlign.Center,
              textWrapping: TextWrapping.WrapText,
              verticalAlign: VerticalAlign.Center);
          sheet.setColumnWidth(columIndex, 20);
        }
      }
    }
  }

  ///写死数据插入
  static void insertFixedData(Sheet sheet, List<Map<String, dynamic>> data) {
    for (var fixedDataKey in fixedData.keys) {
      //对应的列,index类型
      List<int> matchColumn = [];
      for (int columnIndex = 0;
          columnIndex < sheet.rows[1].length;
          columnIndex++) {
        Data cellData = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: columnIndex, rowIndex: 0));
        if (fixedDataKey == cellData.value.toString()) {
          matchColumn.add(columnIndex);
        }
      }
      //需要插入的数据
      String value = fixedData[fixedDataKey]!;
      //根据对应的列,index类型从3行插入数据
      for (int index = 0; index < data.length; index++) {
        for (var columIndex in matchColumn) {
          Data cellData = sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: columIndex, rowIndex: 2 + index));
          cellData.value = TextCellValue(value);
          cellData.cellStyle = CellStyle(
              fontFamily: getFontFamily(FontFamily.Calibri),
              horizontalAlign: HorizontalAlign.Center,
              textWrapping: TextWrapping.WrapText,
              verticalAlign: VerticalAlign.Center);
          sheet.setColumnWidth(columIndex, 20);
        }
        sheet.setRowHeight(2 + index, 30);
      }
    }
  }

  static void insertTableHeader(Sheet sheet) {
    for (int index = 0; index < row0TabName.length; index++) {
      Data cellData = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 0));
      cellData.value = TextCellValue(row0TabName[index]);
      cellData.cellStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Calibri),
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center);
      sheet.setColumnWidth(index, 20);
    }
    for (int index = 0; index < row1TabName.length; index++) {
      Data cellData = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 1));
      cellData.value = TextCellValue(row1TabName[index]);
      cellData.cellStyle = CellStyle(
          fontFamily: getFontFamily(FontFamily.Calibri),
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center);
    }
    sheet.setRowHeight(0, 30);
    sheet.setRowHeight(1, 30);
  }
}
