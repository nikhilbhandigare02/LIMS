import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2196F3)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Color(0xFF2196F3),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         // Logo Section
      //         Center(
      //           child: Container(
      //             padding: const EdgeInsets.all(20),
      //             decoration: BoxDecoration(
      //               color: const Color(0xFF2196F3),
      //               borderRadius: BorderRadius.circular(16),
      //             ),
      //             child: Image.asset(
      //               'assets/Logo-White.png',
      //               height: 80,
      //               fit: BoxFit.contain,
      //             ),
      //           ),
      //         ),
      //
      //         const SizedBox(height: 32),
      //
      //         // Main Headline
      //         const Text(
      //           'Empowering Businesses with 360° Tech Solutions',
      //           style: TextStyle(
      //             color: Color(0xFF1565C0),
      //             fontSize: 28,
      //             fontWeight: FontWeight.bold,
      //             height: 1.3,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //
      //         const SizedBox(height: 24),
      //
      //         // Description
      //         const Text(
      //           'Alphonsol is a new-age 360-degree technology solution provider offering end-to-end services — from product conceptualization to maturity. With 15 years of experience, Alphonsol delivers embedded tech to Bioxia Solutions and changemakers across Healthcare, Insurance, and Banking.',
      //           style: TextStyle(
      //             color: Color(0xFF616161),
      //             fontSize: 16,
      //             height: 1.6,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //
      //         const SizedBox(height: 40),
      //
      //         // Services Section
      //         _buildServiceCard(
      //           'Solution Expert',
      //           'Boost growth and customer experience with tailored tech solutions.',
      //           [
      //             'Tech automation',
      //             'Infra setup',
      //             'Custom workflows',
      //             'Enterprise tools'
      //           ],
      //           const Color(0xFF1976D2),
      //         ),
      //
      //         const SizedBox(height: 24),
      //
      //         _buildServiceCard(
      //           'Web Development',
      //           'Fast, responsive sites with UX-first designs and modern tech.',
      //           [
      //             'E-commerce & WordPress',
      //             'UI/UX design'
      //           ],
      //           const Color(0xFF2196F3),
      //         ),
      //
      //         const SizedBox(height: 24),
      //
      //         _buildServiceCard(
      //           'Mobile App Development',
      //           'Apps that are intuitive, high-performance, and built to scale.',
      //           [
      //             'iOS & Android',
      //             'Hybrid apps',
      //             'Modern UI/UX',
      //             'Smooth experience'
      //           ],
      //           const Color(0xFF42A5F5),
      //         ),
      //
      //         const SizedBox(height: 40),
      //
      //         // Bottom Section
      //         Container(
      //           padding: const EdgeInsets.all(24),
      //           decoration: BoxDecoration(
      //             color: const Color(0xFFF5F5F5),
      //             borderRadius: BorderRadius.circular(16),
      //             border: Border.all(color: const Color(0xFFE0E0E0)),
      //           ),
      //           child: Column(
      //             children: [
      //               const Text(
      //                 'Future-ready design thinking',
      //                 style: TextStyle(
      //                   color: Color(0xFF1565C0),
      //                   fontSize: 20,
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(height: 16),
      //               const Text(
      //                 'Industry collaborations that matter',
      //                 style: TextStyle(
      //                   color: Color(0xFF616161),
      //                   fontSize: 16,
      //                 ),
      //                 textAlign: TextAlign.center,
      //               ),
      //               const SizedBox(height: 24),
      //               Container(
      //                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      //                 decoration: BoxDecoration(
      //                   gradient: const LinearGradient(
      //                     colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
      //                   ),
      //                   borderRadius: BorderRadius.circular(25),
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: const Color(0xFF2196F3).withOpacity(0.3),
      //                       blurRadius: 8,
      //                       offset: const Offset(0, 4),
      //                     ),
      //                   ],
      //                 ),
      //                 child: const Text(
      //                   '15+ Years of Experience',
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //         const SizedBox(height: 24),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildServiceCard(String title, String description, List<String> features, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: features.map((feature) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Text(
                feature,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}