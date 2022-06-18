import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String header, String message, int n) {  
  // Create button  
  Widget okButton = TextButton(  
    style: TextButton.styleFrom(
      primary: const Color(0xffAD53AE)),  
    onPressed: () {  
      
      if(n==1){
      Navigator.of(context).pop();
      } else if (n==2){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

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