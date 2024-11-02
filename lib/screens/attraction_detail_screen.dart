import 'package:flutter/material.dart';
import 'package:thai_journey_app/Provider/favourite_provider.dart';
import 'package:thai_journey_app/service/attraction_detail_api_service.dart';

class AttractionDetailScreen extends StatefulWidget {
  final String place_id;
  const AttractionDetailScreen({super.key, required this.place_id});

  @override
  State<AttractionDetailScreen> createState() => _AttractionDetailScreenState();
}

class _AttractionDetailScreenState extends State<AttractionDetailScreen> {
  Map<String, dynamic>? _attractionDetail;
  AttractionDetailApiService attractionDetailService =
      AttractionDetailApiService();

  @override
  void initState() {
    super.initState();
    fetchAttractionDetail();
  }

  Future<void> fetchAttractionDetail() async {
    final response = await attractionDetailService
        .fetchAttractionDetailService(widget.place_id);
    setState(() {
      _attractionDetail = response;
    });
  }

  String PrintDetail() {
    String allDetail = "";
    String intro =
        _attractionDetail!['result']['place_information']['introduction'];
    String detail = _attractionDetail!['result']['place_information']['detail'];
    if (intro.isNotEmpty) {
      allDetail +=
          _attractionDetail!['result']['place_information']['introduction'];
      allDetail += "\n";
    }
    if (detail.isNotEmpty) {
      allDetail += _attractionDetail!['result']['place_information']['detail'];
    }
    if (allDetail.isNotEmpty) {
      return allDetail;
    }
    return 'ไม่พบข้อมูล';
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavouriteProvider.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 253, 249, 241),
        body: _attractionDetail == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Image.network(_attractionDetail!['result']['thumbnail_url'],
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      fit: BoxFit.cover, errorBuilder: (BuildContext context,
                          Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      "assests/nophoto.png",
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      fit: BoxFit.cover,
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(color: Colors.white, blurRadius: 6)
                              ],
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 28,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            provider.toggleFavourite(
                                _attractionDetail!['result']['place_id']);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(color: Colors.white, blurRadius: 6)
                              ],
                            ),
                            child: Icon(
                              provider.isExist(
                                      _attractionDetail!['result']['place_id'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 253, 249, 241),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _attractionDetail!['result']['place_name'],
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Color(0xFF41C9E2),
                                      ),
                                      Text(
                                        _attractionDetail!['result']['location']
                                            ['province'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    'รายละเอียด',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    PrintDetail(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    // textAlign: TextAlign.justify,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
