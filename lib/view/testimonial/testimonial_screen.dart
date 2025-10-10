import 'package:fat_end_fit/service/api_config.dart';
import 'package:fat_end_fit/utils/app_loader.dart';
import 'package:fat_end_fit/utils/app_strings.dart';
import 'package:fat_end_fit/utils/common/app_image.dart';
import 'package:fat_end_fit/utils/common/app_video.dart';
import 'package:fat_end_fit/utils/common_function.dart';
import 'package:fat_end_fit/view/testimonial/testimonial_controller.dart';
import 'package:fat_end_fit/view/testimonial/widget/reels_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/common/app_text.dart';
import 'model/video_model.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key});

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  final controller = Get.put(TestimonialController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchTestimonials();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Center(
                child: AppText(
                  AppString.testimonial,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textBlack,
                ),
              ),
              SizedBox(height: getSize(16, isHeight: true)),

              Obx(() {
                if (controller.isLoading.value) {
                  return Align(alignment: Alignment.center,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: Get.height * 0.35),
                        AppLoaderWidget(),
                      ],
                    ),
                  );
                }

                final testimonial = controller.testimonial.value;
                if (testimonial == null) {
                  return Align(alignment: Alignment.center,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: Get.height * 0.35),
                        Center(child: Text("No testimonials found")),
                      ],
                    ),
                  );/*const Center(child: Text("No testimonials found"));*/
                }
                print("controller.testimonial.value?.titleVideo--->${controller.testimonial.value?.titleVideo}");

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(controller.testimonial.value?.titleVideo != null && controller.testimonial.value?.titleVideo != "")
                    SectionHeader(title: controller.testimonial.value?.titleVideo ?? AppString.whatIsBodyDetoxification),
                    const SizedBox(height: 12),

                    // Fake Video/Image
                    Container(
                      height: Get.height * 0.24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // image: const DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: AssetImage("assets/images/detox_placeholder.jpg"),
                        // ),
                      ),
                      // child: ClipRRect(borderRadius: BorderRadius.circular(12),child: AppImage.network("https://media.istockphoto.com/id/1409431800/vector/video-player-interface-isolated-on-white-background-video-streaming-template-mockup-live.jpg?s=612x612&w=0&k=20&c=c4Ukls95CaoQhgYnKVFvdhcngAA6hEMAnORTWYPn4cY=",width: Get.width)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomVideoPlayer(
                            initialSeconds: 0,
                            thumbnailUrl: getImageUrl(controller.testimonial.value?.thumUrl),
                            // videoUrl: "https://cdn.pixabay.com/video/2023/02/18/151215-800216770_tiny.mp4",
                            videoUrl: getImageUrl(controller.testimonial.value?.urlVideo) ?? "https://cdn.pixabay.com/video/2023/02/18/151215-800216770_tiny.mp4",
                            seekVideoEnabled: true,
                            showNextButton: false,
                            showFullScreenButton: false,
                          )),
                    ),
                    const SizedBox(height: 20),

                    for (var category in testimonial.category) ...[
                      SectionHeader(title: category.categoryTitle),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.list.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final video = category.list[index];
                            return InkWell(
                              onTap: () {
                                final videoList = category.list;
                                Get.to(
                                  () => ReelsPlayerScreen(
                                    videoList: videoList
                                        .map((e) => VideoModel(
                                              description: "",
                                              title: e.title,
                                              /*url: e.videoUrl,
                                  thumbnail: e.thubnail,*/
                                              videoUrl: getImageUrl(e.videoUrl),
                                            ))
                                        .toList(),
                                    initialIndex: index,
                                    heroTag: 'video_${video.videoid}',
                                  ),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              child: Hero(
                                tag: 'video_${video.videoid}',
                                child: ImageCard(
                                  cardText: video.title,
                                  imageUrl: getImageUrl(video.thubnail),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // const SizedBox(height: 20),
                    Text("",style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.010),),
                    ]
                    // ],

                    // Section: Testimonial
                    // SectionHeader(title: "${AppString.testimonial} :"),
                    // const SizedBox(height: 12),

                    // SizedBox(
                    //   height: 220,
                    //   child: Obx(() => ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: controller.testimonials.length,
                    //     separatorBuilder: (_, __) => const SizedBox(width: 8),
                    //     itemBuilder: (context, index) {
                    //       return InkWell(
                    //         onTap: () {
                    //
                    //           final videoList = controller.testimonials.map((data) => VideoModel.fromJson(data))
                    //               .toList();
                    //           Get.to(() => ReelsPlayerScreen(
                    //             videoList: videoList,
                    //             initialIndex: index,
                    //             heroTag: 'video_$index',
                    //           ),
                    //             transition: Transition.fadeIn,
                    //             duration: const Duration(milliseconds: 300),
                    //           );
                    //         },
                    //         child: Hero(
                    //           tag:'video_$index',
                    //           child: ImageCard(
                    //             cardText: controller.testimonials[index]['title'],
                    //             imageUrl: 'https://www.crazyvegankitchen.com/wp-content/uploads/2023/06/mango-juice-recipe.jpg',
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   )),
                    // ),
                    // const SizedBox(height: 20),
                    //
                    // // Section: Cholesterol
                    // SectionHeader(title: "${AppString.cholesterol} :"),
                    // const SizedBox(height: 12),
                    //
                    // SizedBox(
                    //   height: 220,
                    //   child: Obx(() => ListView.separated(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: controller.testimonials.length,
                    //     separatorBuilder: (_, __) => const SizedBox(width: 8),
                    //     itemBuilder: (context, index) {
                    //       return ImageCard(
                    //         cardText: controller.testimonials[index]['title'],
                    //         imageUrl: 'https://www.crazyvegankitchen.com/wp-content/uploads/2023/06/mango-juice-recipe.jpg',
                    //       );
                    //     },
                    //   )),
                    // ),
                  ],
                );
              })
              // Section: What is Body Detoxification ?
            ],
          ),
        ),
      ),
    );
  }
}

