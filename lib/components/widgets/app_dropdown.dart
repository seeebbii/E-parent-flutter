import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';


class AppDropdown extends StatelessWidget {
  AppDropdown({
    Key? key,
    required this.controller,
    required this.myKey,
    required this.contentList,
    this.enabled = true,

    // required this.labelText,
    this.hintText = 'Not selected',
    this.isOptional = false,
    this.validateMode = AutovalidateMode.onUserInteraction,
    required this.itemBuilder
  }) : super(key: key);

  bool enabled;
  final TextEditingController controller;
  final GlobalKey<DropdownSearchState<String>> myKey;
  final List<String> contentList;
  // final String labelText;
  final String hintText;
  final bool isOptional;
  final AutovalidateMode validateMode;
  final Widget Function(BuildContext, String, bool) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      enabled: enabled,
      autoValidateMode: validateMode,
      validator: isOptional != true
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'required filed';
              }
              return null;
            }
          : (value) {
              return null;
            },
      clearButtonProps: const ClearButtonProps(isVisible: false),
      key: myKey,
      items: contentList,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          )),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 1.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            borderSide: BorderSide(color: Colors.black, width: 0.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
              height: 0.7,
              color: Colors.black,
              // fontSize: size.height * 0.022,
              fontWeight: FontWeight.normal),
        ),
      ),
      // compareFn: (i1, i2) => i1 == i2,
      popupProps: PopupProps.menu(
        showSearchBox: false,
        showSelectedItems: true,
        interceptCallBacks: true,
        itemBuilder: itemBuilder,
        /*itemBuilder: (ctx, item, isSelected) {
          return ListTile(
              selected: isSelected,
              title: Text(item),
              onTap: () {
                myKey.currentState?.popupValidate([item.toString()]);
                controller.text = item.toString();
              });
        },*/
      ),
    );
  }
}
