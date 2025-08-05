import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/Themes/colors/colorsTheme.dart';
import '../../../core/widgets/RegistrationInput/RegistrationWidget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with TickerProviderStateMixin {

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  String? selectedGender;
  String? selectedState;
  String? selectedCity;
  bool agreeToTerms = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> stateOptions = ['Maharashtra', 'Gujarat', 'Karnataka', 'Tamil Nadu'];
  final List<String> cityOptions = ['Mumbai', 'Pune', 'Nagpur', 'Nashik'];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    // Add your registration logic here
    print('Registration data:');
    print('Name: ${_firstNameController.text} ${_lastNameController.text}');
    print('Email: ${_emailController.text}');
    print('Phone: ${_phoneController.text}');
    print('Gender: $selectedGender');
    print('State: $selectedState');
    print('City: $selectedCity');

    // Show success message or navigate to next screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful!'),
        backgroundColor: Color(0xFF4B3DFE),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 20),

                // Header with back button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.arrow_back_ios,
                            color: customColors.primary,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create Account",
                            style: TextStyle(
                              color: customColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 15),


                // Decorative avatar section
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 70,
                        backgroundColor: Color(0xFFF2F2F2),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: customColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add,
                          color: customColors.primary,
                          size: 50,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // Registration Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First Name and Last Name Row
                      Row(
                        children: [
                          Expanded(
                            child: RegistrationWidgets.buildTextField(
                              controller: _firstNameController,
                              hintText: 'First Name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RegistrationWidgets.buildTextField(
                              controller: _lastNameController,
                              hintText: 'Last Name',
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      RegistrationWidgets.buildTextField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      RegistrationWidgets.buildTextField(
                        controller: _phoneController,
                        hintText: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length != 10) {
                            return 'Please enter valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Gender and State Row
                      Row(
                        children: [
                          Expanded(
                            child: RegistrationWidgets.buildDropdownField(
                              label: 'Gender',
                              value: selectedGender,
                              items: genderOptions,
                              icon: Icons.person_outline,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RegistrationWidgets.buildDropdownField(
                              label: 'State',
                              value: selectedState,
                              items: stateOptions,
                              icon: Icons.location_on_outlined,
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value;
                                  selectedCity = null; // Reset city when state changes
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select state';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // City
                      RegistrationWidgets.buildDropdownField(
                        label: 'City',
                        value: selectedCity,
                        items: cityOptions,
                        icon: Icons.location_city_outlined,
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select city';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      RegistrationWidgets.buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: !isPasswordVisible,
                        isPassword: true,
                        onPasswordToggle: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      RegistrationWidgets.buildTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: !isConfirmPasswordVisible,
                        isPassword: true,
                        onPasswordToggle: () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),


                      const SizedBox(height: 25),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            elevation: 0,
                          ),
                          onPressed:  () {

                          },
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      Text(
                        '© 2024 Food Safety Organization',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}