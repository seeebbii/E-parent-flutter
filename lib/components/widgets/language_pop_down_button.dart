import 'package:e_parent_kit/app/translation/languages.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguagePopDownButton extends StatelessWidget {
  const LanguagePopDownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        padding: EdgeInsets.zero,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.language, color: AppTheme.whiteColor, size: 20),
            Icon(Icons.expand_more, color: AppTheme.whiteColor, size: 20),
          ],
        ),
        tooltip: "change_language".tr,
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Text(
                Languages.english,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text(
                Languages.arabic,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              Languages.changeLocale(Languages.english);
              break;
            case 1:
              Languages.changeLocale(Languages.arabic);
              break;
          }
        });
  }
}
