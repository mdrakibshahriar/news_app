import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_news_model.dart';
import 'package:news_app/model/news_channels_headlines_models.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList {bbcNews, aryNews, abcNews, bbcSports, cnn, alJazeera}
class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  FilterList? selectedMenu;
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset("images/category_icon.png"),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (FilterList item) {
                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.abcNews.name == item.name){
                  name = 'abc-news';
                }
                if(FilterList.bbcSports.name == item.name){
                  name = 'bbc-sport';
                }
                if(FilterList.cnn.name == item.name){
                  name = 'cnn';
                }
                if(FilterList.alJazeera.name == item.name){
                  name = 'al-jazeera-english';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                PopupMenuItem(
                    value: FilterList.bbcNews,
                    child: Text("BBC-NEWS")),
                PopupMenuItem(
                    value: FilterList.aryNews,
                    child: Text("ARY-NEWS")),
                PopupMenuItem(
                    value: FilterList.abcNews,
                    child: Text("ABC-NEWS")),
                PopupMenuItem(
                    value: FilterList.bbcSports,
                    child: Text("BBC-Sports")),
                PopupMenuItem(
                    value: FilterList.cnn,
                    child: Text("CNN-NEWS")),
                PopupMenuItem(
                    value: FilterList.alJazeera,
                    child: Text("AL-JAZEERA-NEWS")),
              ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(size: 60,color: Colors.blue,),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data?.articles == null || snapshot.data!.articles!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      final image = snapshot.data!.articles![index].urlToImage;
                      final imageUrl = image?.trim() ?? '';
                      final uri = Uri.tryParse(imageUrl);
                      final isValidUrl = uri != null &&
                          uri.hasAbsolutePath &&
                          uri.hasScheme &&
                          (uri.scheme == 'http' || uri.scheme == 'https');
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
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: height * .02),
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                        imageUrl: isValidUrl
                                            ? imageUrl
                                            : 'https://dummyimage.com/600x400/cccccc/000000&text=No+Image',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(child: spinkit2,),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.redAccent,)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),

                                    ),
                                    child: Container(
                                      height: height * 0.2,
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.acme(fontSize: 13, fontWeight: FontWeight.w600),),
                                                SizedBox(width: width * .2,),

                                                Text(format.format(dateTime),
                                                  style: GoogleFonts.acme(fontSize: 12, fontWeight: FontWeight.w500),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                  );
                }
            },),
          ),
          SizedBox(height: height * 0.01,),
          FutureBuilder<CategoriesNewsModel>(
            future: newsViewModel.fetchCategoriesChannelApi('general'),
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
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
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
                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: height * 0.18,
                                width: width * 0.28,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
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
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(snapshot.data!.articles![index].source!.name.toString(),
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
        ],
      ),
    );
  }

}
const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);