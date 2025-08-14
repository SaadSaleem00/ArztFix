import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _patientFormKey = GlobalKey<FormState>();
  final _doctorFormKey = GlobalKey<FormState>();

  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientEmailController = TextEditingController();
  final TextEditingController _patientPasswordController = TextEditingController();

  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _doctorEmailController = TextEditingController();
  final TextEditingController _doctorPasswordController = TextEditingController();
  final TextEditingController _medicalLicenseController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();

  DateTime? _selectedDate;
  List<bool> _isSelected = [true, false]; // Initial selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select your role:'),
            const SizedBox(height: 16),
            ToggleButtons(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Patient'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Doctor'),
                ),
              ],
              isSelected: _isSelected,
              onPressed: (int index) {
                setState(() {
                  _isSelected = [false, false];
                  _isSelected[index] = true;
                });
              },
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isSelected[0])
                      _buildPatientRegistrationForm()
                    else
                      _buildDoctorRegistrationForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientRegistrationForm() {
    return Form(
      key: _patientFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _patientNameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _patientEmailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _patientPasswordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                errorText: _selectedDate == null &&
                        _patientFormKey.currentState?.validate() == false
                    ? 'Please select your date of birth'
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _registerPatient();
            },
            child: const Text('Register as Patient'),
          ),
        ],
      ),
    );
  }

  Future<void> _registerPatient() async {
    if (_patientFormKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _patientEmailController.text.trim(),
          password: _patientPasswordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient registered successfully!')),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    }
  }

  Widget _buildDoctorRegistrationForm() {
    return Form(
      key: _doctorFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _doctorNameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _doctorEmailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _doctorPasswordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _medicalLicenseController,
            decoration:
                const InputDecoration(labelText: 'Medical License Number'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your medical license number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _specializationController,
            decoration: const InputDecoration(labelText: 'Specialization'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your specialization';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_doctorFormKey.currentState!.validate()) {
                print('Doctor Name: ${_doctorNameController.text}');
                print('Doctor Email: ${_doctorEmailController.text}');
                print('Doctor Password: ${_doctorPasswordController.text}');
                print('Medical License: ${_medicalLicenseController.text}');
                print('Specialization: ${_specializationController.text}');
              }
            },
            child: const Text('Register as Doctor'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientEmailController.dispose();
    _patientPasswordController.dispose();
    _doctorNameController.dispose();
    _doctorEmailController.dispose();
    _doctorPasswordController.dispose();
    _medicalLicenseController.dispose();
    _specializationController.dispose();
    super.dispose();
  }
}
