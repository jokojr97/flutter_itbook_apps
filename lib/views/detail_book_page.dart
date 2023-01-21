import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});

  final String isbn;
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  //ambil dari model
  BookDetailResponse? detailBook;
  fetchDetailBookAPI() async {
    // var url = Uri.https('api.itbook.store/1.0/new');
    var url = Uri.https('api.itbook.store', '1.0/books/${widget.isbn!}');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      //akses model
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetailBookAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Detail Book")),
        ),
        body: detailBook == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(detailBook!.subtitle!),
                              Text(detailBook!.title!),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(detailBook!.price!),
                  Text(detailBook!.rating!),
                  Text(detailBook!.isbn10!),
                  Text(detailBook!.isbn13!),
                  Text(detailBook!.pages!),
                  Text(detailBook!.publisher!),
                  Text(detailBook!.year!),
                  Text(detailBook!.url!),
                  Text(detailBook!.authors!),
                  Text(detailBook!.desc!),
                  Text(detailBook!.subtitle!),
                ],
              ));
  }
}
