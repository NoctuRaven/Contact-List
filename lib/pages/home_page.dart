import 'package:contact_list/bloc/home_page_bloc/home_page_event.dart';
import 'package:contact_list/database/contact_repository.dart';
import 'package:contact_list/pages/contact_creation_page.dart';
import 'package:contact_list/utils/utils.dart';
import 'package:contact_list/widgets/contact_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc/home_page_bloc.dart';
import '../bloc/home_page_bloc/home_page_state.dart';
import '../database/sql_database.dart';
import '../models/contact_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final indice = Utils().indice;

  @override
  void initState() {
    super.initState();
    context.read<HomePageBloc>().add(LoadContactList());
  }

  List<NavigationDestination> buildNavigationDestinationItems() {
    return const [
      NavigationDestination(
          selectedIcon: Icon(
            Icons.person_2,
          ),
          icon: Icon(
            Icons.person_2_outlined,
          ),
          label: "Contacts"),
      NavigationDestination(
          selectedIcon: Icon(
            Icons.star,
          ),
          icon: Icon(
            Icons.star_outline,
          ),
          label: "Favorites"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String? filter;
    String? filterFavorite;

    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        List<Contact> searchFilter(List<Contact> contactList, String filter) {
          return contactList
              .where((element) =>
                  element.name.toLowerCase().startsWith(filter.toLowerCase()))
              .toList();
        }

        List<Contact> getSortedList(int index) {
          List<Contact> contatList = (state.contactList!
              .where((element) => element.name
                  .toLowerCase()
                  .startsWith(indice[index].toLowerCase(), 0))
              .toList());
          if (contatList != null) {
            contatList = contatList..sort((a, b) => a.name.compareTo(b.name));
          }
          return contatList;
        }

        void pageChanged(int index) {
          print(index);
          context.read<HomePageBloc>().add(ChangePage(page: index));
        }

        HomePageBloc bloc = context.read<HomePageBloc>();
        onDelete(Contact contact) {
          bloc.add(DeletContact(contact: contact));
        }

        onUpdate(Contact contact) {
          bloc.add(UpdateContact(contact: contact));
        }

        onCreate(Contact contact) {
          bloc.add(AddNewContact(newContact: contact));
        }

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: pageChanged,
            destinations: buildNavigationDestinationItems(),
            selectedIndex: state.indexPage!,
            surfaceTintColor: Colors.amber[800],
          ),
          body: <Widget>[
            SafeArea(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // decoration: BoxDecoration(color: Colors.grey[800]),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              if (RegExp(r"[a-zA-Z]").hasMatch(value)) {
                                filter = value;
                              } else {
                                filter = null;
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),

                        // Add contact button
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ContactCreationPage(
                                  onCreate: onCreate,
                                  onUpdate: onUpdate,
                                  onDelete: onDelete,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                                Text('Create a new contact'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //  indice letter
                  Expanded(
                    child: ListView.builder(
                        itemCount: indice.length,
                        itemBuilder: (context, index) {
                          List<Contact> indiceList = state.contactList == null
                              ? []
                              : getSortedList(index);
                          filter != null && filter != ""
                              ? indiceList = searchFilter(indiceList, filter!)
                              : indiceList;

                          return ContactListWidget(
                            letter: indice[index],
                            contactList: indiceList,
                            onDelete: onDelete,
                            onCreate: onCreate,
                            onUpdate: onUpdate,
                          );
                        }),
                  )
                ],
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        if (RegExp(r"[a-z]").hasMatch(value)) {
                          filterFavorite = value;
                        } else {
                          filterFavorite = null;
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  // indice letter
                  Expanded(
                    child: ListView.builder(
                      itemCount: indice.length,
                      itemBuilder: (context, index) {
                        List<Contact> indiceList = state.contactList == null
                            ? []
                            : getSortedList(index)
                                .where((element) => element.isFavorite == 1)
                                .toList();

                        filterFavorite != null && filterFavorite != ""
                            ? indiceList =
                                searchFilter(indiceList, filterFavorite!)
                            : indiceList;

                        return ContactListWidget(
                          letter: indice[index],
                          contactList: indiceList,
                          onDelete: onDelete,
                          onCreate: onCreate,
                          onUpdate: onUpdate,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ][state.indexPage!],
        );
      },
    );
  }
}
