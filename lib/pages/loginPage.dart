import 'package:actwithy/pages/registerPage.dart';
import 'package:actwithy/services/authService.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _myKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/login.png",
                          ),
                        )),
                  ),
                  Form(
                    key: _myKey,
                    child: Column(
                      children: [
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
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Color(0xff4C6170))),
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
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: TextFormField(
                            obscureText: true,
                            //cursorColor: Color(0xffD6E6F1),
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                fillColor: Color(0xffD6E6F1),
                                filled: true,
                                //focusColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Color(0xff4C6170))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: Color(0xff4C6170))),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xff48B2FA),
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var email = emailController.text;
                      var password = passwordController.text;
                      if (_myKey.currentState!.validate()){
                        await AuthService().signIn(email, password, context);
                      }
                    },
                    child: Text(
                      "Login",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an Account?",
                          style: TextStyle(
                            color: Color(0xff4C6170),
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()));
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xff48B2FA),
                                fontSize: 15,
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
