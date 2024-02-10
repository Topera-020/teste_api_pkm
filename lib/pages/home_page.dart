import 'package:flutter/material.dart';
import 'package:teste_api/widgets/app_bar_widget.dart';
import 'package:teste_api/widgets/sets_widget.dart';
import 'package:teste_api/models/collections_models.dart';
import 'package:teste_api/services/remote_services.dart';
import 'package:teste_api/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState get createState => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<Collection>?> collectionsFuture;
  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    collectionsFuture = RemoteService().getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        searchController: searchController,
        isSearchExpanded: isSearchExpanded,
        onSearchToggled: (isExpanded) {
          setState(() {
            isSearchExpanded = isExpanded;
          });
        },
        onSearchChanged: (value) {
          // Handle search changes here if needed
          setState(() {
            // Update the search text in the parent widget
            searchController.text = value;
          });
        },
        title: 'Séries',
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder<List<Collection>?>(
        future: collectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Sem dados disponíveis'));
          } else {
            List<Collection> collectionsList = snapshot.data!;
            String query = searchController.text.toLowerCase();
            
            List<Collection> filteredCollectionsList = RemoteService().filterList(collectionsList, (collection) =>
                collection.series.toLowerCase().contains(query.toLowerCase()) ||
                collection.name.toLowerCase().contains(query.toLowerCase()));
                
            List<Collection> sortedCollectionsList = RemoteService().sortList(filteredCollectionsList, (a, b) => -a.releaseDate.compareTo(b.releaseDate));

            Map<String, List<Collection>> groupedCollectionsList = RemoteService().groupListByProperty(sortedCollectionsList, (collection) => collection.series);

            return ListView.builder(
              itemCount: groupedCollectionsList.length,
              itemBuilder: (context, index) {
                var series = groupedCollectionsList.keys.toList()[index];
                var items = groupedCollectionsList[series]!;

                return ExpansionTile(
                  title: Text(
                    series,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: items.map((item) {
                        return SetsCardWidget(collection: item);
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
