import 'dart:io';

import 'package:contact_list/bloc/home_page_bloc/home_page_bloc.dart';
import 'package:contact_list/database/sql_database.dart';
import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/pages/contact_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/home_page_bloc/home_page_event.dart';
import 'package:brasil_fields/brasil_fields.dart';

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

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      backgroundImage: widget.contact.imagePath != null
                          ? FileImage(File(widget.contact.imagePath!))
                          : null,
                      child: widget.contact.imagePath == null
                          ? Text(
                              widget.contact.name[0],
                              style: const TextStyle(fontSize: 100),
                            )
                          : null,
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          setState(() {
                            _makePhoneCall(widget.contact.phone);
                          });
                        },
                        child: Icon(Icons.phone),
                      ),
                      Text("Call"),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          setState(() {
                            _sendSMS(widget.contact.phone);
                          });
                        },
                        child: Icon(Icons.message),
                      ),
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
                      leading: Icon(Icons.phone),
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
                      leading: Icon(Icons.email),
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
