import 'dart:io';

import 'package:contact_list/bloc/home_page_bloc/home_page_bloc.dart';
import 'package:contact_list/database/sql_database.dart';
import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/pages/contact_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc/home_page_event.dart';

class ContactPage extends StatefulWidget {
  Contact contact;
  Function(Contact) onDelete;
  Function(Contact) onCreate;
  Function(Contact) onUpdate;
  bool? isFavorite;

  ContactPage({
    super.key,
    required this.contact,
    required this.onCreate,
    required this.onDelete,
    required this.onUpdate,
  }) {
    isFavorite = contact.isFavorite == 1;
  }

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  onFavoriteTap() {
    widget.isFavorite = !widget.isFavorite!;
    widget.contact.isFavorite = widget.isFavorite! ? 1 : 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ContactCreationPage(
                      onCreate: widget.onCreate,
                      onUpdate: widget.onUpdate,
                      contact: widget.contact,
                      onDelete: widget.onDelete,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit_document)),
          IconButton(
              onPressed: () {
                onFavoriteTap();
                widget.onUpdate(widget.contact);
              },
              icon: Icon(Icons.star)),
          IconButton(
              onPressed: () {
                widget.onDelete(widget.contact);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 125,
                      child: widget.contact.imagePath != null
                          ? Image.file(File(widget.contact.imagePath!))
                          : Text(
                              widget.contact.name[0],
                              style: const TextStyle(fontSize: 100),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.contact.name),
                  ],
                ),
                Visibility(
                  visible: widget.isFavorite == true,
                  child: Positioned(
                    top: 15,
                    right: 10,
                    child: Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 70,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: Icon(Icons.phone)),
                      Text("Call"),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: Icon(Icons.message)),
                      Text("Message"),
                    ],
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Contact info"),
                  ),
                  Visibility(
                    visible: widget.contact.name != null &&
                        widget.contact.phone != "",
                    replacement: Container(),
                    child: ListTile(
                      title: Text(
                        widget.contact.phone.toString(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.contact.email != null &&
                        widget.contact.email != "",
                    replacement: Container(),
                    child: ListTile(
                      title: Text(
                        widget.contact.email.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
