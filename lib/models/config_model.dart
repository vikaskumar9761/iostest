class ConfigModel {
  final List<Category> categories;
  final String specialRechargeIcon;
  final String subBillerIcon;
  final String bbpsIconUrl;
  final String circleIcon;
  final List<Circle> circles;
  final List<BrowsePlan> browsePlansMapping;
  final String supportLink;
  final String version;

  ConfigModel({
    required this.categories,
    required this.specialRechargeIcon,
    required this.subBillerIcon,
    required this.bbpsIconUrl,
    required this.circleIcon,
    required this.circles,
    required this.browsePlansMapping,
    required this.supportLink,
    required this.version,
  });

factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      categories: List<Category>.from(
        (json['category'] as List?)?.map((x) => Category.fromJson(x)) ?? [],
      ),
      specialRechargeIcon: json['specialRechargeIcon'] as String? ?? '',
      subBillerIcon: json['subBillerIcon'] as String? ?? '',
      bbpsIconUrl: json['bbpsIconUrl'] as String? ?? '',
      circleIcon: json['circleIcon'] as String? ?? '',
      circles: List<Circle>.from(
        (json['circles'] as List?)?.map((x) => Circle.fromJson(x)) ?? [],
      ),
      browsePlansMapping: List<BrowsePlan>.from(
        (json['browsePlansMapping'] as List?)?.map((x) => BrowsePlan.fromJson(x)) ?? [],
      ),
      supportLink: json['supportLink'] as String? ?? '',
      version: (json['version'] ?? '').toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'category': categories.map((x) => x.toJson()).toList(),
      'specialRechargeIcon': specialRechargeIcon,
      'subBillerIcon': subBillerIcon,
      'bbpsIconUrl': bbpsIconUrl,
      'circleIcon': circleIcon,
      'circles': circles.map((x) => x.toJson()).toList(),
      'browsePlansMapping': browsePlansMapping.map((x) => x.toJson()).toList(),
      'supportLink': supportLink,
      'version': version,
    };
  }

}

class Circle {
  final String circleId;
  final String name;

  Circle({
    required this.circleId,
    required this.name,
  });

  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      circleId: json['circleId'].toString(), // Convert to String
      name: json['name'] as String,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'circleId': circleId,
      'name': name,
    };
  }
}

class BrowsePlan {
  final String planId;
  final String planName;

  BrowsePlan({
    required this.planId,
    required this.planName,
  });

  factory BrowsePlan.fromJson(Map<String, dynamic> json) {
    return BrowsePlan(
      planId: json['planId'].toString(), // Convert to String
      planName: json['planName'] as String,
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'planName': planName,
    };
  }
}

class Category {
  final String categoryId;
  final String categoryUrl;
  final String name;
  final String savedConnectionTitle;
  final String newConnectionLabel;
  final bool payLaterBillsEnabled;
  final String icon;
  final String operatorFieldIcon;
  final List<BillerRoot> billerRoot;

  Category({
    required this.categoryId,
    required this.categoryUrl,
    required this.name,
    required this.savedConnectionTitle,
    required this.newConnectionLabel,
    required this.payLaterBillsEnabled,
    required this.icon,
    required this.operatorFieldIcon,
    required this.billerRoot,
  });

   factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] as String? ?? '',
      categoryUrl: json['categoryUrl'] as String? ?? '',
      name: json['name'] as String? ?? '',
      savedConnectionTitle: json['savedConnectionTitle'] as String? ?? '',
      newConnectionLabel: json['newConnectionLabel'] as String? ?? '',
      payLaterBillsEnabled: json['payLaterBillsEnabled'] as bool? ?? false,
      icon: json['icon'] as String? ?? '',
      operatorFieldIcon: json['operatorFieldIcon'] as String? ?? '',
      billerRoot: List<BillerRoot>.from(
        (json['billerRoot'] as List?)?.map((x) => BillerRoot.fromJson(x)) ?? [],
      ),
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryUrl': categoryUrl,
      'name': name,
      'savedConnectionTitle': savedConnectionTitle,
      'newConnectionLabel': newConnectionLabel,
      'payLaterBillsEnabled': payLaterBillsEnabled,
      'icon': icon,
      'operatorFieldIcon': operatorFieldIcon,
      'billerRoot': billerRoot.map((x) => x.toJson()).toList(),
    };
  }
}

class BillerRoot {
  final String name;
  final List<Biller> billers;

  BillerRoot({
    required this.name,
    required this.billers,
  });

