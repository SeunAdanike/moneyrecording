import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../UIs/first__screen.dart';

class AdcodePassword extends StatelessWidget {
  var _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: 80,
                child: TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  maxLength: 12,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  controller: _passController,
                  style: GoogleFonts.ubuntu(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(),
                    ),
                    hintText: 'Enter Passcode',
                    hintStyle: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter PassCode';
                    }
                  },
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.green,
                onPrimary: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (_passController.text == '1313') {
                    Navigator.popAndPushNamed(context, '/FirstScreen');
                  }
                }
              },
              child: Text(
                'Submit',
                style: GoogleFonts.ubuntu(
                  fontSize: 19,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
