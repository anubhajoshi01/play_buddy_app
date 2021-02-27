import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frc_challenge_app/components/bottomNavBar.dart';
import 'package:frc_challenge_app/components/common_app_bar.dart';
import 'package:frc_challenge_app/db_services/post_db.dart';

class ViewCategoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("view category : ${PostDb.categoryList.length}");
    return Scaffold(
      appBar: CommonAppBar.appBar("View Categories", context),
      bottomNavigationBar: bottomNavBar(),
      body: Container(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,


              child: ListView.builder(
                  itemCount: PostDb.categoryList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Card(
                          child: ListTile(
                        title: Text(
                          PostDb.categoryList.elementAt(index),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                            subtitle: Text(
                              "events: ${PostDb.categoryMap[PostDb.categoryList.elementAt(index)].length}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                      )),
                    );
                  }),
            ),
      ),
    );
  }
}
