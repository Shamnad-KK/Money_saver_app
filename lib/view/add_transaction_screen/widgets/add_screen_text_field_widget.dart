import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddScreenTextFieldWidget extends StatelessWidget {
  const AddScreenTextFieldWidget({
    Key? key,
    required this.controller,
    this.validatorText,
    required this.hintText,
    this.readOnly = false,
    this.isDescription = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? validatorText;
  final String hintText;
  final bool readOnly;
  final bool isDescription;

  @override
  Widget build(BuildContext context) {
    final transactionController =
        Provider.of<TransactionController>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sBoxH20,
        TextFormField(
          inputFormatters: isDescription
              ? null
              : [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+(?:-\d+)?$'),
                  )
                ],
          controller: controller,
          readOnly: readOnly,
          validator: isDescription == false
              ? (value) {
                  if (value == '') {
                    return '$validatorText cannot be empty';
                  }
                  return null;
                }
              : null,
          keyboardType:
              isDescription ? TextInputType.text : TextInputType.number,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: appBodyTextStyle,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: blackColor,
              ),
              borderRadius: BorderRadius.circular(
                10.r,
              ),
            ),
            suffixIcon: readOnly == true
                ? GestureDetector(
                    onTap: () async {
                      await transactionController.showDate(context);

                      if (transactionController.selectedDate != null) {
                        transactionController.dateController.text =
                            DateFormat('yMMMMd')
                                .format(transactionController.selectedDate!);
                      }
                    },
                    child: const Icon(
                      Icons.calendar_month_sharp,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
