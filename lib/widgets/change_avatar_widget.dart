import 'dart:io';

import 'package:flutter/material.dart';

class ChangeAvatarWidget extends StatelessWidget {
  String? contactImagePath;
  ChangeAvatarWidget({super.key, this.contactImagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundImage: contactImagePath != null
              ? FileImage(
                  File(
                    contactImagePath!,
                  ),
                )
              : null,
          child: Visibility(
            visible: contactImagePath == null,
            child: Icon(
              Icons.add_a_photo,
              size: 70,
            ),
          ),
        ),
        Visibility(
          visible: contactImagePath != null,
          child: Positioned(
            right: 10,
            height: 10,
            child: Icon(
              Icons.replay_outlined,
              size: 60,
            ),
          ),
        ),
      ],
    );
  }
}
