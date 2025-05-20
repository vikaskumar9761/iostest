class PanVerifyResponse {
  final bool success;
  final String code;
  final PanData? data;
  final String message;

  PanVerifyResponse({
    required this.success,
    required this.code,
    this.data,
    required this.message,
  });

  factory PanVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PanVerifyResponse(
      success: json['success'].toString().toLowerCase() == 'true', // ✅ force boolean
      code: json['code'] ?? '',
      data: json['data'] != null ? PanData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

class PanData {
  final String? id;
  final String? pan;
  final String? type;
  final String? referenceId;
  final String? nameProvided;
  final String? registeredName;
  final bool? valid;
  final String? message;
  final String? nameMatchScore;
  final String? nameMatchResult;
  final String? aadhaarSeedingStatus;
  final String? lastUpdatedAt;
  final String? namePanCard;
  final String? panStatus;
  final String? aadhaarSeedingStatusDesc;

  PanData({
    this.id,
    this.pan,
    this.type,
    this.referenceId,
    this.nameProvided,
    this.registeredName,
    this.valid,
    this.message,
    this.nameMatchScore,
    this.nameMatchResult,
    this.aadhaarSeedingStatus,
    this.lastUpdatedAt,
    this.namePanCard,
    this.panStatus,
    this.aadhaarSeedingStatusDesc,
  });

  factory PanData.fromJson(Map<String, dynamic> json) {
    return PanData(
      id: json['id'].toString(),
      pan: json['pan'],
      type: json['type'],
      referenceId: json['referenceId'].toString(),
      nameProvided: json['nameProvided'],
      registeredName: json['registeredName'],
      valid: json['valid'],
      message: json['message'],
      nameMatchScore: json['nameMatchScore'].toString(),
      nameMatchResult: json['nameMatchResult'],
      aadhaarSeedingStatus: json['aadhaarSeedingStatus'],
      lastUpdatedAt: json['lastUpdatedAt'],
      namePanCard: json['namePanCard'],
      panStatus: json['panStatus'],
      aadhaarSeedingStatusDesc: json['aadhaarSeedingStatusDesc'],
    );
  }
}
