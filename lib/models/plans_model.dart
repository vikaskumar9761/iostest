class PlansModel {
  final bool success;
  final List<Plan> plans;

  PlansModel({
    required this.success,
    required this.plans,
  });

  factory PlansModel.fromJson(Map<String, dynamic> json) {
    return PlansModel(
      success: json['success'] as bool,
      plans: (json['data'] != null && json['data']['plans'] != null)
          ? (json['data']['plans'] as List)
              .map((plan) => Plan.fromJson(plan))
              .toList()
          : [], // Return empty list if no plans
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': {
        'plans': plans.map((plan) => plan.toJson()).toList(),
      },
    };
  }
}

class Plan {
  final String id;
  final int operatorId;
  final int circleId;
  final int planType;
  final String planTab;
  final String planCode;
  final double amount;
  final double talktime;
  final String validity;
  final String planName;
  final String planDescription;
  final String dataBenefit;

  Plan({
    required this.id,
    required this.operatorId,
    required this.circleId,
    required this.planType,
    required this.planTab,
    required this.planCode,
    required this.amount,
    required this.talktime,
    required this.validity,
    required this.planName,
    required this.planDescription,
    required this.dataBenefit
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'].toString(), // Fix: Convert int to String
      operatorId: json['operatorId'] as int,
      circleId: json['circleId'] as int,
      planType: json['planType'] as int,
      planTab: json['planTab'] ?? '',
      planCode: json['planCode'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      talktime: (json['talktime'] as num).toDouble(),
      validity: json['validity'] ?? '-',
      planName: json['planName'] ?? '',
      planDescription: json['planDescription'] ?? '',
      dataBenefit: json['dataBenefit'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operatorId': operatorId,
      'circleId': circleId,
      'planType': planType,
      'planTab': planTab,
      'planCode': planCode,
      'amount': amount,
      'talktime': talktime,
      'validity': validity,
      'planName': planName,
      'planDescription': planDescription,
      'dataBenefit' : dataBenefit
    };
  }
}
