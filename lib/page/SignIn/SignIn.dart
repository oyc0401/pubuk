import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterschool/page/Home/home.dart';
import 'package:flutterschool/page/SignIn/register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff99765F),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 170,
              ),
              Text(
                "Title",
                style: TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300,
              ),
              googleLoginButton(),
              SizedBox(
                height: 20,
              ),
              appleLoginButton()
            ],
          ),
        ),
      ),
    );
  }

  InkWell googleLoginButton() {
    return InkWell(
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign in with Google",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      onTap: () {
        print("google Login touch");
        GoogleLogin();
      },
    );
  }

  InkWell appleLoginButton() {
    return InkWell(
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Sign in with Apple",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  GoogleLogin() async {
    bool isExisted=await login();
    
    if(isExisted){
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const register(),
        ),
      );
    }else{
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(title: "학교"),
        ),
      );
    }
    
  }

  login()async{

    return false;
  }
}
