# frc_challenge_app

An app to encourage physical activity in youth. Allows users to create an account and create/sign-up for sports events in their area. Made for the innovation challenge on behalf of FRC team 7476

The COVID-19 pandemic has been a burden in the lives of many. It has heavily impacted not only our mental health, but our physical health as well. Staying physically active during a time of social distancing and lockdown can be very difficult. It is even more detrimental for those who lack the motivation. Global lockdowns have forced individuals to spend hours on video conferences and virtual meetings. Even children who are accustomed to daily recess breaks and socializing with friends are stuck sitting behind screens in boredom. Teens may feel isolated and are looking for ways to have fun, apart from online video games. While bringing the spread of the virus to a halt, research has shown that throughout the world, rapid decreases in amounts of daily exercise have occured ever since lockdown measures were put in place. Physical activity is known to improve quality of life, whether it be through its numerous physical or mental health benefits. Having one of life’s essential amenities barred has caused many complications in the lives of many. That is why team 7476 wants to put an emphasis on this problem with our creative solution.

One of the best ways to motivate physical activity is to have somebody to be alongside you. Whether they motivate you, keep you focussed, or make the activity more fun, our product will solve the barrier for motivation to go outside with the incentive to have someone along with you. When brainstorming ideas, we came to the conclusion that people are all motivated differently. Making an app that encourages competition can dismiss people working out for fun or at their own pace. Conversely, people with no commitment to go outside will choose not to participate in physical activity. With this in mind, we created a service app which works for people of all ages and mindsets when working out, so they can match with people of similar interests and feel welcomed. By matching people with similar fitness goals, a strong tight knit community is formed, and we hope this incentivizes people to become physically active, which in turn improves mental health. 

Libraries/ Components:

1) Flutter SDK: The entire project was programmed in the Dart language using Flutter SDK
2) Firebase Auth: Used built in menthods from Firebase Auth for login/signup and storing user credentials
3) Firebase Firestore: Was used as a abacked aspect to store Users and Posts or sports activites as objects with the required fields and values.
4) Hive: Was used as a local database to store currently logged in user information
5) Geolocator: Used the geolocator library to convert address to latitude/longitude and vice versa. Also used it to get current user location.
6) Google Maps API: Used it to code the map view and interaction

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
