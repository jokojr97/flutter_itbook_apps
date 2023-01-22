import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.isbn});

  final String isbn;
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? bookController;
  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetchDetailBooksAPI(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Detail Book")),
        ),
        body: Consumer<BookController>(builder: (context, contoller, child) {
          return bookController!.detailBook == null
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
                                  builder: (context) => ImageViewScreen(
                                      url: bookController!.detailBook!.image!),
                                ),
                              );
                            },
                            child: Image.network(
                              bookController!.detailBook!.image!,
                              height: 150,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookController!.detailBook!.title!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  bookController!.detailBook!.authors!,
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
                                    color: index <
                                            int.parse(bookController!
                                                .detailBook!.rating!)
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                )),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  bookController!.detailBook!.subtitle!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  bookController!.detailBook!.price!,
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
                              Uri uri =
                                  Uri.parse(bookController!.detailBook!.url!);
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
                        bookController!.detailBook!.desc!,
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Year: " + bookController!.detailBook!.year!,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "ISBN" + bookController!.detailBook!.isbn13!,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            bookController!.detailBook!.pages! + " pages",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Publisher: " +
                                bookController!.detailBook!.publisher!,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Language: " +
                                bookController!.detailBook!.language!,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Divider(),
                      Consumer<BookController>(
                          builder: (context, controller, child) {
                        return bookController!.similarBooks == null
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                height: 120,
                                child: ListView.builder(
                                  // shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bookController!
                                      .similarBooks!.books!.length,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final currentSimilarBook = bookController!
                                        .similarBooks!.books![index];
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
                              );
                      })
                    ],
                  ),
                );
        }));
  }
}
