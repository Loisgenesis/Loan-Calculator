import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loan/my_colors.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Loan Calculator',
    home: LoanApp(),
  ));
}

class LoanApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoanAppState();
  }
}

class _LoanAppState extends State<LoanApp> {
  final double padding = 10.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autoValidate = false;
  double principal;
  double interest;
  double months;
  TextEditingController principalEditingController =
      new TextEditingController();
  TextEditingController interestEditingController = new TextEditingController();
  TextEditingController monthsEditingController = new TextEditingController();
  double monthlyResult = 0;
  double totalResult = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Loan Calculator'),
          backgroundColor: MyColors.colorPrimary,
        ),
        body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(padding * 2),
              child: Column(
                children: <Widget>[
                  getImageAsset(),
                  TextFormField(
                    controller: principalEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Principal amount',
                      hintText: 'Enter Principal amount e.g. 500000',
                    ),
                    validator: _validateValue,
                    onSaved: (value) {
                      principal = double.parse(value);
                    },
                  ),
                  SizedBox(
                    height: padding,
                  ),
                  TextFormField(
                    controller: interestEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Rate of Interest',
                      hintText: 'In percentage e.g 10',
                    ),
                    validator: _validateValue,
                    onSaved: (value) {
                      interest = double.parse(value);
                    },
                  ),
                  SizedBox(
                    height: padding,
                  ),
                  TextFormField(
                    controller: monthsEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Term in months',
                      hintText: 'e.g 2',
                    ),
                    validator: _validateValue,
                    onSaved: (value) {
                      months = double.parse(value);
                    },
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text('Calculate'),
                          onPressed: _handleSubmitted,
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text('Reset'),
                          onPressed: resetValues,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Text(
                        'Monthly payment of : ${monthlyResult.floorToDouble()}'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child:
                        Text('Total payment : ${totalResult.floorToDouble()}'),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('assets/images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
      color: MyColors.colorPrimary,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(padding * 2),
    );
  }

  String _validateValue(String value) {
    if (value == null || value.isEmpty) return "This field is required";
    return null;
  }

  void showInSnackBar(String value) {
    Flushbar(
      message: value,
      backgroundColor: Colors.red,
      borderRadius: 10,
      margin: EdgeInsets.all(20),
      duration: Duration(seconds: 3),
    )..show(context);
//    _scaffoldKey.currentState
//        .showSnackBar(new SnackBar(content: new Text(value),backgroundColor: MyColors.redBg,));
  }

  resetValues() {
    principalEditingController.text = "";
    interestEditingController.text = "";
    monthsEditingController.text = "";
    setState(() {
      monthlyResult = 0;
      totalResult = 0;
    });
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar("This field is required");
      return;
    } else
      form.save();
    calculateValues();
  }

  calculateValues() {
    double oldInterest = principal * interest;
    double newInterest = oldInterest / 100;
    double monthlyPayment = newInterest * months;
    setState(() {
      totalResult = principal + monthlyPayment;
      monthlyResult = totalResult / months;
    });
  }
}
