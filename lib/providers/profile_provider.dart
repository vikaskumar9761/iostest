import 'package:flutter/foundation.dart';
import 'package:iostest/apiservice/api_base_helper.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/config/url_constants.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileResponse? _profile;
  bool _isLoading = false;
  String? _error;
    final ApiBaseHelper _apiHelper = ApiBaseHelper();


  ProfileResponse? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isUserActivated => _profile?.data.activated ?? false;

  Future<bool> fetchProfile() async {
    final token = await SecureStorageService.getToken();

    if (token == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {


      final url = UrlConstants.profile;
      
            final response = await _apiHelper.getrequest(url);

      if (response['success'] == true && response['code'] == '200') {
                final profile = ProfileData.fromJson(response['data']);

        _isLoading = false;
        notifyListeners();
        return profile.login!=null;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}