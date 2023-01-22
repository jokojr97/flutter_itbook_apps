import 'dart:convert';

import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/book_detail_response.dart';

class BookController extends ChangeNotifier {
  BookListResponse? bookList;
  fetchBookAPI() async {
    // var url = Uri.https('api.itbook.store/1.0/new');
    var url = Uri.https('api.itbook.store', '1.0/new');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      notifyListeners();
    }

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  //ambil dari model
  BookDetailResponse? detailBook;
  fetchDetailBooksAPI(isbn) async {
    // var url = Uri.https('api.itbook.store/1.0/new');
    var url = Uri.https('api.itbook.store', '1.0/books/${isbn}');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      //akses model
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      notifyListeners();

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
      notifyListeners();
    }
  }
}
