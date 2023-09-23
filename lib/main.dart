import 'package:flutter/material.dart';

void main() => runApp(const InterestCalcApp());

class InterestCalcApp extends StatelessWidget {
  const InterestCalcApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        hintColor: Colors.deepPurpleAccent,
      ),
      title: 'Interest Calculator',
      home: const InterestCalcHome(),
    );
  }
}

class InterestCalcHome extends StatefulWidget {
  const InterestCalcHome();

  @override
  State<StatefulWidget> createState() => InterestCalcHomeState();
}

class InterestCalcHomeState extends State<InterestCalcHome> {
  final _formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(12.0);
  var btnPrimary = Colors.deepPurple;
  var btnSecondary = Colors.redAccent;
  final principalController = TextEditingController();
  final interestController = TextEditingController();
  final periodController = TextEditingController();
  var displayResult = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest Calculator'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(height: 30.0),
            getAppIcon(),
            getAmountField(
              'Enter amount e.g. 1200',
              'Amount',
              Icons.monetization_on,
              principalController,
              _padding,
              TextInputType.numberWithOptions(decimal: true), // Accept decimal values
            ),
            getAmountField(
              'Enter interest e.g 2',
              'Monthly rate of Interest',
              Icons.payment,
              interestController,
              _padding,
              TextInputType.numberWithOptions(decimal: true), // Accept decimal values
            ),
            Padding(
              padding: _padding,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: getAmountField(
                      'Number of months',
                      'Duration',
                      Icons.timer,
                      periodController,
                      EdgeInsets.all(0),
                      TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: _padding,
              child: Row(
                children: <Widget>[
                  getCalcButton('Calculate', btnPrimary, calculate),
                  const SizedBox(width: 10.0),
                  getCalcButton('Reset', btnSecondary, reset),
                ],
              ),
            ),
            Padding(
              padding: _padding,
              child: Center(
                child: Text(
                  displayResult,
                  style: textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppIcon() {
    return Center(
      child: Image.asset(
        'assets/images/bank.png',
        width: 80,
      ),
    );
  }

  Widget getAmountField(String hintText, String labelText, IconData iconOfField,
      TextEditingController textController, EdgeInsets wrapping,
      TextInputType keyboardType) {
    return Padding(
      padding: wrapping,
      child: TextFormField(
        validator: (String? input) {
          if (input == null || input.isEmpty) {
            return 'Invalid Input. Please Check';
          }
          return null;
        },
        controller: textController,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 15.0,
          ),
          prefixIcon: Icon(iconOfField),
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget getCalcButton(
      String buttonName, Color buttonColor, Function buttonFunc) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        onPressed: () => setState(
              () {
            if (_formKey.currentState?.validate() ?? true) {
              displayResult = buttonFunc();
            }
          },
        ),
        child: Text(
          buttonName,
        ),
      ),
    );
  }

  String calculate() {
    var principal = double.tryParse(principalController.text) ?? 0.0;
    var interest = double.tryParse(interestController.text) ?? 0.0;
    var period = double.tryParse(periodController.text) ?? 0.0;
    var interestAmount = (principal * interest * period) / 100.0;
    var totalAmount = principal + interestAmount;
    return 'For $period months\nInterest amount is ${interestAmount.toStringAsFixed(2)}\nTotal Payable Amount is ${totalAmount.toStringAsFixed(2)}';
  }

  String reset() {
    principalController.text = '';
    interestController.text = '';
    periodController.text = '';
    displayResult = '';
    return '';
  }
}
