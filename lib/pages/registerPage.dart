import 'package:actwithy/services/authService.dart';
import 'package:flutter/material.dart';

import 'loginPage.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                children: [
                  Form(
                    key: _myKey,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          //width: MediaQuery.of(context).size.width*0.8,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/register.png",
                                ),
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: TextFormField(
                            cursorColor: Color(0xffD6E6F1),
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Name.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding: EdgeInsets.fromLTRB(10, 30, 10,
                                    0), // control your hints text size
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                hintText: 'name',
                                label: Text(
                                  'Your Name',
                                  style: TextStyle(
                                    color: Color(0xff4C6170),
                                    fontSize: 20,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: TextFormField(
                            cursorColor: Color(0xffD6E6F1),
                            controller: surnameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Surname.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 10, 0),
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                hintText: 'surname',
                                label: Text(
                                  'Your Surname',
                                  style: TextStyle(
                                    color: Color(0xff4C6170),
                                    fontSize: 20,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: TextFormField(
                            cursorColor: Color(0xffD6E6F1),
                            controller: usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Username.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 10, 0),
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                hintText: 'username',
                                label: Text(
                                  'Your Username',
                                  style: TextStyle(
                                    color: Color(0xff4C6170),
                                    fontSize: 20,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: TextFormField(
                            cursorColor: Color(0xffD6E6F1),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Email.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 10, 0),
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                hintText: 'xxxxxx@gmail.com',
                                label: Text(
                                  'Your Email',
                                  style: TextStyle(
                                    color: Color(0xff4C6170),
                                    fontSize: 20,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: TextFormField(
                            obscureText: true,
                            //cursorColor: Color(0xffD6E6F1),
                            controller: passwordController1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password.';
                              }
                              else if (value.length<6){
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 10, 0),
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                hintText: '**********',
                                label: Text(
                                  'Your Password',
                                  style: TextStyle(
                                    color: Color(0xff4C6170),
                                    fontSize: 20,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: TextFormField(
                            obscureText: true,
                            //cursorColor: Color(0xffD6E6F1),
                            controller: passwordController2,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password.';
                              }
                              else if (passwordController1.text != passwordController2.text){
                                return 'Passwords are not same.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true, // important line
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 30, 10, 0),
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Color(0xff4C6170))),
                                hintText: '**********',
                                label: Text(
                                  'Your Password (Again)',
                                  style: TextStyle(
                                    color: Color(0xff4C6170),
                                    fontSize: 20,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool control=false;
                      var name = nameController.text;
                      var surname = surnameController.text;
                      var username = usernameController.text;
                      var email = emailController.text;
                      var pass = passwordController2.text;
                      if (_myKey.currentState!.validate()){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registering...')));
                        control = await AuthService().register(email, pass, username, name, surname);
                        ScaffoldMessenger.of(context).deactivate();
                      }
                      if (control){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration Successful...')),
                        );
                        ScaffoldMessenger.of(context).deactivate();
                        //sleep(const Duration(seconds:1));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));

                      }
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xFF9AC6C5)),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff4C6170),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(200, 35),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
                        style: TextStyle(
                          color: Color(0xff4C6170),
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xff48B2FA),
                              fontSize: 15,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
