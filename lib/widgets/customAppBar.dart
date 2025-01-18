import 'package:flutter/material.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(85.0); // Fixed height
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearchActive = false; // State to toggle search functionality

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.greenappBar,
      elevation: 0,
      toolbarHeight: 95,
      titleSpacing: 0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: Image.asset(
              'assets/images/SustainifyLogo.png',
              width: 50,
              height: 60,
            ),
          ),
          SizedBox(
            width: 7,
          ),
          const Text(
            'Sustainify',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.inter,
              fontSize: AppFonts.interRegular18,
              fontWeight: AppFonts.interRegularWeight,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearchActive ? Icons.close : Icons.search,
            color: AppColors.white,
          ),
          onPressed: () {
            setState(() {
              _isSearchActive =
                  !_isSearchActive; // Toggle the search icon state
            });

            // SnackBar when sreach pressed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isSearchActive
                      ? 'Search Activated! You can now search.'
                      : 'Search Deactivated! You can now close the search.',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }
}
