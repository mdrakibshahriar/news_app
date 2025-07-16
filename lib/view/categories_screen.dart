import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_news_model.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'general';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      categoryName = categoriesList[index];
                      setState(() {

                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index]? Colors.teal.shade800 : Colors.teal.shade400,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(child: Text(categoriesList[index].toString(),
                          style: GoogleFonts.workSans(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),)),
                        ),
                      ),
                    ),
                  );
                },
            ),
          ),
          SizedBox(height: height * 0.01,),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesChannelApi(categoryName),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return SpinKitCircle(color: Colors.teal,size: 45);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data?.articles == null || snapshot.data!.articles!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  else{
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        final imageUrl = snapshot.data!.articles![index].urlToImage;
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(
                                  newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  title: snapshot.data!.articles![index].title.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  dateTime: snapshot.data!.articles![index].publishedAt.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString()
                              )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0,vertical: 5),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: height * 0.2,
                                      width: width * 0.3,
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl.toString(),
                                          // imageUrl: (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null')
                                          //     ? imageUrl
                                          //     : 'https://dummyimage.com/600x400/cccccc/000000&text=No+Image',
                                        placeholder: (context, url) => SpinKitFadingCircle(size: 25,color: Colors.tealAccent,),
                                        errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.redAccent,),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.01,),
                                  Container(
                                    height: height * 0.18,
                                    width: width * 0.6,
                                    child: Column(
                                      children: [
                                        Text(snapshot.data!.articles![index].title.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 13,),),
                                            ),
                                            Text(format.format(dateTime),
                                              style: GoogleFonts.poppins(fontSize: 13, ),),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                    );
                  }
                },
            ),
          )
        ],
      ),
    );
  }
}
