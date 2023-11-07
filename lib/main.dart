import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project/home_page.dart';

void main() {
  Stripe.publishableKey = "pk_test_51O9jpASHqzou42kH2waZWKp1W0ZxnEtUVITGh2KHUyecaTlaSTw2FviezxPkqvGxUuqVDpRMQxbLZPFJbd7FoOl400cIsQTJ7z";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyGooglePay(),
    );
  }
}
