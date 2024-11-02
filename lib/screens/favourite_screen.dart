import 'package:flutter/material.dart';
import 'package:thai_journey_app/Provider/favourite_provider.dart';
import 'package:thai_journey_app/screens/attraction_detail_screen.dart';
import 'package:thai_journey_app/service/favourite_service.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  //call api
  Map<String, dynamic>? _attractionDetail;
  FavouriteAttractionDetailApiService attractionDetailService =
      FavouriteAttractionDetailApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Map<String, dynamic>?> fetchAttractionDetail(String place_id) async {
    final response = await attractionDetailService
        .fetchFavouriteAttractionDetailService(place_id);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProvider.of(context);
    final favouriteList = provider.favourites; // get method (return List)
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'สถานที่ที่ชอบ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: const Color(0xFF41C9E2),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const Text('Favourite Attractions'),
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemCount: favouriteList.length,
                itemBuilder: (context, index) {
                  final placeId = favouriteList[index];

                  return FutureBuilder<Map<String, dynamic>?>(
                    future: fetchAttractionDetail(placeId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Center(child: Text('Error loading data'));
                      }

                      final attractionDetail = snapshot.data!['result'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttractionDetailScreen(
                                      place_id: attractionDetail['place_id'])));
                        },
                        child: Card(
                          child: Container(
                            height: 300,
                            color: Color(0xFFF7EEDD),
                            child: Column(
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width: 200,
                                    height: 150,
                                    child: Image.network(
                                      attractionDetail['thumbnail_url'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Center(
                                          child: Image.asset(
                                            'assests/nophoto.png',
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  attractionDetail['place_name'] ??
                                      'สถานที่ไม่ระบุ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    ));
  }
}
