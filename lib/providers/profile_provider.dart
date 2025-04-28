import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:iostest/apiservice/api_base_helper.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/config/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Fetch profile data from API and store it in SharedPreferences
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

        // Save profile data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileData', json.encode(response['data']));

        _profile = ProfileResponse.fromJson(response['data']);
        _isLoading = false;
        notifyListeners();
        return profile.login != null;
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

  

  // Get saved profile data from SharedPreferences
  Future<ProfileData?> getSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('profileData');

    if (profileString != null) {
      final profileJson = json.decode(profileString);
      return ProfileData.fromJson(profileJson);
    }
    return null;
  }

  // Update profile data to the server
 Future<bool> updateProfile(ProfileData updatedProfile) async {
  final token = await SecureStorageService.getToken();
  if (token == null) return false;

  _isLoading = true;
  notifyListeners();

  try {
    final url = UrlConstants.profile; // Ensure this is the correct endpoint
    final body = {
      "email": updatedProfile.email,
      "phone": updatedProfile.phone,
      "address": updatedProfile.address,
      "pinCode": updatedProfile.pinCode,
      "firstName": updatedProfile.firstName,
      "lastName": updatedProfile.lastName,
    };

    final response = await ApiBaseHelper().putrequest(url, body); // Send PUT request

    if (response['success'] == true) {
      // Save updated profile data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileData', json.encode(response['data']));

      // Update the in-memory profile data
      _profile = ProfileResponse.fromJson(response['data']);
      _isLoading = false;
      notifyListeners(); // Notify listeners to rebuild the UI
      return true;
    } else {
      throw Exception(response['message'] ?? 'Failed to update profile');
    }
  } catch (e) {
    _isLoading = false;
    _error = e.toString();
    notifyListeners();
    return false;
  }
}
}
