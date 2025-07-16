import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsImage, title, description, content, dateTime, source;
  const NewsDetailScreen({super.key,
    required this.newsImage,
    required this.title,
    required this.description,
    required this.content,
    required this.dateTime,
    required this.source
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final formate = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    DateTime publishDate = DateTime.parse(widget.dateTime);
    print(widget.content);
    final imageUrl = widget.newsImage.trim();
    final uri = Uri.tryParse(imageUrl);
    final isValidUrl = uri != null &&
        uri.hasAbsolutePath &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.4,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20) , topLeft: Radius.circular(20)),
              child: CachedNetworkImage(
                  imageUrl: isValidUrl
                  ? imageUrl
                      : 'https://dummyimage.com/600x400/cccccc/000000&text=No+Image',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(child: SpinKitFadingCircle(color: Colors.tealAccent,)),
                  errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.redAccent,)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.source,
                  style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.bold,color: Colors.black54)),
              Text(formate.format(publishDate),
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black54)),
            ],
          ),
          Divider(),
          Text(widget.title,
              style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w600,color: Colors.black87)),
          Text(widget.description,
              style: GoogleFonts.poppins(fontSize: 18)),
          Text(widget.content,
              style: GoogleFonts.poppins(fontSize: 18)),
        ],
      ),
    );
  }
}
