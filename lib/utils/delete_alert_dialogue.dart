import 'package:flutter/material.dart';

class DeleteAlertDialogue extends StatelessWidget {
  const DeleteAlertDialogue({
    super.key,
    required this.ontap,
  });

  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure ?'),
      content: const Text('Do you want to delete ?'),
      actions: [
        TextButton(
          onPressed: ontap,
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
