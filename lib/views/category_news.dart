import 'package:flutter/material.dart';
import 'package:news_reboot/helper/news.dart';
import 'package:news_reboot/models/article_model.dart';

import 'article_view.dart';

class CategoryNews extends StatefulWidget {
final String? category;
CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}



class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles =[];
  bool _loading=true;
  @override
  void initState() {
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async{
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category.toString());
    articles = newsClass.news;
    setState(() {
      _loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "Reboot",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.share,))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body:  _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) :SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ///Blogs
              Container(
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,index){
                    return BlogTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      desc: articles[index].description,
                      url:articles[index].url,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String? imageUrl, title, desc,url;
  BlogTile({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(context,MaterialPageRoute(
            builder:(context)=>ArticleView(
              postUrl: url,
            ) )
        );
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(imageUrl.toString())
              ),
              SizedBox(height: 8,),
              //Image(image: NetworkImageWithRetry(imageUrl.toString())),
              Text(title.toString(),style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              )),
              SizedBox(height: 8,),
              Text(desc.toString(),style: TextStyle(
                color: Colors.black54,
              )),
            ],
          )
      ),
    );
  }
}