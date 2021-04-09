import 'package:flutter_map/flutter_map.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


Future createDynamicLink(String code,String name) async {
  // print("create dynamic llinked called");
  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://adityabeacon.page.link',
      link: Uri.parse('https://adityabhaumik.github.io/beaconTest/?id=$code'),
      androidParameters: AndroidParameters(
          packageName: "com.aditya.beacon",
          minimumVersion: 21
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Gretel',
          description: 'Click on the Link to Follow Your Friend $name'
      )
  );

  var url;
  url = await parameters.buildUrl();
  // ShortDynamicLink shortLink = await parameters.buildShortLink();
  // url = shortLink.shortUrl;
  // print("${url.toString()} anything");
  return url.toString();
}

