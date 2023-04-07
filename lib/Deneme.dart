// import 'package:curved_drawer_fork/curved_drawer_fork.dart';
// import 'package:flutter/material.dart';
//
// class Playground extends StatefulWidget {
//   Playground({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _PlaygroundState createState() => _PlaygroundState();
// }
//
// class _PlaygroundState extends State<Playground> {
//   int index = 0;
//   double leftWidth = 75.0;
//   int leftTextColor = 1;
//   int leftBackgroundColor = 0;
//   double rightWidth = 75.0;
//   int rightTextColor = 1;
//   int rightBackgroundColor = 0;
//   final List<Color> colorPallete = <Color>[
//     Colors.white,
//     Colors.black,
//     Colors.blue,
//     Colors.blueAccent,
//     Colors.red,
//     Colors.redAccent,
//     Colors.teal,
//     Colors.orange,
//     Colors.pink,
//     Colors.purple,
//     Colors.lime,
//     Colors.green
//   ];
//   List<DrawerItem> _drawerItems = <DrawerItem>[
//     DrawerItem(icon: Icon(Icons.people), label: "People"),
//     DrawerItem(icon: Icon(Icons.trending_up,), label: "Trending",),
//     DrawerItem(icon: Icon(Icons.tv)),
//     DrawerItem(icon: Icon(Icons.work), label: "Work"),
//     DrawerItem(icon: Icon(Icons.web)),
//     DrawerItem(icon: Icon(Icons.videogame_asset)),
//     DrawerItem(icon: Icon(Icons.book), label: "Book"),
//     DrawerItem(icon: Icon(Icons.call), label: "Telephone")
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       drawer: CurvedDrawer(
//         index: index,
//         width: leftWidth,
//         color: colorPallete[leftBackgroundColor],
//         buttonBackgroundColor: colorPallete[leftBackgroundColor],
//         labelColor: colorPallete[leftTextColor],
//         items: _drawerItems,
//         onTap: (newIndex) {
//           setState(() {
//             index = newIndex;
//           });
//         },
//       ),
//       // endDrawer: CurvedDrawer(
//       //   index: index,
//       //   width: rightWidth,
//       //   color: colorPallete[rightBackgroundColor],
//       //   buttonBackgroundColor: colorPallete[rightBackgroundColor],
//       //   labelColor: colorPallete[rightTextColor],
//       //   isEndDrawer: true,
//       //   items: _drawerItems,
//       //   onTap: (newIndex) {
//       //     setState(() {
//       //       index = newIndex;
//       //     });
//       //   },
//       // ),
//       body: Center(
//         child:  Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//         Text(
//         'Current index is $index',
//         ),
//
//     ]),));
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:kariyer_hedefim/Screens/GirisEkran%C4%B1.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Drawer Example'),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Container(),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/flutter_logo.png',
                  ),
                ),
                ListTile(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>GirisEkrani()));},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.favorite),
                  title: Text('Favourites'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}