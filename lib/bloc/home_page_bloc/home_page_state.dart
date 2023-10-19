// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:contact_list/models/contact_model.dart';

class HomePageState {
  List<Contact>? contactList = [];

  int? indexPage = 0;
  HomePageState({
    this.contactList,
    this.indexPage,
  });

  HomePageState copyWith({
    List<Contact>? contactList,
    int? indexPage,
  }) {
    return HomePageState(
      contactList: contactList ?? this.contactList,
      indexPage: indexPage ?? 0,
    );
  }
}

// class HomePageStateLoadContent extends HomePageState {
//   HomePageStateLoadContent({
//     List<Contact>? newContactList,
//     List<Contact>? newFavoriteContactList,
//     int? newIndexPage,
//   }) : super(
//           contactList: newContactList??[],
//           favoriteContactList: newFavoriteContactList??[],
//           indexPage: newIndexPage,
//         );
// }
