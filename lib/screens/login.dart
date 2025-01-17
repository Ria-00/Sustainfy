import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(63, 255, 255, 255),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          expandedHeight: 300.0,
          floating: false,
          pinned: true,
          collapsedHeight: 60.0,
          onStretchTrigger: () async {
            setState(() {});
          },
          
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 52, 168, 83),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                  children: [
                    const SizedBox(
                      height: 60.0,
                    ),
                    Expanded(
                      child: ClipRRect(
                        child: Image.asset(
                          "assets/images/suslogo.png",
                          fit: BoxFit.scaleDown,
                          opacity: const AlwaysStoppedAnimation(.5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text(
                      "Hello there \n Welcome back!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 1),
                        
                      ),
                    )
                  ],
                ),
            ),
          ),
        ),
      ]),
    );
  }
}