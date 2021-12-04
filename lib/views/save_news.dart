import 'package:flutter/material.dart';
import 'package:news_reboot/models/article_model.dart';
import 'article_view.dart';
import 'home.dart';



class SaveNews extends StatefulWidget {
  const SaveNews({Key? key}) : super(key: key);

  @override
  _SaveNewsState createState() => _SaveNewsState();
}

class _SaveNewsState extends State<SaveNews> {
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getSaveNews();
  }

  getSaveNews() async{
    articles= save;
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
                    if(articles[index].urlToImage == "" || articles[index].description == "")
                      return Container();
                    return BlogTile2(
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


class BlogTile2 extends StatelessWidget {
  final String? imageUrl, title, desc,url;
  final String? s="";
  BlogTile2({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});
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
      onDoubleTap: (){
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Article Will be Removed!!')),
        );
        for (var i = 0; i < save.length; i++) {
          {
            if(save[i].urlToImage==imageUrl)
              {
                save[i].urlToImage="";
                save[i].description="";
              }
          }
        }
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
