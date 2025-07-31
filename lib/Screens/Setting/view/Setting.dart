import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../config/Routes/RouteName.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';
import '../../update_password/view/UpdatePassword.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppHeader(
        screenTitle: "Setting",
        username: "Rajeev Ranjan",
        userId: "394884",
        showBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          _buildListTile(
            icon: Icons.person_outline,
            title: 'My Profile',
            onTap: () {
              Navigator.pushNamed(context, RouteName.profileScreen);
            },
          ),
          Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),
          _buildListTile(
            icon: Icons.lock_outline,
            title: 'Update Password',
            onTap: () {
              Navigator.pushNamed(context, RouteName. updateScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF1E88E5)),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.grey[100],
      ),
    );
  }
}