import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zomato_delivery_partner/auth/sign_in.dart';

class Registration extends StatefulWidget {
  final String docId;

  const Registration({super.key, required this.docId});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  String imageUrl = "";

  deliveryBoyRegistration({
    required String name,
    required String address,
    required String phoneNumber,
  }) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("delivery_partner")
        .doc(widget.docId)
        .set({
          "name": name,
          "address": address,
          "phone_number": phoneNumber,
          "imageURL": imageUrl,
        })
        .then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 15,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            TextFormField(
              controller: address,
              decoration: InputDecoration(
                hintText: "Enter address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            TextFormField(
              controller: phoneNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "phone number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: Text("upload your image"),
            ),
            ElevatedButton(
              onPressed: () {
                deliveryBoyRegistration(
                  name: nameController.text,
                  address: address.text,
                  phoneNumber: phoneNumber.text,
                );
              },
              child: Text("Register Now"),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Select a image")));
    } else {
      File file = File(pickedImage.path);

      final storageRef = FirebaseStorage.instance.ref();
      final childRef = storageRef.child(
        "delivery_partner/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      await childRef.putFile(file).then((p0) async {
        String downloadURL = await childRef.getDownloadURL();

        imageUrl = downloadURL;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload image successfully")));
      });
    }
  }
}
