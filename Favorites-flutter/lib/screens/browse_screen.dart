// Modified by Latasha Glover

import '/widgets/book_row.dart';
import 'package:flutter/material.dart';
import '/widgets/city_card.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/hobby_row.dart';

enum ContentCategory {
  cities,
  hobbies,
  books,
}

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  ContentCategory selectedCategory = ContentCategory.cities;
  String searchText = "";

  String get searchHint => "Search ${selectedCategory.name}";

  @override
  Widget build(BuildContext context) {

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton(
              segments: [
                ButtonSegment(
                  value: ContentCategory.cities,
                  label: Text("Cities")),
                ButtonSegment(
                  value: ContentCategory.hobbies,
                  label: Text("Hobbies")),
                ButtonSegment(
                  value: ContentCategory.books,
                  label: Text("Books"))
              ], 
              selected: {selectedCategory},
              onSelectionChanged: (selection) {
                setState(() {
                  selectedCategory = selection.first;
                });
              },),

            SizedBox(height: 16,),

            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: searchHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),

            SizedBox(height: 16),

            Expanded(
              child: Builder(
                builder: (context) {
                  switch (selectedCategory) {
                    case ContentCategory.cities:                      
                        final filteredCities = favoritesProvider.cities.where((city){
                          return city.cityName.toLowerCase().contains(searchText.toLowerCase());
                        })
                        .toList();

                        return ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          return CityCard(city: filteredCities [index]);
                        },
                      );

                    case ContentCategory.hobbies:
                      final filteredHobbies = favoritesProvider.hobbies.where((hobby){
                          return hobby.hobbyName.toLowerCase().contains(searchText.toLowerCase());
                        })
                        .toList();

                        return ListView.builder(
                        itemCount: filteredHobbies.length,
                        itemBuilder: (context, index) {
                          return HobbyRow(hobby: filteredHobbies [index]);
                        },
                      );

                    case ContentCategory.books:
                      final filteredBooks = favoritesProvider.books.where((book){
                          return book.bookTitle.toLowerCase().contains(searchText.toLowerCase());
                        })
                        .toList();

                        return ListView.builder(
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          return BookRow(book: filteredBooks [index]);
                        },
                      );
                  }
                }
              ),
            ),
          ],
        ),
        )),
    );
  }
}