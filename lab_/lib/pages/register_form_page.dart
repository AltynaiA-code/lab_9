import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lab_/pages/home_page.dart';
import '../model/user.dart';
import 'user_info_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setBool('isAuthenticated', true);
  }

  // ignore: unused_element
  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      _saveUserData();
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), 
      );
    }
  }

  final List<String> _countries = ['Kazahkstan', 'Ukraine', 'Germany', 'France'];
  String _selectedCountry = 'Kazahkstan';

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register_form'.tr(), style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildTextField(
              controller: _nameController,
              focusNode: _nameFocus,
              nextFocus: _phoneFocus,
              label: 'full_name'.tr(),
              hint: 'enter_name'.tr(),
              icon: Icons.person,
              validator: validateName,
              onSaved: (val) => newUser.name = val!,
            ),
            SizedBox(height: 10.h),
            _buildTextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              nextFocus: _passFocus,
              label: 'phone'.tr(),
              hint: 'enter_phone'.tr(),
              icon: Icons.call,
              helperText: '(XXX)XXX-XXXX',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                    allow: true),
              ],
              validator: (val) =>
                  validatePhoneNumber(val!) ? null : 'phone_error'.tr(),
              onSaved: (val) => newUser.phone = val!,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'email'.tr(),
                hintText: 'enter_email'.tr(),
                icon: const Icon(Icons.mail),
              ),
              style: TextStyle(fontSize: 16.sp),
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => newUser.email = val!,
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                icon: const Icon(Icons.map),
                labelText: 'country'.tr(),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country, style: TextStyle(fontSize: 16.sp)),
                );
              }).toList(),
              onChanged: (country) {
                setState(() {
                  _selectedCountry = country as String;
                  newUser.country = country;
                });
              },
              value: _selectedCountry,
            ),
            SizedBox(height: 20.h),
            _buildPasswordField(),
            SizedBox(height: 10.h),
            TextFormField(
              controller: _confirmPassController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'confirm_password'.tr(),
                hintText: 'confirm_password'.tr(),
                icon: const Icon(Icons.border_color),
              ),
              style: TextStyle(fontSize: 16.sp),
              validator: _validatePassword,
            ),
            SizedBox(height: 15.h),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 18.sp),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text('submit'.tr()),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await context.setLocale(const Locale('kk'));
                  },
                  child: Text('KZ', style: TextStyle(fontSize: 14.sp)),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () async {
                    await context.setLocale(const Locale('en'));
                  },
                  child: Text('EN', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode nextFocus,
    required String label,
    required String hint,
    required IconData icon,
    String? helperText,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: (_) => _fieldFocusChange(context, focusNode, nextFocus),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        prefixIcon: Icon(icon),
        suffixIcon: GestureDetector(
          onLongPress: () => controller.clear(),
          child: const Icon(Icons.delete_outline, color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
      style: TextStyle(fontSize: 16.sp),
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passController,
      focusNode: _passFocus,
      obscureText: _hidePass,
      maxLength: 8,
      decoration: InputDecoration(
        labelText: 'password'.tr(),
        hintText: 'enter_password'.tr(),
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
        icon: const Icon(Icons.security),
      ),
      style: TextStyle(fontSize: 16.sp),
      validator: _validatePassword,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showDialog(name: _nameController.text);
    } else {
      _showMessage(message: 'form_error'.tr());
    }
  }

  String? validateName(String? value) {
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (value == null || value.isEmpty) {
      return 'name_required'.tr();
    } else if (!nameExp.hasMatch(value)) {
      return 'name_invalid'.tr();
    } else {
      return null;
    }
  }

  bool validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return phoneExp.hasMatch(input);
  }

  String? _validatePassword(String? value) {
    if (_passController.text.length != 8) {
      return 'password_length'.tr();
    } else if (_confirmPassController.text != _passController.text) {
      return 'password_mismatch'.tr();
    } else {
      return null;
    }
  }

  void _showMessage({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  void _showDialog({required String name}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'success_title'.tr(),
            style: TextStyle(color: Colors.green, fontSize: 20.sp),
          ),
          content: Text(
            tr('success_message', args: [name]),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(userInfo: newUser),
                  ),
                );
              },
              child: Text(
                'verified'.tr(),
                style: TextStyle(color: Colors.green, fontSize: 18.sp),
              ),
            ),
          ],
        );
      },
    );
  }
}
