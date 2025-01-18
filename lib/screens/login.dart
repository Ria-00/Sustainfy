import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:align_positioned/align_positioned.dart';

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
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color.fromARGB(63, 255, 255, 255),
                ),
                backgroundColor: const Color.fromARGB(255, 52, 168, 83),
                expandedHeight: 280.0,
                floating: true,
                pinned: true,
                collapsedHeight: 70.0,
                flexibleSpace:ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                  child:  FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 52, 168, 83),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60.0),
                        Expanded(
                          child: ClipRRect(
                            child: Image.asset(
                              "assets/images/suslogo.png",
                              fit: BoxFit.scaleDown,
                              opacity: const AlwaysStoppedAnimation(.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                         Container(
                        height: 52,
                        child: AlignPositioned(
                          child: Text(
                            "Hello there, \nWelcome back!",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                          dx: -113,
                          dy: -15,
                        )),
                      ],
                    ),
                  ),
                ),
            
          )),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
                // Add a bottom widget
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "Scroll to see more!",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Learn More"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
