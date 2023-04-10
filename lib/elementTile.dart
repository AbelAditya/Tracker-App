import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:telephony/telephony.dart';
import 'package:map_launcher/map_launcher.dart';

class ElementTile extends StatefulWidget {
  final String name;
  final List<Widget> list;
  final String id;
  final Function removeItem;
  final String phNo;
  final String img;

  ElementTile(
      {required this.name,
      required this.list,
      required this.id,
      required this.removeItem,
      required this.phNo,
      required this.img});

  @override
  State<ElementTile> createState() => _ElementTileState();
}

class _ElementTileState extends State<ElementTile> {
  final Telephony telephony = Telephony.instance;
  double lat = 0.0;
  double lon = 0.0;

  String coord = "";

  void Listen() async {
    await SmsAutoFill().listenForCode();
  }

  void initState() {
    super.initState();
    Listen();
  }

  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _sendSMS();
        print("Message Sent");
        // Listen();
        await Future.delayed(Duration(seconds: 17),()=>{print("delay")});

        num lat = double.parse("1."+coord.substring(0,3));
        num lon = double.parse("1."+coord.substring(3));

        lat = pow(10.0, lat);
        lon = pow(10.0, lon);

        print(lat);
        print(lon);

        if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
            MapLauncher.showDirections(mapType: MapType.google,
                destination: Coords(double.parse(lat.toString()), double.parse(lon.toString())));
          }

        // int x = DateTime.now().millisecondsSinceEpoch;
        // String coord = '';

        // if(coord==''){
        //   print("Error");
        // }
        // else{
        //   // if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
        //   //   MapLauncher.showDirections(mapType: MapType.google,
        //   //       destination: Coords(12.840971, 80.153491));
        //   // }
        //   print(coord);
        // }

        //lat = 12.840971  long=80.153491
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Remove Tracker"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          widget.removeItem(widget.id);
                        },
                        child: Text("Yes")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Stack(
          children: <Widget>[PinFieldAutoFill(
            currentCode: coord,
            codeLength: 6,
            onCodeChanged: (val){
              coord = val!;
            },
          ),Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(widget.img),
                    radius: MediaQuery.of(context).size.height * 0.05,
                    backgroundColor: Colors.cyan,
                  ),
                ),
                Text(
                  "${this.widget.name.toUpperCase()}",
                  style: TextStyle(fontSize: 30.0),
                ),
                SizedBox(width: 25.0),
              ],
            ),
          ),

          ]
        ),
      ),
    );
  }

  _sendSMS() async {
    telephony.sendSms(to: widget.phNo, message: "Hi");
  }

  Future<String> _readSMS() async {
    List<SmsMessage> _msgs = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.phNo));

    return _msgs[0].body ?? "";

    // try{
    //   int x = _msgs[0].date??0;
    //
    //   if(x>time){
    //     return _msgs[0].body??"";
    //   }
    //
    //
    //   return "";
    // }catch(e){
    //   print(e);
    //   return "";
    // }
  }

  void _readSms1() {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage msg) {
          print(msg.body.toString());
          print("asdf");
        },
        listenInBackground: false);
  }
}
