import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newly_graduate_hub/services/supabase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color deepPurple = const Color(0xFF6C2786);

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ninController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Dropdown values
  String? _selectedNationality = 'Nigeria';
  String? _selectedProfession;
  DateTime? _selectedDob;

  // UI state
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  // Data
  static const List<String> _nationalities = <String>['Nigeria'];

  static const List<String> _professions = <String>[
    'Computer Science',
    'Cyber Security',
    'Information Science',
    'Software Engineering',
    'Data Science',
    'Information Technology',
    'Computer Engineering',
    'AI & Machine Learning',
    'DevOps / SRE',
    'UI/UX Design',
  ];

  @override
  void dispose() {
    _surnameController.dispose();
    _middleNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _ninController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _requireText(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    // Header
                    Stack(
                      children: [
                        ClipPath(
                          clipper: CurvedHeaderClipper(),
                          child: Container(
                            height: 220,
                            color: deepPurple,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Image.asset(
                                    'assets/pages_items/register_gradient.png',
                                    fit: BoxFit.cover,
                                    height: 60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('REGISTER',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26)),
                              const SizedBox(height: 4),
                              Text('New User Form\nKindly fill appropriately',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 32,
                          child: Image.asset(
                            'assets/pages_items/register.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),

                    // Form
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row: Surname + Middle Name
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _surnameController,
                                    label: 'Surname',
                                    validator: _requireText,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _middleNameController,
                                    label: 'Middle Name',
                                    validator: _requireText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Username
                            _buildTextFormField(
                              controller: _usernameController,
                              label: 'User Name',
                              validator: _requireText,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            _buildTextFormField(
                              controller: _emailController,
                              label: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                final r = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                                if (!r.hasMatch(v.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Nationality + DOB
                            Row(
                              children: [
                                Expanded(child: _buildNationalityDropdown()),
                                const SizedBox(width: 12),
                                Expanded(child: _buildDatePickerField()),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Profession + NIN
                            Row(
                              children: [
                                Expanded(child: _buildProfessionDropdown()),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _ninController,
                                    label: 'NIN NO.',
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'NIN is required';
                                      }
                                      final digitsOnly =
                                          v.replaceAll(RegExp(r'[^0-9]'), '');
                                      if (digitsOnly.length != 11) {
                                        return 'NIN must be 11 digits';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            Text('Mobile Number',
                                style: GoogleFonts.poppins(fontSize: 15)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/pages_items/nigeria_flag.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 62,
                                  height: 48,
                                  child: TextField(
                                    enabled: false,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: '+234',
                                      hintStyle:
                                          GoogleFonts.poppins(fontSize: 15),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _phoneController,
                                    label: '8123456789',
                                    keyboardType: TextInputType.phone,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Phone is required';
                                      }
                                      final digits =
                                          v.replaceAll(RegExp(r'[^0-9]'), '');
                                      if (digits.length < 8 ||
                                          digits.length > 11) {
                                        return 'Enter a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Passwords
                            _buildTextFormField(
                              controller: _passwordController,
                              label: 'Create Password',
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Password is required';
                                }
                                if (v.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _confirmPasswordController,
                              label: 'Re-enter Password',
                              obscureText: _obscureConfirmPassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(() =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: _isSubmitting ? null : _submitForm,
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Register',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/home'),
                                child: Text('Continue as Guest',
                                    style: GoogleFonts.poppins(
                                        color: deepPurple,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/login'),
                                child: Text('Already have an account? Login',
                                    style: GoogleFonts.poppins(
                                        color: deepPurple,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------- helpers ----------

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.poppins(fontSize: 15),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple.withOpacity(0.35), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildNationalityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedNationality,
      decoration: InputDecoration(
        hintText: 'Select Nationality',
        hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple.withOpacity(0.35), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple, width: 2),
        ),
      ),
      items: _nationalities
          .map((n) => DropdownMenuItem<String>(
                value: n,
                child: Text(n, style: GoogleFonts.poppins(fontSize: 14)),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedNationality = v),
      validator: (v) => v == null ? 'Select nationality' : null,
    );
  }

  Widget _buildProfessionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedProfession,
      decoration: InputDecoration(
        hintText: 'Select Profession',
        hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple.withOpacity(0.35), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple, width: 2),
        ),
      ),
      items: _professions
          .map((p) => DropdownMenuItem<String>(
                value: p,
                child: Text(p, style: GoogleFonts.poppins(fontSize: 14)),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedProfession = v),
      validator: (v) => v == null ? 'Select profession' : null,
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      onTap: _pickDob,
      decoration: InputDecoration(
        hintText: _dobController.text.isEmpty
            ? '01 / 11 / 2000'
            : _dobController.text,
        hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.black54),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple.withOpacity(0.35), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: deepPurple, width: 2),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today, size: 20),
          onPressed: _pickDob,
        ),
      ),
      validator: (value) {
        if (_selectedDob == null) return 'Select date of birth';
        final sixteenYearsAgo = DateTime(
            DateTime.now().year - 16, DateTime.now().month, DateTime.now().day);
        if (_selectedDob!.isAfter(sixteenYearsAgo)) {
          return 'Must be at least 16 years old';
        }
        return null;
      },
    );
  }

  Future<void> _pickDob() async {
    final DateTime today = DateTime.now();
    final DateTime initial = DateTime(today.year - 24, today.month, today.day);
    final DateTime first = DateTime(today.year - 80, 1, 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? initial,
      firstDate: first,
      lastDate: today,
      helpText: 'Select date of birth',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: deepPurple,
              onPrimary: Colors.white,
              secondary: deepPurple,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: deepPurple),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    final String dd = date.day.toString().padLeft(2, '0');
    final String mm = date.month.toString().padLeft(2, '0');
    final String yyyy = date.year.toString();
    return '$dd / $mm / $yyyy';
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isSubmitting = true);

    final String surname = _surnameController.text.trim();
    final String fullName = surname.isEmpty
        ? _usernameController.text.trim()
        : '$surname ${_middleNameController.text.trim()}'.trim();

    final userData = {
      'full_name': fullName,
      'phone': '+234${_phoneController.text.trim()}',
      'gender': 'N/A',
      'university': 'N/A',
      'graduation_year': _selectedDob?.year.toString() ?? 'N/A',
      'course': _selectedProfession ?? 'N/A',
    };

    final response = await SupabaseService().signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      userData: userData,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful! Please log in.',
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Check Supabase config.',
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Curved header clipper
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
