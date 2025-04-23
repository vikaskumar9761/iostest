import 'package:iostest/models/config_model.dart';

// Model to store the selected operator
class OperatorModel {
  String? operatorId;
  String? operatorName;

  OperatorModel({ this.operatorId, this.operatorName});
}

// Operator data class
class Operator {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final Biller  biller; // Assuming Biller is a class defined in your models

  Operator({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.biller,
  });
}
