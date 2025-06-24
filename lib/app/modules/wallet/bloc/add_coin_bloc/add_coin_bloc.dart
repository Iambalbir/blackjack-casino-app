import 'dart:convert';

import 'package:app/export_file.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class AddCoinBloc extends Bloc<AddCoinEvents, AddCoinState> {
  AddCoinBloc() : super(AddCoinState.initialState()) {
    on<MakePaymentEvent>(_makePayment);
  }

  Map<String, dynamic>? paymentIntent;

  Future<void> _makePayment(
      MakePaymentEvent event, Emitter<AddCoinState> emit) async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent =
          await createPaymentIntent(event.totalCosting.toString(), 'USD');

      debugPrint(
          'PaymentIntent (pretty): ${JsonEncoder.withIndent('  ').convert(paymentIntent)}');
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  billingDetailsCollectionConfiguration:
                      BillingDetailsCollectionConfiguration(
                    name: CollectionMode.always,
                    email: CollectionMode.always,
                    address: AddressCollectionMode.never,
                    attachDefaultsToPaymentMethod: true,
                  ),
                  billingDetails: BillingDetails(
                      name: currentUserModel.nickname,
                      email: currentUserModel.email,
                      phone: "1234",
                      address: Address(
                          city: 'abc',
                          country: 'US',
                          line1: 'abc',
                          line2: 'abc',
                          postalCode: '',
                          state: 'ABC')),
                  style: ThemeMode.dark,
                  customerId: currentUserModel.stripeCustomerId,
                  merchantDisplayName: currentUserModel.nickname))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(amount: event.totalCosting.toString());
    } catch (err, stat) {
      throw Exception(err);
    }
  }



  createPaymentIntent(String amount, String currency) async {
    print('sec key-------__${dotenv.env['STRIPE_SECRET']}');
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'customer': currentUserModel.stripeCustomerId,
        'description': 'Payment for buying coins',
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  String calculateAmount(String amount) {
    try {
      final double parsedAmount = double.parse(amount);
      final int calculatedAmount = (parsedAmount * 100).round();
      return calculatedAmount.toString();
    } catch (e) {
      print('Error: Unable to parse amount: $e');
      return '0'; // Return a default value or throw an exception
    }
  }

  Future<void> displayPaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        fetchPaymentDetails(paymentIntent!['id']);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        // Handle error from presenting the payment sheet
        handleStripeError(error);
        throw Exception(error);
      });
    } on StripeException catch (e) {
      // Handle Stripe-specific exceptions
      handleStripeError(e);
    } catch (e) {
      // Handle any other exceptions
      handleGeneralError(e);
    }
  }

  void handleStripeError(dynamic error) {
    // Implement your error handling logic here
    // For example, you could log the error or show a user-friendly message
    // Example: logError(error);
    throw Exception('Stripe error occurred: ${error.toString()}');
  }

  void handleGeneralError(dynamic error) {
    // Implement your general error handling logic here
    // Example: logError(error);
    throw Exception('An error occurred: ${error.toString()}');
  }

  Future<void> fetchPaymentDetails(String paymentIntentId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      if (response.statusCode == 200) {
        final paymentDetails = json.decode(response.body);
        String paymentMethodId = paymentDetails['payment_method'];

        // Fetch payment method details

        await fetchPaymentMethodDetails(paymentMethodId);

        debugPrint(
            'Payment Details: ${JsonEncoder.withIndent("  ").convert(paymentDetails)}');
      } else {
        debugPrint('Failed to fetch payment details: ${response.statusCode}');
      }
    } catch (err) {
      debugPrint('Error fetching payment details: $err');
    }
  }

  Future<void> fetchPaymentMethodDetails(String paymentMethodId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_methods/$paymentMethodId'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );

      if (response.statusCode == 200) {
        final paymentMethodDetails = json.decode(response.body);

        print(
            'Payment Method Details: ${JsonEncoder.withIndent("  ").convert(paymentMethodDetails)}');

        // You can now access details like:

        // String cardBrand = paymentMethodDetails['card']['brand'];

        // String last4 = paymentMethodDetails['card']['last4'];

        // Use these details as needed in your application
      } else {
        throw Exception(
            'Failed to fetch payment method details: ${response.statusCode}');
      }
    } catch (err) {
      handleGeneralError(err);
    }
  }
}
