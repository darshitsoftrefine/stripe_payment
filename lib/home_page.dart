import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class MyGooglePay extends StatefulWidget {
  const MyGooglePay({super.key});

  @override
  State<MyGooglePay> createState() => _MyGooglePayState();
}

class _MyGooglePayState extends State<MyGooglePay> {

 Map<String, dynamic>? paymentIntent;

 void makePayment() async{
   try{
     paymentIntent = await createPaymentIntent();
     var gpay = PaymentSheetGooglePay(merchantCountryCode: "US",
       currencyCode: "US",
       testEnv: true,
     );

     await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
       paymentIntentClientSecret: paymentIntent!["client_secret"],
       style: ThemeMode.dark,
       merchantDisplayName: "Darshit",
       googlePay: gpay,
     ));
     displayPaymentSheet();

   }catch(e){
     print("Failed");
   }
 }

 void displayPaymentSheet() async{
   try{
     await Stripe.instance.presentPaymentSheet();
     print("Done");
   } catch(e){
     print("Failed");
   }
 }

  createPaymentIntent() async{
   try{
     Map<String, dynamic> body = {
       "amount": "100",
       "currency": "USD",
     };

     http.Response response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
       body: body,
       headers: {
       "Authorization": "Bearer sk_test_51O9jpASHqzou42kHVw2MMWi3muGO7OYhmaV2J0IPkaupAwRCCBTuSZS0jmfcQoGb8fZjrLvBAURaeym4xUf9GZvU00CCsLy7yd",
         "Content-Type": "application/x-www-form-urlencoded",
       }
     );
     return json.decode(response.body);
   } catch(e){
     throw Exception(e.toString());
   }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stripe Payment"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          makePayment();
        }, child: Text("Stripe Pay")),
      ),
    );
  }
}

// var _paymentItems = [
//   PaymentItem(
//     label: 'Total',
//     amount: '99.99',
//     status: PaymentItemStatus.final_price,
//   )
// ];
// GooglePayButton(
// paymentConfigurationAsset: 'sample_payment_configuration.json',
// paymentItems: _paymentItems,
// type: GooglePayButtonType.pay,
// onPaymentResult: onGooglePayResult,
// ),