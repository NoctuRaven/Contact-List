import 'package:contact_list/models/contact_model.dart';

class HomePageEvent {}

class LoadContactList extends HomePageEvent {}

class AddNewContact extends HomePageEvent {
  Contact newContact;
  AddNewContact({required this.newContact});
}

class DeletContact extends HomePageEvent {
  Contact contact;
  DeletContact({required this.contact});
}

class UpdateContact extends HomePageEvent {
  Contact contact;
  UpdateContact({required this.contact});
}

class ChangePage extends HomePageEvent {
  int page;
  ChangePage({required this.page});
}
