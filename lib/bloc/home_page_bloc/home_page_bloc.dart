import 'package:bloc/bloc.dart';
import 'package:contact_list/database/contact_repository.dart';
import 'package:contact_list/database/sql_database.dart';
import 'package:contact_list/models/contact_model.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final ContactRepository db = ContactRepository();
  HomePageBloc() : super(HomePageState().copyWith()) {
    //creating reference to the database

    //events
    on<LoadContactList>((event, emit) async {
      List<Contact> contactList = await db.getContactList();
      emit(HomePageState().copyWith(contactList: contactList));
    });

    on<DeletContact>((event, emit) async {
      db.deleteContact(event.contact);
      List<Contact> contactList = await db.getContactList();
      emit(HomePageState().copyWith(contactList: contactList));
    });

    on<UpdateContact>((event, emit) async {
      db.updateContact(event.contact);
      List<Contact> contactList = await db.getContactList();
      emit(HomePageState().copyWith(contactList: contactList));
    });

    on<AddNewContact>((event, emit) async {
      db.createContact(event.newContact);
      List<Contact> contactList = await db.getContactList();
      emit(HomePageState().copyWith(contactList: contactList));
    });

    on<ChangePage>((event, emit) async {
      // TODO: implement event handler
      print(event.page);
      List<Contact> contactList = await db.getContactList();
      emit(HomePageState()
          .copyWith(indexPage: event.page, contactList: contactList));
    });
  }
}
