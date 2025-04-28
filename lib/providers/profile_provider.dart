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

  /// Fetch profile data from API and store it in SharedPreferences
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
        print("Fetched Profile Data: ${response['data']}"); // Debug log

        // Save profile data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileData', json.encode(response['data']));

        _profile = ProfileResponse.fromJson(response);
        print("In-Memory Profile Data: $_profile"); // Debug log
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      print("Error Fetching Profile: $e"); // Debug log
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get saved profile data from SharedPreferences
  Future<ProfileData?> getSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('profileData');

    if (profileString != null) {
      try {
        final profileJson = json.decode(profileString);
        return ProfileData.fromJson(profileJson);
      } catch (e) {
        print("Error parsing saved profile data: $e"); // Debug log
        return null;
      }
    }
    return null;
  }

  /// Update profile data to the server and store it in SharedPreferences
  Future<bool> updateProfile(ProfileData updatedProfile) async {
    final token = await SecureStorageService.getToken();
    if (token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final url = UrlConstants.profile;
      final body = updatedProfile.toJson();

      print("Updating Profile with Data: $body"); // Debug log

      final response = await _apiHelper.putrequest(url, body);

      if (response['success'] == true) {
        print("Updated Profile Response: ${response['data']}"); // Debug log

        final prefs = await SharedPreferences.getInstance();

        if (response['data'] != null) {
          // Save updated profile data to SharedPreferences
          await prefs.setString('profileData', json.encode(response['data']));
          _profile = ProfileResponse.fromJson(response);
        } else {
          // If data is null, use previously saved profile
          final savedProfile = await getSavedProfile();
          if (savedProfile != null) {
            _profile = ProfileResponse(
              success: true,
              code: "200",
              data: savedProfile,
              message: "Profile updated successfully",
            );
          }
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print("Error Updating Profile: $e"); // Debug log
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}