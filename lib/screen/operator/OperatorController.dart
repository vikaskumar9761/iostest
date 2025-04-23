// lib/controller/operator_controller.dart
import 'package:flutter/material.dart';
import 'package:iostest/models/config_model.dart';
import 'package:iostest/models/operator_model.dart';
import 'package:iostest/utils/config_util.dart';


class OperatorController extends ChangeNotifier {
  final List<BillerRoot> billerRoot;
  final String categoryId;
  final String phoneNumber;

  List<Operator> allOperators = [];
  List<Operator> filteredOperators = [];
  final OperatorModel selectedOperator = OperatorModel();

  bool isLoading = false;

  OperatorController({
    required this.billerRoot,
    required this.categoryId,
    required this.phoneNumber,
  });

  Future<void> loadOperators() async {
    isLoading = true;
    notifyListeners();

    try {
      List<Operator> operators = [];

      for (var billerRootItem in billerRoot) {
        for (var biller in billerRootItem.billers) {
          operators.add(
            Operator(
              id: biller.op.toString(),
              name: billerRootItem.name,
              description: billerRootItem.name,
              logoUrl: 'assets/images/bharat-connect.png',
              biller: biller,
            ),
          );
        }
      }

      allOperators = operators;
      filteredOperators = operators;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterOperators(String query) {
    if (query.isEmpty) {
      filteredOperators = allOperators;
    } else {
      filteredOperators = allOperators
          .where((op) =>
              op.name.toLowerCase().contains(query.toLowerCase()) ||
              op.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<List<Circle>> getCirclesForOperator(Operator operator) async {
    List<Circle> allCircles = await ConfigUtil.getCircles();
    List<Circle> matchedCircles = [];

    for (var circleId in operator.biller.circles) {
      final matchingCircle = allCircles.firstWhere(
        (circle) => circle.circleId == circleId.toString(),
        orElse: () => Circle(circleId: "0", name: "Unknown Circle"),
      );

      if (matchingCircle.circleId != "0") {
        matchedCircles.add(matchingCircle);
      }
    }

    return matchedCircles;
  }
}
