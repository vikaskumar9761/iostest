import 'package:flutter/material.dart';
import 'package:iostest/config/secure_storage_service.dart';
import 'package:iostest/screen/LoginScreen.dart';
import 'package:iostest/screen/Profile%20Screen/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:iostest/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String userName = "Loading...";
  String userPhone = "Loading...";
  String? userImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data from SharedPreferences via ProfileProvider
  Future<void> _loadProfileData() async {
    try {
      final profile =
          await Provider.of<ProfileProvider>(
            context,
            listen: false,
          ).getSavedProfile();
      if (profile != null) {
        setState(() {
          userName = '${profile.firstName} ${profile.lastName}';
          userPhone = profile.phone;
          userImageUrl =
              profile
                  .imageUrl; // Make sure imageUrl exists in your ProfileData model
          _isLoading = false;
        });
      } else {
        setState(() {
          userName = "No User Found";
          userPhone = "N/A";
          userImageUrl = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error Loading Data";
        userPhone = "N/A";
        userImageUrl = null;
        _isLoading = false;
      });
    }
  }

  // Logout function: clears session and navigates to Splash/Login screen
  Future<void> _logout(BuildContext context) async {
    // 1. SecureStorage clear karo
    await SecureStorageService.clearAll();

    // 2. SharedPreferences clear karo
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 3. ProfileProvider ko logout method se reset karo
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    profileProvider.logout();

    // 4. User ko login/splash screen par redirect karo
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'My Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFE8E8E8),
                              backgroundImage:
                                  userImageUrl != null &&
                                          userImageUrl!.isNotEmpty
                                      ? NetworkImage(userImageUrl!)
                                          as ImageProvider
                                      : null,
                              child:
                                  userImageUrl == null || userImageUrl!.isEmpty
                                      ? const Icon(
                                        Icons.person_outline,
                                        size: 40,
                                        color: Colors.black54,
                                      )
                                      : null,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome $userName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Phone: $userPhone',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildTile(
                        Icons.share,
                        'Refer a Friend',
                        const ReferFriendScreen(),
                      ),
                      _buildTile(
                        Icons.person_outline,
                        'User Profile',
                        const ProfileScreen(),
                      ),
                      _buildTile(
                        Icons.headset_mic_outlined,
                        'Live Support',
                        const LiveSupportScreen(),
                      ),
                      _buildTile(
                        Icons.receipt_long_outlined,
                        'Transaction History',
                        const TransactionHistoryScreen(),
                      ),
                      _buildTile(
                        Icons.privacy_tip_outlined,
                        'Privacy Policy',
                        const PrivacyPolicyScreen(),
                      ),
                      _buildTile(
                        Icons.article_outlined,
                        'Terms and Conditions',
                        const TermsAndConditionsScreen(),
                      ),
                      _buildTile(
                        Icons.policy_outlined,
                        'Refund Policy',
                        const RefundPolicyScreen(),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () => _logout(context),
                      ),
                      const SizedBox(height: 30),
                      const Text('v3.6', style: TextStyle(fontSize: 12)),
                      const Text(
                        'Powered By Dubtap Technology LLP',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
    );
  }

  // Helper for navigation tiles
  Widget _buildTile(IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}

// Dummy screens for navigation
class LiveSupportScreen extends StatelessWidget {
  const LiveSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Support')),
      body: const Center(child: Text('Live Support Screen')),
    );
  }
}

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: const Center(child: Text('Transaction History Screen')),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Center(child: Text('Privacy Policy Screen')),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
      body: const Center(child: Text('Terms and Conditions Screen')),
    );
  }
}

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refund Policy')),
      body: const Center(child: Text('Refund Policy Screen')),
    );
  }
}

class ReferFriendScreen extends StatelessWidget {
  const ReferFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refer a Friend')),
      body: const Center(child: Text('Refer a Friend Screen')),
    );
  }
}
