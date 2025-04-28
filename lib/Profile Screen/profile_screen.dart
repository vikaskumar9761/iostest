import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iostest/Profile%20Screen/aadhaar_verify_screen.dart';
import 'package:iostest/Profile%20Screen/pan_verify_screen.dart';
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

  // Load profile data from Provider
  Future<void> _loadProfileData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    try {
      final profile = await profileProvider.getSavedProfile();
      if (profile != null) {
        _originalProfileData = profile;
        setState(() {
          _nameController.text = '${profile.firstName} ${profile.lastName}';
          _phoneController.text = profile.phone;
          _emailController.text = profile.email;
          _aadharController.text = profile.aadhar ?? '';
          _panController.text = profile.pan ?? '';
          _addressController.text = profile.address ?? '';
          _pinCodeController.text = profile.pinCode ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                    _buildTextField(_nameController, 'Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone Number'),
                    const SizedBox(height: 16),
                    _buildTextField(_addressController, 'Address', hintText: 'Enter your complete address'),
                    const SizedBox(height: 16),
                    _buildTextField(_pinCodeController, 'Pin Code'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email Id'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _aadharController,
                            'Aadhaar Number',
                            enabled: _aadharController.text.isEmpty, // Editable if empty
                          ),
                        ),
                        const SizedBox(width: 8),
                        _aadharController.text.isEmpty
                            ? TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AadhaarVerifyScreen(),
                                    ),
                                  ).then((_) => _loadProfileData());
                                },
                                child: const Text('Verify'),
                              )
                            : const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _panController,
                            'PAN Number',
                            enabled: _panController.text.isEmpty, // Editable if empty
                          ),
                        ),
                        const SizedBox(width: 8),
                        _panController.text.isEmpty
                            ? TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PanVerifyScreen(),
                                    ),
                                  ).then((_) => _loadProfileData());
                                },
                                child: const Text('Verify'),
                              )
                            : const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Colors.black : Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        onPressed: _isButtonEnabled
                            ? () async {
                                final updatedProfile = ProfileData(
                                  id: _originalProfileData.id,
                                  login: _originalProfileData.login,
                                  firstName: _nameController.text.split(' ').first,
                                  lastName: _nameController.text.split(' ').length > 1
                                      ? _nameController.text.split(' ').last
                                      : '',
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
                                  setState(() {
                                    _isButtonEnabled = false;
                                    _originalProfileData = updatedProfile;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to update profile')),
                                  );
                                }
                              }
                            : null,
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
}