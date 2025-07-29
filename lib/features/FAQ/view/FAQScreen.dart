import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/AppHeader/AppHeader.dart';

class Faqscreen extends StatefulWidget {
  const Faqscreen({super.key});

  @override
  State<Faqscreen> createState() => _FaqscreenState();
}

class _FaqscreenState extends State<Faqscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        screenTitle: "FAQ Screen",
        username: "Rajeev Ranjan",
        userId: "394884",
        showBack: true,
      ),
    );
  }
}
