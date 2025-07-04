import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zomato_delivery_partner/auth/sign_in.dart';
import 'package:zomato_delivery_partner/main.dart';
import 'package:zomato_delivery_partner/pages/profile_page.dart';
import 'package:zomato_delivery_partner/pages/restaurant_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getImage();
    super.initState();
  }

  Map<String, dynamic> dataStore = {};

  getImage() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection("delivery_partner").doc(globalDocId).get();

    Map<String, dynamic> finalData = snapshot.data() as Map<String, dynamic>;

    dataStore = finalData;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        centerTitle: true,
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.logout),
            ),
            onTap: () {
              signOut();
            },
          ),
        ],
      ),
      body: Column(children: [Text("data")]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: InkWell(
              child: Icon(Icons.restaurant),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantPage()),
                );
              },
            ),
            label: "Restaurant",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              child:
                  dataStore.isNotEmpty
                      ? CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(dataStore["imageURL"]),
                      )
                      : Center(child: CircularProgressIndicator()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
