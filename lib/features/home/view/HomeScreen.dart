import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/ExitCOnfirmtionWidget.dart';
import '../../../core/widgets/AppDrawer/Drawer.dart';
import '../../../core/widgets/AppHeader/AppHeader.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => ExitConfirmation.show(
        context,
        title: "Exit App",
        description: "Are you sure you want to exit the app?",
        confirmText: "Exit",
        cancelText: "Cancel",
        confirmIcon: Icons.exit_to_app,
        cancelIcon: Icons.cancel_outlined,
      ),
      child: Scaffold(
          drawer: const CustomDrawer(),
          appBar: AppHeader(
            screenTitle: "Home",
            username: "Rajeev Ranjan",
            userId: "394884",
            showBack: false,
          ),
          body: Center(child: Text('Home'))),
    );
  }
}
