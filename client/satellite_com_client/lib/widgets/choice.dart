import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:satellite_com_client/utils/icons.dart';

class ChoiceWidget extends StatefulWidget {
  final String choice1;
  final String choice2;
  final Function(bool switchState) onChange;
  final String icon1;
  final String icon2;
  final String description;

  ChoiceWidget(
      {Key key,
      this.choice1,
      this.choice2,
      this.onChange,
      this.icon1,
      this.icon2,
      this.description})
      : super(key: key);

  @override
  _ChoiceWidgetState createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  bool switchState = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _width = size.width;
    return Container(
      width: _width * 0.9,
      child: Card(
        color: Colors.white38,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _width * 0.3,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          widget.icon1,
                          width: 70,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.choice1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: switchState == false
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CupertinoSwitch(
                      value: switchState,
                      activeColor: Colors.blueAccent,
                      onChanged: (newState) {
                        setState(() {
                          switchState = newState;
                        });
                        widget.onChange(newState);
                      }),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: _width * 0.3,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          widget.icon2,
                          width: 70,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.choice2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: switchState == true
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
