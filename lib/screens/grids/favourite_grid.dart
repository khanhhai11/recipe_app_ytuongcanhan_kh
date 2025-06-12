import 'package:flutter/material.dart';
class FavouriteGrid extends StatelessWidget {
  const FavouriteGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFEFF1F7),
        title: Text('Favourite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
      ),
    );
  }
}