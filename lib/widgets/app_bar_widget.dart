import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String titleText;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.titleText,
    required this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xBA443015),
      iconTheme: const IconThemeData(color: Colors.white),
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/');
        },
        child: Row(
          children: [
            Text(
              titleText,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text('🫒', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
