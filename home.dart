import 'package:flutter/material.dart';
import 'package:moodmusic_rumad/models/category.dart';
import 'package:moodmusic_rumad/services/cateory_operations.dart';

class Home extends StatelessWidget {
  const Home({super.key});

Widget createCategory(Category category) {
  return Container(
    color: Colors.blueGrey.shade400,
    child: Row(
      children: [
        Image.network(category.imageURL, fit: BoxFit.cover),
        Text(category.name, style: const TextStyle(color: Colors.white),)
      ]
    )
  );
}

List<Widget> createListOfCategories() {
  List<Category> categoryList = CategoryOperations.getCategories();
  List<Widget> categories = categoryList.map((Category category) => createCategory(category)).toList();
  return categories;
}

  Widget createGrid() {
    return Container(
      height: 400,
      child: GridView.count(
        children: createListOfCategories(),
        crossAxisCount: 2,
      ),
    );
  }

  Widget createAppBar(String message) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(message, style: const TextStyle(color: Colors.white, fontSize: 40)),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: 
            Icon(Icons.settings, color: Colors.white,),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blueGrey.shade300,
            Colors.black],
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
            stops: const [0.1, 0.3])
        ),
        
        child: Column(children: [

          createAppBar('Welcome!'),

          const SizedBox(
            height: 5
            ),
          createGrid()
        ],),
      )
    );
  }
}