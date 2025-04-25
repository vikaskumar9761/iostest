import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  Future<void> _loadProfileData() async {
    try {
      final profile = await Provider.of<ProfileProvider>(context, listen: false).getSavedProfile();
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
    _aadharController.addListener(_checkForChanges);
    _panController.addListener(_checkForChanges);
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
                        Expanded(child: _buildTextField(_aadharController, 'Aadhaar Number')),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            // Aadhaar verification logic
                          },
                          child: const Text('Verify'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_panController, 'PAN Number')),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            // PAN verification logic
                          },
                          child: const Text('Verify'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Colors.black : Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        onPressed: _isButtonEnabled ? null : null,
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

  Widget _buildTextField(TextEditingController controller, String label, {String? hintText}) {
    return TextField(
      controller: controller,
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