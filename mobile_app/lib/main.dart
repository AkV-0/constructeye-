import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/SiteProvider.dart';
import 'screens/LandingPage.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => SiteProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LandingPage());
  }
}
