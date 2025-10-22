import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/fullscreen.dart';


void main() {
  runApp(WallPaper());
}


class WallPaper extends StatefulWidget{

  
  @override
  _WallPaperState createState() => _WallPaperState();
   
  }

class _WallPaperState extends State<WallPaper>{
  List images = [];
  int page = 1;
  @override 
  void initState(){
    super.initState();
    fetchapi();
  }

  fetchapi() async{
    const String apiKey = 'pVte1ICQtuPFl2ZJqd5c1X5kCT2sFOdbHktWgzhwUTQXmfLYp6EwRRPz';
    const String apiUrl = "https://api.pexels.com/v1/curated?per_page=80";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": apiKey,
      },
    );

      if(response.statusCode == 200){
        print("sucess..");
         final Map<String, dynamic>  data = json.decode(response.body);
    setState(() {
        images = data["photos"];
       
      });
        print(images[0]['src']['tiny']);
      }else {
      print("Failed to load images: ${response.statusCode}");
      }
  }

   loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();

    await http.get(Uri.parse(url), headers: {'Authorization': 'pVte1ICQtuPFl2ZJqd5c1X5kCT2sFOdbHktWgzhwUTQXmfLYp6EwRRPz'}).then(
        (value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

          body: Column(
            children: [
                Expanded(
                  child: Container(
                  
                    child: GridView.builder(
                      itemCount: 2000,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  
                        crossAxisSpacing: 3,
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 4,
                        mainAxisSpacing: 3
                        ) , 
                      itemBuilder: (context ,index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, 
                            MaterialPageRoute(builder:
                             (context)=>FullScreen(
                              imageurl:images[index]['src']['large2x'],
                             )),
                            );
                          },
                          child: Container(
                            color: Colors.blueGrey,
                            child: Image.network(
                              images[index]['src']['tiny'],
                              fit: BoxFit.cover,
                            ),
                          
                          ),
                        );
                      }
                      ),
                  ),
                ),



                 InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: Text('Load More',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          )


            ],


          )

    );





  }

}
