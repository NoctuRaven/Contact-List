import 'dart:io';

import 'package:contact_list/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc/home_page_bloc.dart';
import '../models/contact_model.dart';

class ContactListWidget extends StatelessWidget {
  final String letter;
  List<Contact> contactList;
  Function(Contact) onDelete;
  Function(Contact) onCreate;
  Function(Contact) onUpdate;

  ContactListWidget({
    super.key,
    required this.letter,
    required this.contactList,
    required this.onCreate,
    required this.onDelete,
    required this.onUpdate,
  });

  Widget createContactWidget(BuildContext context, Contact contact) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactPage(
                contact: contact,
                onDelete: onDelete,
                onCreate: onCreate,
                onUpdate: onUpdate,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            // border: Border.all(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: contact.imagePath != null
                        ? Image.file(File(contact.imagePath!))
                        : Text(contact.name[0]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(contact.name.toString()),
                ],
              ),
              Visibility(
                  visible: contact.isFavorite == 1,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: contactList.isNotEmpty,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          //List of contacts
          Column(
            children: [
              ...contactList
                  .map((e) => createContactWidget(context, e))
                  .toList()
            ],
          )
        ],
      ),
    );
  }
}
