import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/AppHeader/AppHeader.dart';

class SealRequestDetailsScreen extends StatefulWidget {
  const SealRequestDetailsScreen({super.key});

  @override
  State<SealRequestDetailsScreen> createState() => _SealRequestDetailsScreenState();
}

class _SealRequestDetailsScreenState extends State<SealRequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppHeader(
       screenTitle: 'seal number info',
       username: '',
       userId: '',
       showBack: true,
     ),
   );
  }
}
