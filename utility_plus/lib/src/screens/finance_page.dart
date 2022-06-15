import 'package:flutter/material.dart';
class FinancePage extends StatefulWidget {
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
class _FinancePageState extends State<FinancePage> {
  int montoTotal=1000000;
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("UNA"),value: "UNA"),
    DropdownMenuItem(child: Text("Total"),value: "TOTAL"),
    
  ];
  return menuItems;
  }
  String selectedValue = "UNA";
  @override
  Widget build(BuildContext context) {
   
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(

          preferredSize: const Size.fromHeight(160.0),
          child: AppBar(
            
            flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on,size: 40.0),
                        Text('  Total  ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
                        //Hacer dropdown
                       DropdownButton(
                      value: selectedValue,
                      
                        items: dropdownItems, 
                        onChanged: (String? value) {
                          selectedValue = value!;
                         },
                      ),
                       
                      
                      ],
                    ),
                    
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14.0),
                      child: Text(' $montoTotal' + ' ₡', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700))
                    ),
                     SizedBox(height: 30,)       
                ],
              ),
            bottom: const TabBar(
                indicatorColor: Color(0xffAD53AE),
                unselectedLabelColor: Color(0xff707070),
                tabs: [
                  Tab(
                    child: Text(
                      'Gastos',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Ingresos',
                    ),
                  ),
                ],
              ),
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
            
          ),
          SingleChildScrollView(
            
            child: Column(
              
            ),
          ),
        ]),
        persistentFooterButtons: <Widget>[
        RaisedButton(
          
          onPressed: () {
            Navigator.of(context).pushNamed('/accounts');
          },
         
          child: Text("Cuentas"),
        ),
        RaisedButton(
          onPressed: () {
           
          },
          
          child: Text("Transferencias"),
        ),
      ],
      
floatingActionButton: Container(
          height: 50,
          width: 50,
          child: FloatingActionButton(
            
            onPressed: () {
              print("click floating");
            },
            child: Text(
              "+",
              style: TextStyle(fontSize: 20),
            ),
          ),
        )
      ),
    );
  }
}


