import 'package:contact_list/database/sql_database.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact_model.dart';

class ContactRepository {
  late Database db;

  Future<List<Contact>> getContactList() async {
    db = await DatabaseContact.instance.database;
    List<Map<String, dynamic>> records = await db.query('contact');
    List<Contact> contactList = records.map((e) => Contact.fromMap(e)).toList();

    return contactList;
  }

  updateContact(Contact contact) async {
    db = await DatabaseContact.instance.database;
    db.update(
        'contact',
        {
          'name': contact.name,
          'email': contact.email,
          'phone': contact.phone,
          'isFavorite': contact.isFavorite,
          'imagePath': contact.imagePath,
        },
        where: 'id = ?',
        whereArgs: [contact.id]);
    print(contact.isFavorite);
  }

  createContact(Contact contact) async {
    db = await DatabaseContact.instance.database;
    db.insert(
      'contact',
      {
        'name': contact.name,
        'email': contact.email,
        'phone': contact.phone,
        'isFavorite': contact.isFavorite,
        'imagePath': contact.imagePath,
      },
    );
  }

  deleteContact(Contact contact) async {
    db = await DatabaseContact.instance.database;
    db.delete(
      'contact',
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
}
