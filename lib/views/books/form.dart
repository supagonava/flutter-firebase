import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
var uuid = const Uuid();

class BookForm extends StatefulWidget {
  final String? id;
  final String? name;
  final String? category;

  const BookForm({Key? key, this.id, this.category, this.name}) : super(key: key);

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  TextEditingController cateCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      setState(() => nameCon.text = widget.name!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.id != null ? 'Edit' : 'Add'} book")),
      body: Center(
          child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            widget.category == null
                ? TextFormField(
                    controller: cateCon,
                    decoration: const InputDecoration(helperText: "categories"),
                  )
                : const SizedBox(),
            TextFormField(
              controller: nameCon,
              decoration: const InputDecoration(helperText: "name"),
            ),
            MaterialButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  final refPath = "${widget.category == null ? cateCon.text : widget.category!}/${widget.id ?? uuid.v1()}";
                  DatabaseReference ref = database.ref("books/$refPath");

                  log("books/$refPath");
                  log(nameCon.text);

                  ref.set(nameCon.text);
                  Navigator.pop(context);
                })
          ],
        ),
      )),
    );
  }
}
