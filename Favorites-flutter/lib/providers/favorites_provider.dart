// modified by Latasha Glover

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';

class FavoritesProvider extends ChangeNotifier {

  bool isDarkMode = false;

  final cities = sampleCities;
  final hobbies = sampleHobbies;
  final books = sampleBooks;

  FavoritesProvider() {
    loadFavorites();
    loadTheme();
  }

  void toggleHobbyFavorite(int hobbyId) {
    final hobby = hobbies.firstWhere(
      (hobby) => hobby.id == hobbyId,
    );

    hobby.isFavorite = !hobby.isFavorite;

    saveFavorites();

    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    isDarkMode = value;

    saveTheme();

    notifyListeners();
  }

  void toggleCityFavorite(int cityId) {
    final city = cities.firstWhere(
      (city) => city.id == cityId,
    );

    city.isFavorite = !city.isFavorite;

    saveFavorites();

    notifyListeners();
  }

   void toggleBookFavorite(int bookId) {
    final book = books.firstWhere(
      (book) => book.id == bookId,
    );

    book.isFavorite = !book.isFavorite;
    
    saveFavorites();

    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'favoriteCities',

      cities
        .where((city) => city.isFavorite)
        .map((city) => city.id.toString())
        .toList(),
    );
      
    await prefs.setStringList(
      'favoriteHobbies',

      hobbies
        .where((hobby) => hobby.isFavorite)
        .map((hobby) => hobby.id.toString())
        .toList(),
    );

    await prefs.setStringList(
      'favoriteBooks',

      books
        .where((book) => book.isFavorite)
        .map((book) => book.id.toString())
        .toList(),
    );
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final cityIds = prefs.getStringList('favoriteCities') ?? [];
    final hobbyIds = prefs.getStringList('favoriteHobbies') ?? [];
    final bookIds = prefs.getStringList('favoriteBooks') ?? [];

    for (final city in cities) {
      city.isFavorite = cityIds.contains(city.id.toString());
    }

    for (final hobby in hobbies) {
      hobby.isFavorite = hobbyIds.contains(hobby.id.toString());
    }

    for (final book in books) {
      book.isFavorite = bookIds.contains(book.id.toString());
    }

    notifyListeners();
  }

  Future<void> clearFavorites() async {

  for (var city in cities) {
    city.isFavorite = false;
  }

  for (var hobby in hobbies) {
    hobby.isFavorite = false;
  }

  for (var book in books) {
    book.isFavorite = false;
  }

  await saveFavorites();

  notifyListeners();
}

Future<void> saveTheme() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(
    'darkMode',
    isDarkMode,
  );
}

Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();

  isDarkMode =
      prefs.getBool('darkMode') ?? false;

  notifyListeners();
}

}