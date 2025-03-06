import 'package:flutter/material.dart';
import 'package:sudoku/components/theme_selector_dialog.dart';
import 'package:sudoku/components/tutorial_bottom_sheet.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: const [
        IconButton(
          onPressed: TutorialBottonSheet.show,
          icon: Icon(Icons.help_outline),
        ),
        IconButton(
          onPressed: ThemeSelectorDialog.show,
          icon: Icon(Icons.palette),
        ),
        SizedBox(width: 20)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
