import 'package:flutter/material.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class NgoRegisterPage extends StatefulWidget {
  @override
  State<NgoRegisterPage> createState() => _NgoRegisterPageState();
}

class _NgoRegisterPageState extends State<NgoRegisterPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ngoNameController = TextEditingController();
  final TextEditingController _ngoEmailController = TextEditingController();
  final TextEditingController _ngoContactController = TextEditingController();
  final TextEditingController _darpanIdController = TextEditingController();
  final TextEditingController _registrationNoController =
      TextEditingController();

  List<Map<String, TextEditingController>> officeBearers = [];

  @override
  void initState() {
    super.initState();
    _addOfficeBearer();
  }

  void _addOfficeBearer() {
    setState(() {
      officeBearers.add({
        'name': TextEditingController(),
        'phone': TextEditingController(),
        'email': TextEditingController(),
        'designation': TextEditingController(),
      });
    });
  }

  void _removeOfficeBearer(int index) {
    setState(() {
      officeBearers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _ngoNameController.dispose();
    _ngoEmailController.dispose();
    _ngoContactController.dispose();
    _darpanIdController.dispose();
    _registrationNoController.dispose();
    for (var bearer in officeBearers) {
      bearer.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Registration Submitted!',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Your form has been submitted successfully.\n'
              'You will receive a confirmation email shortly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // go back to login
              },
              child: const Text('Go to Login',
                  style: TextStyle(color: Color.fromRGBO(52, 168, 83, 1))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                height: 150,
                color: const Color.fromRGBO(52, 168, 83, 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 7),
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 5),
                    const Flexible(
                      child: Text(
                        'NGO Registration Form',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.inter,
                          fontSize: 22,
                          fontWeight: AppFonts.interSemiBoldWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        color: Colors.green.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline,
                                  color: Color.fromRGBO(52, 168, 83, 1)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Welcome to the Sustainify NGO Registration Portal.\n\n"
                                  "All fields are mandatory. After successful verification, "
                                  "you will receive a confirmation email with your login credentials.\n\n"
                                  "Thank you for joining hands with us!",
                                  style: TextStyle(
                                    fontFamily: AppFonts.inter,
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          type: StepperType.vertical,
                          currentStep: _currentStep,
                          onStepContinue: () {
                            if (_currentStep < 2) {
                              setState(() {
                                _currentStep += 1;
                              });
                            } else {
                              _showConfirmationDialog();
                            }
                          },
                          onStepCancel: () {
                            if (_currentStep > 0) {
                              setState(() {
                                _currentStep -= 1;
                              });
                            }
                          },
                          controlsBuilder: (context, details) {
                            return Row(
                              children: [
                                ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(52, 168, 83, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                      _currentStep == 2 ? 'Submit' : 'Next'),
                                ),
                                const SizedBox(width: 8),
                                if (_currentStep != 0)
                                  TextButton(
                                    onPressed: details.onStepCancel,
                                    child: const Text('Back',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                              ],
                            );
                          },
                          steps: [
                            Step(
                              title: const Text('NGO Information'),
                              isActive: _currentStep >= 0,
                              state: _currentStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Column(
                                children: [
                                  _buildTextField(
                                      controller: _ngoNameController,
                                      label: 'NGO Name'),
                                  _buildTextField(
                                      controller: _ngoEmailController,
                                      label: 'NGO Email ID',
                                      keyboardType: TextInputType.emailAddress),
                                  _buildTextField(
                                      controller: _ngoContactController,
                                      label: 'NGO Contact Number',
                                      keyboardType: TextInputType.phone),
                                  _buildTextField(
                                      controller: _darpanIdController,
                                      label: 'Darpan ID'),
                                  _buildTextField(
                                      controller: _registrationNoController,
                                      label: 'Registration Number'),
                                ],
                              ),
                            ),
                            Step(
                              title: const Text('Office Bearers'),
                              isActive: _currentStep >= 1,
                              state: _currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Column(
                                children: [
                                  ...officeBearers.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var bearer = entry.value;
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Bearer ${index + 1}',
                                                  style: const TextStyle(
                                                    fontFamily: AppFonts.inter,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        52, 168, 83, 1),
                                                  ),
                                                ),
                                                if (officeBearers.length > 1)
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      _removeOfficeBearer(
                                                          index);
                                                    },
                                                  ),
                                              ],
                                            ),
                                            _buildTextField(
                                                controller: bearer['name']!,
                                                label: 'Name'),
                                            _buildTextField(
                                                controller: bearer['phone']!,
                                                label: 'Phone Number',
                                                keyboardType:
                                                    TextInputType.phone),
                                            _buildTextField(
                                                controller: bearer['email']!,
                                                label: 'Email ID',
                                                keyboardType:
                                                    TextInputType.emailAddress),
                                            _buildTextField(
                                                controller:
                                                    bearer['designation']!,
                                                label: 'Designation'),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: _addOfficeBearer,
                                      icon: const Icon(Icons.add_circle_outline,
                                          color:
                                              Color.fromRGBO(52, 168, 83, 1)),
                                      label: const Text(
                                        'Add Office Bearer',
                                        style: TextStyle(
                                          fontFamily: AppFonts.inter,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(52, 168, 83, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              title: const Text('Review & Submit'),
                              isActive: _currentStep >= 2,
                              state: StepState.indexed,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildReviewTile(
                                      'NGO Name', _ngoNameController.text),
                                  _buildReviewTile(
                                      'NGO Email', _ngoEmailController.text),
                                  _buildReviewTile('Contact Number',
                                      _ngoContactController.text),
                                  _buildReviewTile(
                                      'Darpan ID', _darpanIdController.text),
                                  _buildReviewTile('Registration Number',
                                      _registrationNoController.text),
                                  const SizedBox(height: 16),
                                  const Text('Office Bearers:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  ...officeBearers.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var bearer = entry.value;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Bearer ${index + 1}:',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        _buildReviewTile(
                                            'Name', bearer['name']!.text),
                                        _buildReviewTile(
                                            'Phone', bearer['phone']!.text),
                                        _buildReviewTile(
                                            'Email', bearer['email']!.text),
                                        _buildReviewTile('Designation',
                                            bearer['designation']!.text),
                                        const SizedBox(height: 10),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          // hintStyle: TextStyle(color: Color.fromRGBO(128, 137, 129, 0.354)),

          filled: true,
          fillColor: Color.fromRGBO(220, 237, 222, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
