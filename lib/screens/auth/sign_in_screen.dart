import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
   const SignInScreen({ Key? key }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('Emed'),
       elevation: 0,
     ),
     endDrawer: Drawer(
       backgroundColor: AppColors.white,
       child: ListView(
         children: [
            DrawerHeader(
             curve: Curves.easeIn,
             child: IconButton(
               alignment: Alignment.topRight,
               onPressed: (){Navigator.pop(context);}, 
               icon: Icon(Icons.close),
               ),
               margin: EdgeInsets.all(0),
            ),
           ListTile(
              trailing: Icon(Icons.more_vert),
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: Icon(Icons.more_vert),
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: Icon(Icons.more_vert),
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
         ],
       ),
     ),
     body: Column(
           children: [
             Container(
               height: 200,
               decoration: new BoxDecoration(
               color: AppColors.primary,
                ) ,
               child: Column(
                 children: [
                   Row(
                     children: [
                       Text('We care\nabout your\nhealth',
                              style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              ),)
                     ],
                   ),
                   Text('eMed is your Assistent in lorem ipsum dolor sit amet, consectetur adipiscing elit. Ullamcorper leo, est, nibh rhoncus, id diam ultrices enim.'),
                 ],
               ),
             ),
           ],
           ),
    );
  }
}