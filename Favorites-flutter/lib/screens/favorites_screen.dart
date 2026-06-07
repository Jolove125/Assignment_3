// Latasha Glover
// completed Favorites Screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context);

    final favoriteCities = favoritesProvider.cities
        .where((city) => city.isFavorite)
        .toList();

    final favoriteHobbies = favoritesProvider.hobbies
        .where((hobby) => hobby.isFavorite)
        .toList();

    final favoriteBooks = favoritesProvider.books
        .where((book) => book.isFavorite)
        .toList();

    final hasFavorites =
        favoriteCities.isNotEmpty ||
        favoriteHobbies.isNotEmpty ||
        favoriteBooks.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Favorites"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            color: Colors.red,
            onPressed: () async {

              if (!hasFavorites) return;

              final result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Clear Favorites",
                    ),
                    content: const Text(
                      "Are you sure you want to remove all favorites?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            false,
                          );
                        },
                        child: const Text(
                          "Cancel",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            true,
                          );
                        },
                        child: const Text(
                          "Clear",
                        ),
                      ),
                    ],
                  );
                },
              );

              if (result == true) {
                favoritesProvider.clearFavorites();
              }
            },
          ),
        ],
      ),

      body: !hasFavorites
          ? const Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(12),
              children: [

                // Favorite Cities
                if (favoriteCities.isNotEmpty) ...[
                  const Text(
                    "Cities",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                ...favoriteCities.map(
                  (city) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.location_city,
                      ),
                      title: Text(city.cityName),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleCityFavorite(
                            city.id,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Favorite Hobbies
                if (favoriteHobbies.isNotEmpty) ...[
                  const Text(
                    "Hobbies",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                ...favoriteHobbies.map(
                  (hobby) => Card(
                    child: ListTile(
                      leading: Text(
                        hobby.hobbyIcon,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      title: Text(
                        hobby.hobbyName,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleHobbyFavorite(
                            hobby.id,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Favorite Books
                if (favoriteBooks.isNotEmpty) ...[
                  Text(
                    "Books",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                ...favoriteBooks.map(
                  (book) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.menu_book,
                      ),
                      title: Text(
                        book.bookTitle,
                      ),
                      subtitle: Text(
                        book.bookAuthor,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleBookFavorite(
                            book.id,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}