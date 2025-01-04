import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health2mama/APIs/auth_flow/authentication_bloc.dart';
import 'package:health2mama/APIs/auth_flow/authentication_event.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';

class GlobalSearchScreen extends StatefulWidget {
  GlobalSearchScreen({Key? key}) : super(key: key);

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  TextEditingController searchController = TextEditingController();
  int page = 1;
  int limit = 10;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _fetchSearchResults();
  }

  // Handle search query changes
  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text;
    });
    _fetchSearchResults();
  }

  // Fetch search results by triggering the BLoC event
  void _fetchSearchResults() {
    BlocProvider.of<AuthenticationBloc>(context).add(
      GlobalSearchEvent(search: searchQuery, page: page, limit: limit),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: SingleChildScrollView(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is GlobalSearchLoading) {
              // Display loading indicator when fetching results
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Loading results...')),
              );
            } else if (state is GlobalSearchSuccess) {
              // Successfully received search results
              // Data is already handled in the builder function
            } else if (state is GlobalSearchFailure) {
              // Handle errors, e.g., display an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error fetching results')),
              );
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is GlobalSearchLoading) {
                return Center(child: CircularProgressIndicator(color: AppColors.pink));
              } else if (state is GlobalSearchSuccess) {
                final data = state.GlobalSearchResponse;
                final programs = data['result']['programs']['data'];
                final topics = data['result']['topics']['data'];
                final workoutCategories = data['result']['workoutSubCategories']['data'];
                final recipes = data['result']['recipes']['data'];

                return Column(
                  children: [
                    // Search TextField
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    // Pagination Controls
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Page Control
                          ElevatedButton(
                            onPressed: page > 1
                                ? () {
                              setState(() {
                                page--;
                              });
                              _fetchSearchResults();
                            }
                                : null,
                            child: Text('Previous'),
                          ),
                          Text('Page: $page'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                page++;
                              });
                              _fetchSearchResults();
                            },
                            child: Text('Next'),
                          ),

                          // Limit Control
                          DropdownButton<int>(
                            value: limit,
                            onChanged: (newLimit) {
                              setState(() {
                                limit = newLimit!;
                              });
                              _fetchSearchResults();
                            },
                            items: [10, 20, 30].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value items per page'),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    // Program Section
                    if (programs != null && programs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Programs"),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: programs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: Image.network(
                                        programs[index]['programThumbnailImage']),
                                    title: Text(programs[index]['programName']),
                                    subtitle: Text(programs[index]['categoryName']),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    // Topic Section
                    if (topics != null && topics.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Topics"),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: topics.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: Image.network(
                                        topics[index]['topicThumbnailImage']),
                                    title: Text(topics[index]['topicName']),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    // Workout Categories Section
                    if (workoutCategories != null && workoutCategories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Workout Categories"),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: workoutCategories.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(workoutCategories[index]
                                    ['categoryName']),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    // Recipes Section
                    if (recipes != null && recipes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Recipes"),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(recipes[index]['recipeName']),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              } else if (state is GlobalSearchFailure) {
                return Center(
                  child: Text("Error fetching data. Please try again."),
                );
              } else {
                return Center(
                  child: Text("No results found."),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
