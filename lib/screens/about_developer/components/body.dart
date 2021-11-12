import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/AppReview.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/app_review_database_helper.dart';
import 'package:e_commerce_app_flutter/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_review_dialog.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "About Developer",
                  style: headingStyle,
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                InkWell(
                  onTap: () async {
                    const String linkedInUrl =
                        "https://www.linkedin.com/in/owolabi-adebayo-stephen-mnse-3690a6b5/";
                    await launchUrl(linkedInUrl);
                  },
                  child: CircleAvatar(
                      radius: SizeConfig.screenWidth * 0.2,
                      backgroundColor: Colors.white,
                      // foregroundImage:
                      //     NetworkImage(),

                      child: Image.asset("assets/images/developer.jpg")),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  '"Owolabi Adebayo"',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Abuja,Nigeria',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "I'm MERN Stack Developer, Python Developer(Django), Data Science and Machine Learning Enthusiast and Flutter Developer Love Using My Coding Skills to Solve Problem",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/github_icon.svg",
                        color: Colors.black.withOpacity(0.55),
                      ),
                      color: Colors.black.withOpacity(0.75),
                      iconSize: 30,
                      padding: EdgeInsets.all(16),
                      onPressed: () async {
                        const String githubUrl =
                            "https://github.com/owolabiadebayo";
                        await launchUrl(githubUrl);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/linkedin_icon.svg",
                        color: Colors.lightBlue.withOpacity(0.65),
                      ),
                      iconSize: 30,
                      padding: EdgeInsets.all(16),
                      onPressed: () async {
                        const String linkedInUrl =
                            "https://www.linkedin.com/in/owolabi-adebayo-stephen-mnse-3690a6b5/";
                        await launchUrl(linkedInUrl);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/instagram_icon.svg",
                          color: Colors.redAccent[700].withOpacity(0.75)),
                      iconSize: 30,
                      padding: EdgeInsets.all(16),
                      onPressed: () async {
                        const String instaUrl =
                            "https://www.instagram.com/gmtsoftware";
                        await launchUrl(instaUrl);
                      },
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        submitAppReview(context, liked: true);
                      },
                    ),
                    Text(
                      "Liked the app?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down),
                      padding: EdgeInsets.all(16),
                      color: kTextColor.withOpacity(0.75),
                      iconSize: 50,
                      onPressed: () {
                        submitAppReview(context, liked: false);
                      },
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildDeveloperAvatar() {
  //   return FutureBuilder<String>(
  //       // future: FirestoreFilesAccess().getDeveloperImage(),
  //       builder: (context, snapshot) {
  //     if (snapshot.hasData) {
  //       final url = snapshot.data;
  //       return CircleAvatar(
  //           radius: SizeConfig.screenWidth * 0.3,
  //           // backgroundColor: kTextColor.withOpacity(0.75),
  //           // foregroundImage: AssetImage(),
  //           child: Image.asset("assets/images/developer.jpeg"));
  //     } else if (snapshot.hasError) {
  //       final error = snapshot.error.toString();
  //       Logger().e(error);
  //     }
  //     return CircleAvatar(
  //       radius: SizeConfig.screenWidth * 0.1,
  //       backgroundColor: kTextColor.withOpacity(0.75),
  //     );
  //   });
  // }

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Logger().i("LinkedIn URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context,
      {bool liked = true}) async {
    AppReview prevReview;
    try {
      prevReview = await AppReviewDatabaseHelper().getAppReviewOfCurrentUser();
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
    } catch (e) {
      Logger().w("Unknown Exception: $e");
    } finally {
      if (prevReview == null) {
        prevReview = AppReview(
          AuthentificationService().currentUser.uid,
          liked: liked,
          feedback: "",
        );
      }
    }

    final AppReview result = await showDialog(
      context: context,
      builder: (context) {
        return AppReviewDialog(
          appReview: prevReview,
        );
      },
    );
    if (result != null) {
      result.liked = liked;
      bool reviewAdded = false;
      String snackbarMessage;
      try {
        reviewAdded = await AppReviewDatabaseHelper().editAppReview(result);
        if (reviewAdded == true) {
          snackbarMessage = "Feedback submitted successfully";
        } else {
          throw "Coulnd't add feeback due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = e.toString();
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}
