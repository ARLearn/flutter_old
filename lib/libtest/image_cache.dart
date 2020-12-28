import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCacheRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image cache Route'),
      ),
      body: Center(
        child:Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            RaisedButton(
              child: Text('Go back!'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
//            new Image(
//                fit: BoxFit.cover,
//                height: 150.0,
//                width: 150.0,
//                image:
//                new CachedNetworkImageProvider(
//                  //gs://arlearn-eu.appspot.com/game/6060901594562560/generalItems/4523830778265600/background.jpg
//                  "https://storage.googleapis.com/arlearn-eu.appspot.com/game/6060901594562560/generalItems/4523830778265600/background.jpg",
////                      placeholder: (context, url) => new CircularProgressIndicator(),
////                      errorWidget: (context, url, error) => new Icon(Icons.error),
//                )),
          ],
        ),



      ),
    );
  }
}
