import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'elementTile.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String appSig = "";

  void removeItem(String ID){
    Navigator.pop(context);
    setState(() {
      l.removeWhere((ele) => ele.id==ID);
    });
  }

  void AppSig()async{
    appSig = await SmsAutoFill().getAppSignature;
    print(appSig);
  }

  void initState(){
    AppSig();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  int i=0;
  List<ElementTile> l = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5900B3),
        title: Center(
          child: Text("TRACKERS"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: l,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Create New"),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter something";
                          } else if (value.length > 13) {
                            return "please enter less that 13 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter name (max 13 chracters)",
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6.0))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _numController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter something";
                          }
                          return null;
                          },
                        decoration: InputDecoration(
                          hintText: "Enter Serial Number",
                          labelText: "Serial Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6.0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Color(0xFF5900B3))),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      l.add(ElementTile(name: _nameController.text,list: l,id: DateTime.now().toString(),removeItem: removeItem,phNo: _numController.text,img: "images/${i%4}.jpeg",));
                    });
                    i++;
                  },
                  child: Text("Submit"),
                )

              ],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF5900B3),
      ),
    );
  }
}
