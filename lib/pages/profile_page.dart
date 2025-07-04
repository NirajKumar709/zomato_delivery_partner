import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zomato_delivery_partner/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> dataStore = {};

  @override
  void initState() {
    // TODO: implement initState
    getUserDelivery();
    super.initState();
  }

  getUserDelivery() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection("delivery_partner").doc(globalDocId).get();

    Map<String, dynamic> finalData = snapshot.data() as Map<String, dynamic>;

    dataStore = finalData;

    setState(() {});
  }

  updateUser({
    required String name,
    required String address,
    required String phone,
  }) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("delivery_partner").doc(globalDocId).update({
      "name": name,
      "address": address,
      "phone_number": phone,
    });

    getUserDelivery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10,
          children: [
            dataStore.isNotEmpty
                ? CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(dataStore["imageURL"]),
                )
                : Center(child: CircularProgressIndicator()),
            Text("Profile"),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dataStore.isNotEmpty
                    ? Row(
                      spacing: 10,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(dataStore["imageURL"]),
                        ),
                        Text(dataStore["name"] + " Profile"),
                      ],
                    )
                    : Center(child: CircularProgressIndicator()),
                PopupMenuButton(
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          child: Text("data"),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController nameEdit =
                                    TextEditingController();
                                TextEditingController addressEdit =
                                    TextEditingController();
                                TextEditingController phoneEdit =
                                    TextEditingController();
                                return AlertDialog(
                                  title: Text("Profile Edit"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: nameEdit,
                                          decoration: InputDecoration(
                                            hintText: "Name",
                                          ),
                                        ),
                                        TextFormField(
                                          controller: addressEdit,
                                          decoration: InputDecoration(
                                            hintText: "Address",
                                          ),
                                        ),
                                        TextFormField(
                                          controller: phoneEdit,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Phone Number",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        updateUser(
                                          name: nameEdit.text,
                                          address: addressEdit.text,
                                          phone: phoneEdit.text,
                                        );

                                        Navigator.pop(context);
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                ),
              ],
            ),
          ),
          Card(
            child:
                dataStore.isNotEmpty
                    ? ListTile(
                      title: Text(dataStore["name"]),
                      subtitle: Text(dataStore["phone_number"]),
                      trailing: Text(dataStore["address"]),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(dataStore["imageURL"]),
                      ),
                    )
                    : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
