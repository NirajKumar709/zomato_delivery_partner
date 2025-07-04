import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<DocumentSnapshot> dataStore = [];

  @override
  void initState() {
    // TODO: implement initState
    getRestaurant();
    super.initState();
  }

  getRestaurant() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection("restaurant").get();

    dataStore.addAll(snapshot.docs);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Restaurant Here")),
      body: Column(
        children: [
          Expanded(
            child:
                dataStore.isNotEmpty
                    ? ListView.builder(
                      itemCount: dataStore.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> finalData =
                            dataStore[index].data() as Map<String, dynamic>;

                        return Card(
                          child: ListTile(
                            title: Text(finalData["restaurantName"]),
                            subtitle: Text(finalData["foodType"]),
                            trailing: Text(finalData["address"]),
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                finalData["imageURL"],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                    : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
