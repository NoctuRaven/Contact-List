import 'dart:io';

import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ContactCreationPage extends StatefulWidget {
  final Function(Contact) onCreate;
  final Function(Contact) onUpdate;
  final Function(Contact) onDelete;
  Contact? contact;
  ContactCreationPage(
      {super.key,
      required this.onCreate,
      required this.onUpdate,
      required this.onDelete,
      this.contact});

  @override
  State<ContactCreationPage> createState() => _ContactCreationPageState();
}

class _ContactCreationPageState extends State<ContactCreationPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String? contactName;
  String? contactEmail;
  String? contactPhone;
  String? contactImagePath;

  String? nameValidate(String? value) {
    RegExp name = RegExp(r"[a-z]");
    if (value == null || value == "") {
      return "Invalid name";
    }
    return null;
  }

  String? numberValidate(String? value) {
    // RegExp number = RegExp(r"/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/");
    RegExp number = RegExp(r"[0-9]");

    if (!number.hasMatch(value!)) {
      return "Invalid phone number";
    }
    return null;
  }

  getUserPhoto() {}

  @override
  Widget build(BuildContext context) {
    if (widget.contact != null) {
      contactName = widget.contact!.name;
      contactEmail = widget.contact!.email;
      if (widget.contact!.imagePath != "" &&
          widget.contact!.imagePath != null) {
        contactImagePath = widget.contact!.imagePath;
      }
      contactPhone = widget.contact!.phone;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (widget.contact != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => ContactPage(
                          contact: widget.contact!,
                          onCreate: widget.onCreate,
                          onDelete: widget.onDelete,
                          onUpdate: widget.onUpdate,
                        )),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? photo =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (photo != null) {
                  var path =
                      (await path_provider.getApplicationDocumentsDirectory())
                          .path;
                  String fileName = basename(photo.path);

                  contactImagePath = photo.path;
                  print("Path= " + contactImagePath.toString());

                  await photo.saveTo("$path/$fileName");
                  setState(() {});
                }
              },
              child: CircleAvatar(
                  radius: 90,
                  child: contactImagePath != null
                      ? Stack(
                          children: [
                            Image.file(File(contactImagePath!)),
                            Positioned(
                              right: 10,
                              height: 10,
                              child: Icon(
                                Icons.replay_outlined,
                                size: 60,
                              ),
                            ),
                          ],
                        )
                      : Icon(
                          Icons.add_a_photo,
                          size: 70,
                        )),
            ),
          ),
          Form(
            key: _form,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: contactPhone,
                    maxLength: 11,
                    validator: numberValidate,
                    onSaved: (newValue) => contactPhone = newValue,
                    decoration: InputDecoration(
                      labelText: "Phone number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    initialValue: contactName,
                    validator: nameValidate,
                    onSaved: (newValue) => contactName = newValue,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue: contactEmail,
                    onSaved: (newValue) => contactEmail = newValue,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (_form.currentState!.validate()) {
                _form.currentState!.save();
                if (widget.contact == null) {
                  widget.contact = Contact(
                    name: contactName!,
                    phone: contactPhone!,
                    isFavorite: 0,
                    email: contactEmail,
                    imagePath: contactImagePath,
                  );
                  widget.onCreate(widget.contact!);
                  Navigator.pop(context);
                } else {
                  widget.onUpdate(widget.contact!.copyWith(
                    email: contactEmail,
                    imagePath: contactImagePath,
                    name: contactName,
                    phone: contactPhone,
                  ));
                  Navigator.pop(context);
                }
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
