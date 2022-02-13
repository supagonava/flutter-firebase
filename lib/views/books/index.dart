import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterfire/views/books/form.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference books = database.ref("books");

DatabaseReference comRef = books.child("computer");
DatabaseReference mathRef = books.child("math");

class BookIndex extends StatefulWidget {
  const BookIndex({Key? key}) : super(key: key);

  @override
  _BookIndexState createState() => _BookIndexState();
}

class _BookIndexState extends State<BookIndex> {
  List<Map<String, String>> computer = [];
  List<Map<String, String>> math = [];

  @override
  void initState() {
    super.initState();
    onInit();
  }

  onInit() async {
    final Stream<DatabaseEvent> event = books.onValue;
    event.listen((event) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    log("fetch on change");
    computer.clear();
    math.clear();

    final DataSnapshot comSnap = await comRef.get();
    for (var el in comSnap.children) {
      setState(() {
        computer.add({
          "id": "${el.key}",
          "name": "${el.value}",
        });
      });
    }

    final DataSnapshot mathSnap = await mathRef.get();
    for (var el in mathSnap.children) {
      setState(() {
        math.add({
          "id": "${el.key}",
          "name": "${el.value}",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book index',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          MaterialButton(
              child: const Icon(Icons.edit),
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const BookForm(),
                      ),
                    )
                  })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Computer"),
              SizedBox(
                // height: size.height * .35,
                child: Column(
                  children: computer
                      .map((e) => ListTile(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => BookForm(id: e['id'], category: 'computer', name: e['name']),
                                ),
                              )
                            },
                            title: Text("${e['name']}"),
                            trailing: MaterialButton(
                                child: const Icon(Icons.delete),
                                onPressed: () {
                                  comRef.child("${e['id']}").set(null);
                                }),
                          ))
                      .toList(),
                ),
              ),
              const Text("Math"),
              SizedBox(
                // height: size.height * .35,
                child: Column(
                  children: math
                      .map((e) => ListTile(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => BookForm(id: e['id'], category: 'math', name: e['name']),
                                ),
                              )
                            },
                            title: Text("${e['name']}"),
                            trailing: MaterialButton(
                                child: const Icon(Icons.delete),
                                onPressed: () {
                                  mathRef.child("${e['id']}").set(null);
                                }),
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