  factory BillerRoot.fromJson(Map<String, dynamic> json) {
    return BillerRoot(
      name: json['name'] as String,
      billers: List<Biller>.from(
        (json['billers'] as List).map((x) => Biller.fromJson(x)),
      ),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'billers': billers.map((x) => x.toJson()).toList(),
    };
  }
}

class Biller {
  final int op;
  final List<Field> fields;
  final bool isAmountRequired;
  final bool disableCreditCard;
  final String seoAlias;
  final bool isSpecialRecharge;
  final String info;
  final String type; // Existing type field
  final List<int> circles; // New circles field

  Biller({
    required this.op,
    required this.fields,
    required this.isAmountRequired,
    required this.disableCreditCard,
    required this.seoAlias,
    required this.isSpecialRecharge,
    required this.info,
    required this.type,
    required this.circles, // Initialize the new field
  });

  factory Biller.fromJson(Map<String, dynamic> json) {
    return Biller(
      op: json['op'] is String ? int.parse(json['op']) : json['op'] as int? ?? 0,
      fields: List<Field>.from(
        (json['fields'] as List?)?.map((x) => Field.fromJson(x)) ?? [],
      ),
      isAmountRequired: json['isAmountRequired'] as bool? ?? false,
      disableCreditCard: json['disableCreditCard'] as bool? ?? false,
      seoAlias: json['seoAlias'] as String? ?? '',
      isSpecialRecharge: json['isSpecialRecharge'] as bool? ?? false,
      info: (json['info'] ?? '').toString(),
      type: json['type'] as String? ?? '',
      circles: List<int>.from(json['circles'] as List? ?? []), // Parse the new field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'op': op,
      'fields': fields.map((x) => x.toJson()).toList(),
      'isAmountRequired': isAmountRequired,
      'disableCreditCard': disableCreditCard,
      'seoAlias': seoAlias,
      'isSpecialRecharge': isSpecialRecharge,
      'info': info,
      'type': type,
      'circles': circles, // Include the new field in JSON serialization
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'op': op,
      'fields': fields.map((field) => field.toMap()).toList(),
      'isAmountRequired': isAmountRequired,
      'disableCreditCard': disableCreditCard,
      'seoAlias': seoAlias,
      'isSpecialRecharge': isSpecialRecharge,
      'info': info,
      'type': type,
      'circles': circles, // Include the new field in map serialization
    };
  }
}


class Field {
  final String id;
  final String name;
  final String type;
  final bool isnumeric;
  final String? regex;
  final int? maxLen;
  final String icon;
  final int? max;
  final int? min;
  final bool? contactPicker;
  final bool? mapOpAndCir;
  final bool? isAboveOperator;
  final bool? skipIfConnection;

  Field({
    required this.id,
    required this.name,
    required this.type,
    required this.isnumeric,
    this.regex,
    this.maxLen,
    required this.icon,
    this.max,
    this.min,
    this.contactPicker,
    this.mapOpAndCir,
    this.isAboveOperator,
    this.skipIfConnection,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isnumeric: json['isnumeric'] as bool? ?? false,
      regex: json['regex'] as String?,
      // Handle integer fields that might come as strings
      maxLen: json['maxLen'] != null 
          ? json['maxLen'] is String 
              ? int.tryParse(json['maxLen']) 
              : json['maxLen'] as int? 
          : null,
      max: json['max'] != null 
          ? json['max'] is String 
              ? int.tryParse(json['max']) 
              : json['max'] as int? 
          : null,
      min: json['min'] != null 
          ? json['min'] is String 
              ? int.tryParse(json['min']) 
              : json['min'] as int? 
          : null,
      icon: json['icon'] as String? ?? '',
      contactPicker: json['contactPicker'] as bool? ?? false,
      mapOpAndCir: json['mapOpAndCir'] as bool? ?? false,
      isAboveOperator: json['isAboveOperator'] as bool? ?? false,
      skipIfConnection: json['skipIfConnection'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isnumeric': isnumeric,
      'regex': regex,
      'maxLen': maxLen,
      'max': max,
      'min': min,
      'icon': icon,
      'contactPicker': contactPicker,
      'mapOpAndCir': mapOpAndCir,
      'isAboveOperator': isAboveOperator,
      'skipIfConnection': skipIfConnection,
    };
  }


   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isnumeric': isnumeric,
      'regex': regex,
      'maxLen': maxLen,
      'icon': icon,
    };
  }
}