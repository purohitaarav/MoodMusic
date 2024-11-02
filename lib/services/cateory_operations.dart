import 'package:moodmusic_rumad/models/category.dart';

class CategoryOperations {
  CategoryOperations._() {

  }
  static List<Category> getCategories() {
    return <Category>[
      Category('Top Songs', 'https://c8.alamy.com/comp/MYMR1N/top-songs-red-grunge-button-stamp-MYMR1N.jpg'),
      Category('Top Songs', 'https://c8.alamy.com/comp/MYMR1N/top-songs-red-grunge-button-stamp-MYMR1N.jpg'),
      Category('Top Songs', 'https://c8.alamy.com/comp/MYMR1N/top-songs-red-grunge-button-stamp-MYMR1N.jpg')
    ];
  }
}