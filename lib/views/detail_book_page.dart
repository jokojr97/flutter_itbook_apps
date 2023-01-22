import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});

  final String isbn;
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  //ambil dari model
  BookDetailResponse? detailBook;
  fetchDetailBooksAPI() async {
    // var url = Uri.https('api.itbook.store/1.0/new');
    var url = Uri.https('api.itbook.store', '1.0/books/${widget.isbn}');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      //akses model
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});

      fetchSimilarBooksAPI(detailBook!.title!);
    }
  }

  BookListResponse? similarBooks;
  fetchSimilarBooksAPI(String title) async {
    // var url = Uri.https('api.itbook.store/1.0/new');
    var url = Uri.https('api.itbook.store', '1.0/search/${title}');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    if (response.statusCode == 200) {
      final jsonSearch = jsonDecode(response.body);
      //akses model
      // detailBook = BookListResponse.fromJson(jsonDetail);
      similarBooks = BookListResponse.fromJson(jsonSearch);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetailBooksAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Detail Book")),
        ),
        body: detailBook == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ImageViewScreen(url: detailBook!.image!),
                              ),
                            );
                          },
                          child: Image.network(
                            detailBook!.image!,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailBook!.title!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                detailBook!.authors!,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Row(
                                  children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: index < int.parse(detailBook!.rating!)
                                      ? Colors.yellow
                                      : Colors.grey,
                                ),
                              )),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                detailBook!.subtitle!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                detailBook!.price!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.infinity, 30),
                          ),
                          onPressed: () async {
                            // Navigator.push(context, MaterialPageRoute(builder: ))
                            Uri uri = Uri.parse(detailBook!.url!);
                            try {
                              (await canLaunchUrl(uri))
                                  ? launchUrl(uri)
                                  : print("tidak bisa melakukan redirect");
                            } catch (e) {
                              print("error");
                              print(e);
                            }
                          },
                          child: const Text("Buy")),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      detailBook!.desc!,
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Year: " + detailBook!.year!,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "ISBN" + detailBook!.isbn13!,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          detailBook!.pages! + " pages",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Publisher: " + detailBook!.publisher!,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Language: " + detailBook!.language!,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Divider(),
                    similarBooks == null
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            height: 120,
                            child: ListView.builder(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: similarBooks!.books!.length,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final currentSimilarBook =
                                    similarBooks!.books![index];
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          currentSimilarBook.image!,
                                          height: 80,
                                        ),
                                        Center(
                                          child: Text(
                                            currentSimilarBook.title!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              ));
  }
}
