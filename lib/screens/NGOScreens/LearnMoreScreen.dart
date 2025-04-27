import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class LearnMoreScreen extends StatelessWidget {
  const LearnMoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        _buildFaqSection(
                          title: "What is NGO Registration?",
                          answer:
                              "NGO Registration is the official process to make your organization recognized under government norms. The NGO needs to provide its name, registration number, and other relevant details.",
                          color: Colors.deepPurple.shade100,
                        ),
                        _buildFaqSection(
                          title: "What documents are required for submission?",
                          answer:
                              "You need to provide key documents including your NGO registration number, Darpan ID, contact details, and email address.",
                          color: Colors.amber.shade100,
                        ),
                        _buildFaqSection(
                          title:
                              "What information is required for office bearers?",
                          answer:
                              "You should provide the names, roles, and contact information of the office bearers responsible for managing your NGO.",
                          color: Colors.green.shade100,
                        ),
                        _buildFaqSection(
                          title: "What happens after submission?",
                          answer:
                              "Once your form is submitted, our team will verify your details. If approved, you will receive a confirmation email with login credentials.",
                          color: Colors.teal.shade100,
                        ),
                        _buildFaqSection(
                          title: "When will I receive my confirmation email?",
                          answer:
                              "Once your verification is successful, you'll receive a confirmation email that allows you to log in and manage your NGO’s activities.",
                          color: Colors.blue.shade100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(),
      child: Container(
        height: 150,
        color: const Color.fromRGBO(52, 168, 83, 1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 7),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 5),
            const Flexible(
              child: Text(
                'FAQs',
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
    );
  }

  Widget _buildFaqSection({
    required String title,
    required String answer,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use ExpansionTile for collapsible answer section
              ExpansionTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.inter,
                    color: Colors.black87,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      answer,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontFamily: AppFonts.inter,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
