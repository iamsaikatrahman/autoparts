import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData traillingIcon;
  final Function onPressed;
  const DrawerItems({
    Key key,
    this.leadingIcon,
    this.title,
    this.traillingIcon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListTile(
        leading: Icon(
          leadingIcon,
          color: Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          traillingIcon,
          color: Colors.black,
        ),
        onTap: onPressed,
      ),
    );
  }
}



class DrawerDivider extends StatelessWidget {
  const DrawerDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Divider(height: 2, color: Colors.grey[400], thickness: 1.0),
    );
  }
}