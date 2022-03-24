import 'package:emedassistantmobile/config/app_colors.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
   const SignInScreen({ Key? key }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  String _email = '';
  int _phone_number = 0;

  final _formKey = GlobalKey<FormState>();

  Widget _buildEmailField () {
    return TextField(
      decoration: const InputDecoration(
        labelText: "Email"
      ),
    );
  }


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
              leading: Icon(Icons.more_vert),
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.more_vert),
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.more_vert),
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
             Row(
               children: [
                 Container(
                   height: 200,
                   padding: const EdgeInsets.all(10.0),
                   decoration: new BoxDecoration(
                   color: AppColors.lightBackground,
                    ) ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Welcome to eMed Assistant',
                        style: TextStyle(
                          color: AppColors.lightBlack,
                          fontSize: 15
                        ),),
                        Text('Sign In',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),),
                        Form(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                            
                           ],
                        ))
                      ],
                    ),
                 ),
               ],
             )
           ],
           ),
    );
  }
}