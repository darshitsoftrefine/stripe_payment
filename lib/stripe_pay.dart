import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePay extends StatefulWidget {
  const StripePay({super.key});

  @override
  State<StripePay> createState() => _StripePayState();
}

class _StripePayState extends State<StripePay> {

 Map<String, dynamic>? paymentIntent;

 void    makePayment() async{
   try{
     paymentIntent = await createPaymentIntent();
     var gpay = const PaymentSheetGooglePay(merchantCountryCode: "US",
       currencyCode: "IND",
       testEnv: true,
     );

     // await Stripe.instance.initCustomerSheet(customerSheetInitParams:
     // const CustomerSheetInitParams(customerId: '123', customerEphemeralKeySecret: 'Hello',
     //   merchantDisplayName: "Darshit"
     //
     // ));
     await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
       paymentIntentClientSecret: paymentIntent?["client_secret"],
       style: ThemeMode.dark,
       merchantDisplayName: "Darshit",
       googlePay: gpay,
     ));
     displayPaymentSheet();

   }catch(e){
     debugPrint("Failed");
   }
 }

 void displayPaymentSheet() async{
   try{
     await Stripe.instance.presentPaymentSheet();
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: Center(child: Text("Payment Successful")),
       padding: EdgeInsets.all(10),
       backgroundColor: Colors.green,));
     debugPrint("Done");
   } catch(e){
     debugPrint("Failed");
   }
 }

  createPaymentIntent() async{
   try{
     Map<String, dynamic> body = {
       "amount": "10000",
       "currency": "INR",
     };

     http.Response response = await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
       body: body,
       headers: {
       "Authorization": "Bearer sk_test_51O9jpASHqzou42kHVw2MMWi3muGO7OYhmaV2J0IPkaupAwRCCBTuSZS0jmfcQoGb8fZjrLvBAURaeym4xUf9GZvU00CCsLy7yd",
         "Content-Type": "application/x-www-form-urlencoded",
       }
     );
     debugPrint(response.body);
     return json.decode(response.body);
   } catch(e){
     throw Exception(e.toString());
   }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Payment"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          makePayment();
        }, child: const Text("Stripe Pay")),
      ),
    );
  }
}