/// Common Section Header
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.buttonBlack222222,
        borderRadius: BorderRadius.circular(14),
      ),
      child: AppText(
        title,
        fontSize: getSize(13),
        fontWeight: FontWeight.bold,
        color: AppColor.textWhite,
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String cardText;

  const ImageCard({
    Key? key,
    required this.imageUrl,
    required this.cardText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set a fixed size for the card, you can adjust this
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColor.black),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          // The black gradient overlay from bottom to top
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                gradient: LinearGradient(
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // The text positioned at the bottom
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                cardText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                // Ensure text doesn't overflow
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Common Testimonial Card
class TestimonialCard extends StatelessWidget {
  final String title;
  final String image;

  const TestimonialCard({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: AppImage.network(
                  "https://www.crazyvegankitchen.com/wp-content/uploads/2023/06/mango-juice-recipe.jpg",
                  height: 190,
                  width: 150,
                  fit: BoxFit.cover)),
          const SizedBox(height: 6),
          // Title
          AppText(
            title,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.textBlack,
          ),
        ],
      ),
    );
  }
}

// class aryan{
//   String type = 'panding';
//   List noteData = [];
//
//   onChange({required String whichTypeToChange}){
//      type = whichTypeToChange;
//
//
//      // setState(() {});
//   }
//
//
//
//   Widget hello (){
//     var hnewList = [];
//     if(type == 'all'){
//       // noteData = [];
//       hnewList = noteData;;
//     }else if(type == 'panding'){
//       hnewList = noteData.where((element) {
//         return element['status'] == 'panding';
//       },).toList();
//     }else if(type == 'complate'){
//       hnewList = noteData.where((element) {
//         return element['status'] == 'complate';
//       },).toList();
//     }else if(type == 'cancel'){
//       hnewList = noteData.where((element) {
//         return element['status'] == 'cancel';
//       },).toList();
//     }
//     return Container(child: Row(children: [
//       // button 1 = all type onChange("all")
//       // button 2 = panding type onChange("panding")
//       /// button 3 = complate
//       // button 4 = cancel
//
//       // ListView.build hnewList
//
//     ],),);
//    }
// }