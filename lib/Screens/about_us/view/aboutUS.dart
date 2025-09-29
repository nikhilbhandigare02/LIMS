import 'package:flutter/material.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        screenTitle: "About Us",

        showBack: false,
      ),
      drawer: CustomDrawer(),
      backgroundColor: const Color(0xFFFAFAFA),

      body: SingleChildScrollView(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Company Overview
                  _buildInfoCard(
                    icon: Icons.business_outlined,
                    title: "Who We Are",
                    description: "Alphonsol is a new-age 360-degree technology solution provider offering end-to-end services — from product conceptualization to maturity.",
                    color: const Color(0xFF1976D2),
                  ),

                  const SizedBox(height: 20),

                  // Experience Card
                  _buildInfoCard(
                    icon: Icons.timeline_outlined,
                    title: "Our Experience",
                    description: "With 15 years of experience, Alphonsol delivers embedded tech to Bioxia Solutions and changemakers across Healthcare, Insurance, and Banking.",
                    color: const Color(0xFF42A5F5),
                  ),

                  const SizedBox(height: 20),

                  // Vision Card
                  _buildInfoCard(
                    icon: Icons.lightbulb_outline,
                    title: "Our Vision",
                    description: "Future-ready Design Thinking with industry collaborations that matter.",
                    color: const Color(0xFF2196F3),
                  ),

                  const SizedBox(height: 40),

                  // Stats Row (Optional Enhancement)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("15+", "Years"),
                        _buildDivider(),
                        _buildStatItem("360°", "Solutions"),
                        _buildDivider(),
                        _buildStatItem("3", "Industries"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          //  color: Color(0xFF1976D2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[200],
    );
  }
}