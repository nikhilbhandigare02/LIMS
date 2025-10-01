import 'package:flutter/material.dart';

// Global notifier to switch app locale at runtime without extra deps
final ValueNotifier<Locale?> appLocale = ValueNotifier<Locale?>(null);
