import 'package:flutter/material.dart';
import 'package:satellite_com_client/pages/connection_page.dart';
import 'package:satellite_com_client/pages/message_page.dart';

class DashboardPage extends StatefulWidget {
  final int index;

  const DashboardPage({Key key, this.index}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();

  static void setTab(BuildContext context, int index) async {
    var state = context.findAncestorStateOfType<_DashboardPageState>();
    state.onTabTapped(index);
  }
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 20,
        selectedLabelStyle: TextStyle(
          color: Colors.blueAccent,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.blueGrey,
        ),
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Connectivity',
            tooltip: 'Connectivity',
            activeIcon: Icon(
              Icons.sensors_outlined,
            ),
            icon: Icon(
              Icons.sensors_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Send message',
            tooltip: 'Send message',
            activeIcon: Icon(
              Icons.connect_without_contact_outlined,
            ),
            icon: Icon(
              Icons.connect_without_contact_outlined,
            ),
          ),
        ],
        onTap: (index) => onTabTapped(index),
        currentIndex: _currentIndex,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          ConnectionPage(),
          MessagePage(),
        ],
      ),
    );
  }
}
