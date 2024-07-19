import 'package:flutter/material.dart';
import 'package:campus_market/HomeScreen/home_screen.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSliderScreen extends StatefulWidget {

  final String title, urlImage1, urlImage2;
  final String itemColor, userNumber, description, address, itemPrice;

  ImageSliderScreen({
    required this.title,
    required this.urlImage1,
    required this.urlImage2,
    required this.itemColor,
    required this.userNumber,
    required this.description,
    required this.address,
    required this.itemPrice,

});


  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> with SingleTickerProviderStateMixin {

  static List<String> links = [];
  TabController? tabController;

  getLinks()
  {
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
  }

  @override
  void initState(){
    //TODO: implement initState
    super.initState();
    getLinks();
    tabController = TabController(length: 5, vsync: this);
  }

  String? url;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Colors.lightBlueAccent,],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration:const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.lightBlue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'varela',letterSpacing: 2.0),

          ),
            centerTitle: true,
            leading: IconButton(
                onPressed: ()
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context)=> HomeScreen()));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
        ),
          body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0, left:6.0, right: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_pin, color: Colors.black,),
                            const SizedBox(width: 4.0,),
                            Expanded(
                              child: Text(
                                widget.address,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(fontFamily: 'Verala',fontWeight: FontWeight.bold, letterSpacing: 2.0),

                              ),
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 20.0,),
                    SizedBox(
                      height: size.height * 0.5,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Carousel(
                          indicatorBarColor: Colors.black.withOpacity(0.2),
                          autoScrollDuration: const Duration(seconds: 2),
                          animationPageDuration: const Duration(milliseconds: 500),
                          activateIndicatorColor: Colors.black,
                          animationPageCurve: Curves.easeIn,
                          indicatorBarHeight: 30,
                          indicatorHeight: 10,
                          indicatorWidth: 10,
                          unActivatedIndicatorColor: Colors.grey,
                          stopAtEnd: false,
                          autoScroll: true,
                          items: [
                            Image.network(widget.urlImage1,),
                            Image.network(widget.urlImage2,),
                          ],

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Center(
                        child: Text(
                          'Rs ${widget.itemPrice}',
                          style: const TextStyle(
                            fontSize: 24,
                            letterSpacing: 2.0,
                            fontFamily: 'Bebas',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children:[
                              const Icon(Icons.brush_outlined),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(widget.itemColor),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.phone_android),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(widget.userNumber),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height:20.0),
                    Padding(
                      padding:const EdgeInsets.only(left:15.0,right:15.0),
                      child:Text(
                        widget.description,
                        textAlign:TextAlign.justify,
                        style:TextStyle(
                          color:Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height:20.0),
                    Center(
                      child:ConstrainedBox(
                        constraints:const BoxConstraints.tightFor(width: 368,),
                        child: ElevatedButton(
                          onPressed:()
                          async
                          {
                            url = 'https://www.google.com/maps/place/BMS+College+of+Engineering/@12.9403744,77.5641525,17z/data=!4m6!3m5!1s0x3bae158b11e34d2f:0x5f4adbdbab8bd80f!8m2!3d12.9410122!4d77.5655258!16zL20vMDM5ejcy?entry=ttu';
                            if(await canLaunchUrl(Uri.parse(url!)))
                            {
                              await launchUrl(Uri.parse(url!));
                            }
                            else{
                              throw 'Could not open the map';
                            }
                          },
                          style:ButtonStyle(
                            backgroundColor:MaterialStateProperty.all(Colors.black,),

                          ),
                          child:const Text('Check Seller Location', style: TextStyle(color: Colors.white),),

                        ),
                      ),
                    ),
                    const SizedBox(
                      height:20,
                    ),
                  ],
              ),
          ),
    ),
    );
  }
}
