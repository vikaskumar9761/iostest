import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iostest/screen/Profile%20Screen/aadhaar_verify_screen.dart';
import 'package:iostest/screen/Profile%20Screen/pan_verify_screen.dart';
import 'package:iostest/providers/profile_provider.dart';
import 'package:iostest/models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();

  bool _isLoading = true;
  bool _isButtonEnabled = false;

  late ProfileData _originalProfileData;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _addListeners();
  }

  /// Load profile data from Provider
  Future<void> _loadProfileData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    try {
      final success = await profileProvider.fetchProfile();
      if (success) {
        final profile = profileProvider.profile?.data;
        if (profile != null) {
          setState(() {
            _originalProfileData = profile;
            _nameController.text = '${profile.firstName} ${profile.lastName}';
            _phoneController.text = profile.phone;
            _emailController.text = profile.email;
            _addressController.text = profile.address ?? '';
            _pinCodeController.text = profile.pinCode ?? '';
            _aadharController.text = profile.aadhar ?? '';
            _panController.text = profile.pan ?? '';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error Loading Profile Data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Add listeners to detect changes in text fields
  void _addListeners() {
    _nameController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
    _addressController.addListener(_checkForChanges);
    _pinCodeController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _aadharController.addListener(() {
      _checkForChanges();
      setState(() {});
    });
    _panController.addListener(() {
      _checkForChanges();
      setState(() {});
    });
  }

  /// Check if any field has changed
  void _checkForChanges() {
    final hasChanges = _nameController.text != '${_originalProfileData.firstName} ${_originalProfileData.lastName}' ||
        _phoneController.text != _originalProfileData.phone ||
        _emailController.text != _originalProfileData.email ||
        _aadharController.text != (_originalProfileData.aadhar ?? '') ||
        _panController.text != (_originalProfileData.pan ?? '') ||
        _addressController.text != (_originalProfileData.address ?? '') ||
        _pinCodeController.text != (_originalProfileData.pinCode ?? '');

    setState(() {
      _isButtonEnabled = hasChanges;
    });
  }

  /// Update profile data
  Future<void> _updateProfile() async {
    final nameParts = _nameController.text.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final updatedProfile = ProfileData(
      id: _originalProfileData.id,
      login: _originalProfileData.login,
      firstName: firstName,
      lastName: lastName,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      pinCode: _pinCodeController.text,
      pan: _panController.text,
      aadhar: _aadharController.text,
      imageUrl: _originalProfileData.imageUrl,
      activated: _originalProfileData.activated,
      langKey: _originalProfileData.langKey,
      balance: _originalProfileData.balance,
      refCode: _originalProfileData.refCode,
    );

    final success = await Provider.of<ProfileProvider>(context, listen: false)
        .updateProfile(updatedProfile);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Fetch the updated profile data
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final fetchSuccess = await profileProvider.fetchProfile();

      if (fetchSuccess && mounted) {
        setState(() {
          _originalProfileData = profileProvider.profile!.data;
          _nameController.text = '${_originalProfileData.firstName} ${_originalProfileData.lastName}';
          _phoneController.text = _originalProfileData.phone;
          _emailController.text = _originalProfileData.email;
          _aadharController.text = _originalProfileData.aadhar ?? '';
          _panController.text = _originalProfileData.pan ?? '';
          _addressController.text = _originalProfileData.address ?? '';
          _pinCodeController.text = _originalProfileData.pinCode ?? '';
          _isButtonEnabled = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(_nameController, 'Name',enabled: false),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number',enabled: false),
                    const SizedBox(height: 16),
                    _buildTextField(_addressController, 'Address', hintText: 'Enter your complete address'),
                    const SizedBox(height: 16),
                    _buildTextField(_pinCodeController, 'Pin Code'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email Id'),
                    const SizedBox(height: 16),
                    _buildVerificationRow(
                      controller: _aadharController,
                      label: 'Aadhaar Number',
                      verifyScreen: const AadhaarVerifyScreen(),
                    ),
                    const SizedBox(height: 16),
                    _buildVerificationRow(
                      controller: _panController,
                      label: 'PAN Number',
                      verifyScreen: const PanVerifyScreen(),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Colors.black : Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        onPressed: _isButtonEnabled ? _updateProfile : null,
                        child: const Text(
                          'UPDATE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Build a text field
  Widget _buildTextField(TextEditingController controller, String label, {String? hintText, bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  /// Build a verification row for Aadhaar or PAN
  Widget _buildVerificationRow({
    required TextEditingController controller,
    required String label,
    required Widget verifyScreen,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller,
            label,
            enabled: controller.text.isEmpty, // Editable if empty
          ),
        ),
        const SizedBox(width: 8),
        controller.text.isEmpty
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => verifyScreen),
                  ).then((_) => _loadProfileData());
                },
                child: const Text('Verify'),
              )
            : const Icon(Icons.check_circle, color: Colors.green),
      ],
    );
  }
}