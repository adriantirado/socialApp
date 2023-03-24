import 'package:flutter/material.dart';
import 'package:social_pet/utils/colors.dart';



class WebScreen extends StatelessWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/logo1.png',
          color: Colors.deepOrange,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
   
    
    );
  }
}