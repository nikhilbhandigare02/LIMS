import 'package:flutter/material.dart';
import '../../../../core/widgets/RegistrationInput/RegistrationWidget.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = true;
  bool _obscurePassword = true;

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dropdown controllers
  String? _selectedDistrict;
  String? _selectedRegion;
  String? _selectedDivision;
  String? _selectedArea;

  // Sample data for dropdowns
  final List<String> _districts = ['District A', 'District B', 'District C', 'District D'];
  final List<String> _regions = ['Region 1', 'Region 2', 'Region 3', 'Region 4'];
  final List<String> _divisions = ['Division X', 'Division Y', 'Division Z'];
  final List<String> _areas = ['Area 1', 'Area 2', 'Area 3', 'Area 4'];

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Username: ${_usernameController.text}');
      print('Full Name: ${_fullNameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      print('District: $_selectedDistrict');
      print('Region: $_selectedRegion');
      print('Division: $_selectedDivision');
      print('Area: $_selectedArea');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Enhanced top curved header
          Stack(
            children: [
              ClipPath(
                clipper: CurvedClipper(),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 220,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 40, left: 24),
                child: const Text(
                  'FSO REGISTRATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                  ),
                ),
              ),
            ],
          ),

          // Scrollable Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      controller: _fullNameController,
                      label: 'Full name',
                      icon: Icons.account_circle_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Color(0xFF1E88E5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildDropdownField(
                      label: 'District',
                      value: _selectedDistrict,
                      items: _districts,
                      icon: Icons.location_city_outlined,
                      onChanged: (value) => setState(() => _selectedDistrict = value),
                      validator: (value) => value == null ? 'Please select a district' : null,
                    ),
                    const SizedBox(height: 20),
                    buildDropdownField(
                      label: 'Region',
                      value: _selectedRegion,
                      items: _regions,
                      icon: Icons.map_outlined,
                      onChanged: (value) => setState(() => _selectedRegion = value),
                      validator: (value) => value == null ? 'Please select a region' : null,
                    ),
                    const SizedBox(height: 20),
                    buildDropdownField(
                      label: 'Division',
                      value: _selectedDivision,
                      items: _divisions,
                      icon: Icons.business_outlined,
                      onChanged: (value) => setState(() => _selectedDivision = value),
                      validator: (value) => value == null ? 'Please select a division' : null,
                    ),
                    const SizedBox(height: 20),
                    buildDropdownField(
                      label: 'Area',
                      value: _selectedArea,
                      items: _areas,
                      icon: Icons.place_outlined,
                      onChanged: (value) => setState(() => _selectedArea = value),
                      validator: (value) => value == null ? 'Please select an area' : null,
                    ),
                    const SizedBox(height: 24),

                    // Terms and Conditions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (val) {
                                setState(() => _agreeToTerms = val ?? false);
                              },
                              activeColor: const Color(0xFF1E88E5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree with ',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Color(0xFF1E88E5),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Sign up Button with gradient and enhanced styling
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: _agreeToTerms
                            ? LinearGradient(
                          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                            : null,
                        color: _agreeToTerms ? null : Colors.grey[300],
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: _agreeToTerms ? [
                          BoxShadow(
                            color: Color(0xFF1E88E5).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ] : [],
                      ),
                      child: ElevatedButton(
                        onPressed: _agreeToTerms ? _handleSignUp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Already a member
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Already have an account? Sign in",
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom curved clipper
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    final controlPoint = Offset(size.width / 2, size.height + 20);
    final endPoint = Offset(size.width, size.height - 60);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}