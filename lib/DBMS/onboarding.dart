import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import 'login.dart';

class OnboardingScreen extends StatelessWidget {
  final list=[
    PageModel(
        widget: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Image.asset("assets/database.png"),
                height: 210,
              ),
              Container(
                alignment:Alignment.center,
                child: Text("Learn DBMS",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23
                ),textAlign: TextAlign.center),
                margin: EdgeInsets.only(bottom: 15,top: 20),
                width: double.infinity,
              ),
              Container(
                alignment:Alignment.center,
                child: Text("Learn DBMS to create your own databases as per their requirement.",
                    style: TextStyle(
                        fontSize: 20
                    ),textAlign: TextAlign.center),
                width: double.infinity,
              ),
            ],
          ),
        )
    ),
    PageModel(
        widget: Column(
          children: [
            Container(
              child:Image.asset("assets/favorite.png"),
              height: 220,
              //width: 300,
              margin: EdgeInsets.only(top:40,bottom: 20),
            ),
            Container(
              alignment:Alignment.center,
              child: Text("Favourite Topics",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23
              ),textAlign: TextAlign.center),
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 15),
            ),
            Container(
              alignment:Alignment.center,
              child: Text("Mark your favorite topics with a single tap.",
                  style: TextStyle(
                      fontSize: 20
                  ),textAlign: TextAlign.center),
              width: double.infinity,
            ),
          ],
        )
    ),
    PageModel(
        widget: Column(
          children: [
            Container(
              child: Image.asset("assets/search.png"),
              height: 220,
              //width: 270,
              margin: EdgeInsets.only(top:40,bottom: 20),
            ),
            Container(
              alignment:Alignment.center,
              child: Text("Search Topics",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23
              ),),
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 15),
            ),
            Container(
              alignment:Alignment.center,
              child: Text("Browse through different topics and search them easily.",
                style: TextStyle(
                    fontSize: 20
                ),),
              width: double.infinity,
            ),
          ],
        )
    ),
    PageModel(
        widget: Column(
          children: [
            Container(
              child: Image.asset("assets/reading.png"),
              height: 220,
              //width: 300,
              margin: EdgeInsets.only(top:40,bottom: 20),
            ),
            Container(
              alignment:Alignment.center,
              child: Text("Kickstart Your Journey",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23
              ),textAlign: TextAlign.center),
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 15),
            ),
            Container(
              alignment:Alignment.center,
              child: Text("Never stop learning, because life never stops teaching.",
                style: TextStyle(
                    fontSize: 20
                ),textAlign: TextAlign.center,),
              width: double.infinity,
            ),
          ],
        )
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Onboarding(
        skipButtonStyle: SkipButtonStyle(
          skipButtonColor: Colors.deepPurple.shade400,
          skipButtonPadding: EdgeInsets.all(10),
          skipButtonText: Text("Skip",
            style: TextStyle(
                color: Colors.white,
                fontSize: 21
            ),),
        ),
        footerPadding: EdgeInsets.only(bottom: 50,left: 40,right: 25),
        background: Colors.white,
        proceedButtonStyle: ProceedButtonStyle(
            proceedButtonColor: Colors.blue.shade900,
            proceedButtonPadding: EdgeInsets.all(10),
            proceedpButtonText: Text("Start",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21
              ),),
            proceedButtonRoute: (context){
              return Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                      (route) => false);
            }),
        pages: list,
        indicator: Indicator(
            closedIndicator: ClosedIndicator(color: Colors.blue),
            activeIndicator: ActiveIndicator(color: Colors.black,borderWidth: 1.5),
            indicatorDesign: IndicatorDesign.polygon(
                polygonDesign: PolygonDesign(
                    polygon: DesignType.polygon_diamond
                ))
        ),

      ),
    );
  }
}
