import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'navigation.dart';
import 'choose_shifts_page.dart';
import 'my_account_page.dart';
import 'my_shifts_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Navigation bar
  int _navigationBarIndex = 0;
  void _onNavigationBarIndexSelect(int index) {
    setState(() {
      _navigationBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> _titles = ['Meine Schichten', 'Mein Account'];
    List<Widget> _pages = [MyShiftsPage(), MyAccountPage()];
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
              _titles.elementAt(_navigationBarIndex),
              style: TextStyle(color: Colors.black)
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("logo_small.png"),
          )
      ),
      body: Row(
        children: [
          // Show side navigation if layout > small
          if (context.layout.breakpoint > LayoutBreakpoint.xs) ...[
            NavigationSideBar(
                selectedIndex: _navigationBarIndex,
                onIndexSelect: _onNavigationBarIndexSelect
            ),
            VerticalDivider(thickness: 1, width: 1),
          ],
          Expanded(
              key: ValueKey('HomePageBody'),
              child: _pages.elementAt(_navigationBarIndex)),
        ],
      ),
      // Show bottom navigation if layout < medium
      bottomNavigationBar: context.layout.breakpoint < LayoutBreakpoint.sm
          ? NavigationBottomBar(
            selectedIndex: _navigationBarIndex,
            onIndexSelect: _onNavigationBarIndexSelect
          )
          : null,
      floatingActionButton: _navigationBarIndex == 0
          ? FloatingActionButton.extended(
            //tooltip: 'Neue Schicht auswählen',
            label: const Text('Schicht anmelden'),
            icon: Icon(Icons.playlist_add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChooseShiftsPage())
              ).then((value) => setState(() {}));
            }
          )
          : null,
    );
  }
}
