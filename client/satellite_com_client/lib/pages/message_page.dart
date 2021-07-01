import 'package:flutter/material.dart';
import 'package:satellite_com_client/services/bluetooth_service.dart';
import 'package:satellite_com_client/utils/icons.dart';
import 'package:satellite_com_client/widgets/choice.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var binaryArray = [0, 0, 0, 0]; // array with choices
  bool isBtConnected = false;

  @override
  void initState() {
    super.initState();
  }

  void onSwitchChange(bool newValue, int arrayIndex) {
    binaryArray[arrayIndex] = newValue == true ? 1 : 0;
    print(binaryArray);
  }

  void onSendPress() async {
    print('message sent!');
    BtService.sendBytesMessage(binaryArray);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;
    final verticalSizedBox = SizedBox(
      height: _height * 0.025,
    );

    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final sendButton = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => onSendPress(),
        child: Text(
          "Send details",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: _width * 0.9,
            child: Column(
              children: [
                verticalSizedBox,
                ChoiceWidget(
                  choice1: 'Political crisis',
                  choice2: 'Natural disaster',
                  icon1: AppIcons.protestIcon,
                  icon2: AppIcons.disasterIcon,
                  onChange: (newValue) => onSwitchChange(newValue, 0),
                  description:
                      'Select the type of situation you are experiencing:',
                ),
                verticalSizedBox,
                ChoiceWidget(
                  choice1: 'No network coverage',
                  choice2: 'Network coverage',
                  icon1: AppIcons.nosignalIcon,
                  icon2: AppIcons.signalIcon,
                  onChange: (newValue) => onSwitchChange(newValue, 1),
                  description: 'Select whether network coverage is available:',
                ),
                verticalSizedBox,
                verticalSizedBox,
                sendButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
