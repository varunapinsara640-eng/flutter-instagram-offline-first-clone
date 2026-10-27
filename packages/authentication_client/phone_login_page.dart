import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_client/authentication_client.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // 📲 1. දුරකථන අංකයට OTP එකක් ඉල්ලුම් කිරීම
  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || !phone.startsWith('+94')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('කරුණාකර නිවැරදි දුරකථන අංකයක් ඇතුළත් කරන්න (+9477XXXXXXX)')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // අපගේ SupabaseAuthenticationClient එකේ logInWithPhone එක මෙතනින් කැඳවයි
      await context.read<AuthenticationClient>().logInWithPhone(phoneNumber: phone);
      
      setState(() {
        _isOtpSent = true;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP කේතය සාර්ථකව දුරකථනයට යවන ලදී!')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('දෝෂයක් සිදුවිය: ${e.toString()}')),
      );
    }
  }

  // 🔑 2. ලැබුණු OTP කේතය පරීක්ෂා කර ඇතුළු වීම (Verify)
  Future<void> _verifyOTP() async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('කරුණාකර ඉලක්කම් 6ක OTP කේතය ඇතුළත් කරන්න.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // අපගේ SupabaseAuthenticationClient එකේ verifyOTP එක මෙතනින් කැඳවයි
      await context.read<AuthenticationClient>().verifyOTP(phoneNumber: phone, token: otp);
      
      setState(() => _isLoading = false);
      // ලොගින් වීම සාර්ථකයි! ඇප් එකේ ප්‍රධාන පිටුවට (Home) ස්වයංක්‍රීයව මාරු වේවි.
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP කේතය වැරදියි: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🎨 ඇප් එකේ Brand Logo එක (Instagram Clone)
                const Icon(Icons.camera_alt_outlined, size: 80, color: Colors.pink),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Instagram Clone',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // 📞 දුරකථන අංකය ඇතුළත් කරන කොටස
                TextField(
                  controller: _phoneController,
                  enabled: !_isOtpSent, // OTP යැවූ පසු මෙය වෙනස් කළ නොහැක
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: '+9477XXXXXXX',
                    prefixIcon: const Icon(Icons.phone_android),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔐 OTP කේතය ඇතුළත් කරන කොටස (පෙන්වන්නේ OTP යැවූ පසු පමණි)
                if (_isOtpSent) ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Enter 6-Digit OTP',
                      hintText: '123456',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 🚀 ක්‍රියාත්මක වන ප්‍රධාන බටන් එක
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading 
                        ? null 
                        : (_isOtpSent ? _verifyOTP : _sendOTP),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isOtpSent ? 'Verify & Login' : 'Send OTP via Ideamart',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
                
                // 🔄 නැවත අංකය වෙනස් කිරීමට අවශ්‍ය නම් (Reset Button)
                if (_isOtpSent)
                  TextButton(
                    onPressed: () => setState(() => _isOtpSent = false),
                    child: const Text('Change Phone Number'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
