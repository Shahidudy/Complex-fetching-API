import 'dart:convert';

import 'package:complexapi/Models/my_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MyModel> userList = [];
  Future<List<MyModel>> getUserData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        userList.add(MyModel.fromJson(i));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complex ApI"),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getUserData(),
            builder: (context, AsyncSnapshot<List<MyModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            ReusableRow(
                                title: "Name",
                                value: snapshot.data![index].name.toString()),
                            ReusableRow(
                                title: "Email",
                                value: snapshot.data![index].email.toString()),
                            ReusableRow(
                                title: "Address",
                                value: snapshot.data![index].address!.city
                                    .toString()),
                            ReusableRow(
                                title: "",
                                value: snapshot.data![index].address!.geo!.lat
                                    .toString()),
                            ReusableRow(
                                title: "",
                                value: snapshot.data![index].address!.geo!.lng
                                    .toString()),
                          ],
                        ),
                      );
                    });
              }
            },
          ))
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final title;
  final value;
  // final address;
  ReusableRow({
    super.key,
    required this.title,
    required this.value,
    // required this.address
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(value)],
    );
  }
}
