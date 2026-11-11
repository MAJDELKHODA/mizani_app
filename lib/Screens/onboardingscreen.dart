import 'package:flutter/material.dart';

import 'loginscreen.dart';


class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});


  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();

}



class _OnboardingScreenState extends State<OnboardingScreen> {


  final PageController controller = PageController();


  int currentIndex = 0;



  final List<Map<String,String>> pages = [


    {

      "image":"images/onboarding1.png",

      "title":"تحكم بمصروفك بسهولة",

      "description":
      "سجل مصاريفك اليومية واعرف أين تذهب أموالك بكل وضوح."

    },


    {

      "image":"images/onboarding2.png",

      "title":"حدد ميزانيتك اليومية",

      "description":
      "ضع حدًا للصرف وتابع المبلغ المتبقي لك خلال اليوم."

    },


    {

      "image":"images/onboarding3.png",

      "title":"افهم عادات إنفاقك",

      "description":
      "شاهد تقاريرك الشهرية وساعد نفسك على تنظيم أموالك بشكل أفضل."

    },


  ];





  void nextPage(){


    if(currentIndex == pages.length - 1){


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (context)=>
          const LoginScreen(),

        ),

      );


    }else{


      controller.nextPage(

        duration:
        const Duration(milliseconds:400),

        curve:
        Curves.easeInOut,

      );


    }

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xffFAF7FF),



      body: SafeArea(


        child: Column(


          children: [



            Expanded(


              child: PageView.builder(


                controller: controller,


                itemCount: pages.length,


                onPageChanged:(index){


                  setState(() {

                    currentIndex=index;

                  });


                },


                itemBuilder:(context,index){


                  return Column(


                    mainAxisAlignment:
                    MainAxisAlignment.center,


                    children: [



                      Image.asset(


                        pages[index]["image"]!,


                        height:320,


                        fit:BoxFit.contain,


                      ),




                      const SizedBox(height:35),





                      Text(


                        pages[index]["title"]!,


                        textAlign:
                        TextAlign.center,


                        style:
                        const TextStyle(


                          fontSize:28,

                          fontWeight:
                          FontWeight.bold,



                          color:
                          Color(0xff43258A),


                        ),


                      ),




                      const SizedBox(height:15),





                      Padding(


                        padding:
                        const EdgeInsets.symmetric(
                          horizontal:40,
                        ),



                        child:Text(


                          pages[index]["description"]!,


                          textAlign:
                          TextAlign.center,


                          style:
                          const TextStyle(


                            fontSize:16,



                            height:1.7,


                            color:
                            Color(0xff76658F),


                          ),


                        ),


                      ),



                    ],


                  );


                },


              ),


            ),





            // Indicators


            Row(


              mainAxisAlignment:
              MainAxisAlignment.center,


              children:List.generate(


                pages.length,


                    (index){


                  return AnimatedContainer(


                    duration:
                    const Duration(
                        milliseconds:300
                    ),



                    margin:
                    const EdgeInsets.symmetric(
                      horizontal:5,
                    ),



                    width:
                    currentIndex == index
                        ?28
                        :8,



                    height:8,



                    decoration:
                    BoxDecoration(


                      color:
                      currentIndex == index
                          ?
                      const Color(0xff7B4DDB)
                          :
                      const Color(0xffD8C9F5),



                      borderRadius:
                      BorderRadius.circular(20),


                    ),


                  );


                },

              ),


            ),





            const SizedBox(height:30),






            Padding(


              padding:
              const EdgeInsets.symmetric(
                horizontal:25,
              ),



              child:SizedBox(


                width:
                double.infinity,


                height:55,



                child:
                ElevatedButton(


                  onPressed:
                  nextPage,



                  style:
                  ElevatedButton.styleFrom(


                    backgroundColor:
                    const Color(0xff7B4DDB),



                    elevation:0,



                    shape:
                    RoundedRectangleBorder(


                      borderRadius:
                      BorderRadius.circular(18),


                    ),


                  ),



                  child:
                  Text(


                    currentIndex ==
                        pages.length-1

                        ?
                    "ابدأ الآن"

                        :
                    "التالي",



                    style:
                    const TextStyle(


                      color:
                      Colors.white,


                      fontSize:18,


                      fontWeight:
                      FontWeight.bold,


                    ),


                  ),



                ),


              ),


            ),




            const SizedBox(height:25),


          ],


        ),


      ),


    );


  }

}