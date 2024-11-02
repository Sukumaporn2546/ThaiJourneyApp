import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thai_journey_app/Provider/favourite_provider.dart';
import 'package:thai_journey_app/model/Provinces.dart';
import 'package:thai_journey_app/screens/attraction_detail_screen.dart';
import 'package:thai_journey_app/screens/place_search_screen.dart';
import 'package:thai_journey_app/service/home_placesearch_api_service.dart';

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<HomeScreen1> {
  final controller = TextEditingController();
  final HomeApiService homeApiService = HomeApiService();

  List<Provinces> provinces = allProvinces;
  Map<String, dynamic>? _homeSearch;
  bool isLoading = true;
  int randomIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchHomePlaceSearch();
    randomIndex = Random().nextInt(46 + 1);
    print('RandomNumber = ${randomIndex}');
  }

  Future<void> fetchHomePlaceSearch() async {
    final response = await homeApiService.fetchHomePlaceSearchService();
    setState(() {
      _homeSearch = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProvider.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assests/logo.png',
                height: 50,
              ),
              // Image.assets("/logo.png",
              //   height: 40,
              // ),
              SizedBox(width: 10),
              Text(
                'ThaiJourney',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Color(0xFF41C9E2),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: 5),
              Text(
                'ค้นพบ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5), // เพิ่มช่องว่างระหว่าง "ค้นพบ" กับคำอธิบาย
              Text(
                'สำรวจสถานที่ท่องเที่ยวในประเทศไทย',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // Use Autocomplete widget for search suggestions
              Autocomplete<Provinces>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Provinces>.empty();
                  }
                  // Sort provinces alphabetically before returning the suggestions
                  return provinces.where((Provinces province) {
                    return province.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  }).toList()
                    ..sort((a, b) =>
                        a.name.compareTo(b.name)); // Sort alphabetically
                },
                displayStringForOption: (Provinces option) => option.name,
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'ชื่อจังหวัด',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                },
                onSelected: (Provinces selectedProvince) {
                  // Navigate to AttractionDetail when a province is selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceSearchScreen(
                          provinceName: selectedProvince.name),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'สถานที่ที่คุณอาจสนใจ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildPlaceCard(randomIndex, provider),
                    SizedBox(height: 10),
                    _buildPlaceCard(randomIndex + 1, provider),
                    SizedBox(height: 10),
                    _buildPlaceCard(randomIndex + 2, provider),
                    SizedBox(height: 10),
                    _buildPlaceCard(randomIndex + 3, provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceCard(int randomIndex, FavouriteProvider provider) {
    if (_homeSearch == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                //ส่ง id ไปให้
                builder: (context) => AttractionDetailScreen(
                    place_id: _homeSearch!['result'][randomIndex]
                        ['place_id'])));
      },
      child: Card(
        color: Color(0xFFF7EEDD), // เปลี่ยนสีพื้นหลังของ Card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                _homeSearch!['result'][randomIndex]['thumbnail_url'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Center(
                    child: Image.asset(
                      "assests/nophoto.png",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 190,
                        child: Text(
                          _homeSearch!['result'][randomIndex]['place_name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                          _homeSearch!['result'][randomIndex]['location']
                              ['province'],
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      provider.toggleFavourite(
                          _homeSearch!['result'][randomIndex]['place_id']);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(color: Colors.white, blurRadius: 6)
                        ],
                      ),
                      child: Icon(
                        provider.isExist(
                                _homeSearch!['result'][randomIndex]['place_id'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
