import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_reboot/helper/data.dart';
import 'package:news_reboot/helper/news.dart';
import 'package:news_reboot/models/article_model.dart';
import 'package:news_reboot/models/category_model.dart';
import 'package:news_reboot/screens/sign_in_screen.dart';
import 'package:news_reboot/utils/authentication.dart';
import 'package:news_reboot/views/article_view.dart';
import 'package:news_reboot/views/category_news.dart';
import 'package:news_reboot/views/save_news.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

List<ArticleModel> save =[];

class _HomeState extends State<Home> {

  List<CategoryModel> categories = [];
  List<ArticleModel> articles =[];
  bool _loading = true;
  bool _isSigningOut = false;


  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: new IconTheme(
            data: new IconThemeData(
                color: Colors.black),
            child: new IconButton(
              icon: new Icon(Icons.save),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>SaveNews(),
                ));
              },
            ),
          ),
        ),

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
            child: new IconTheme(
              data: new IconThemeData(
                  color: Colors.black),
              child: new IconButton(
                icon: new Icon(Icons.logout),
                onPressed: () async{
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context)
                      .pushReplacement(_routeToSignInScreen());
                },
              ),
            ),
          ),
        ],
        //backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),

      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:Column(
            children: [
              ///Categories
              Container(
                height: 70,
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return CategoryTile(
                      imageUrl:categories[index].imageUrl,
                      categoryName: categories[index].categoryName,
                    );
                }),
              ),
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
          ) ,
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {

  final String? imageUrl, categoryName;
  CategoryTile({this.imageUrl,this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) =>CategoryNews(
            category: categoryName.toString().toLowerCase(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right:16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl.toString(),width: 120, height: 60,fit: BoxFit.cover,
                ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120, height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(categoryName.toString(), style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),),
            )
          ],
        ),
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  final String? imageUrl, title, desc,url;
  final String? s="";
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
      onDoubleTap: (){
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Article Saved!!')),
        );
        ArticleModel art=ArticleModel(
          s,
          title,
          url,
          desc,
          s,
          imageUrl
        );
        save.add(art);
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
