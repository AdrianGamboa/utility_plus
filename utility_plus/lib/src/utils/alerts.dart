import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String header, String message) {  
  // Create button  
  Widget okButton = TextButton(  
    style: TextButton.styleFrom(
      primary: const Color(0xffAD53AE)),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
    child: const Text("OK"),  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text(header),  
    content: Text(message),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  