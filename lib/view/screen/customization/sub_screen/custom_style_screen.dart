import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/customize_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/custom_appbar.dart';
import 'package:nurserygardenapp/view/base/page_loading.dart';
import 'package:provider/provider.dart';

class CustomStyleScreen extends StatefulWidget {
  const CustomStyleScreen({super.key});

  @override
  State<CustomStyleScreen> createState() => _CustomStyleScreenState();
}

class _CustomStyleScreenState extends State<CustomStyleScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;
    TextStyle _title = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: ColorResources.COLOR_BLACK.withOpacity(0.8),
    );
    TextStyle _subTitle = theme.headlineMedium!.copyWith(
      fontSize: Dimensions.FONT_SIZE_DEFAULT,
      color: const Color.fromRGBO(45, 45, 45, 1).withOpacity(0.6),
    );

    return Scaffold(
      appBar: CustomAppBar(
        isCenter: false,
        isBgPrimaryColor: true,
        title: 'Select the Style',
        isBackButtonExist: false,
        context: context,
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Consumer<CustomizeProvider>(
            builder: (context, customProvider, child) {
              return customProvider.isFetching &&
                      customProvider.customList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.3,
                          height: 15,
                          color: Colors.grey[400],
                        ),
                        LoadingThreeCircle(),
                      ],
                    )
                  : customProvider.customList.isEmpty &&
                          !customProvider.isLoading
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'No Customize Data Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose the style you prefer',
                              style: _title,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              // color: Colors.white,
                              width: double.infinity,
                              height: size.height * 0.8,
                              // height: size.height * 0.5,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: customProvider.customList.length,
                                  itemBuilder: (context, index) {
                                    if (index >=
                                        customProvider.customList.length) {
                                      return LoadingThreeCircle();
                                    } else if (index >=
                                        customProvider.customList.length) {
                                      // return Container(
                                      //   height: 50,
                                      // );
                                    } else {
                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  customProvider.item_url =
                                                      customProvider
                                                              .customList[index]
                                                              .videoUrl ??
                                                          '';
                                                });
                                                Navigator.pushNamed(
                                                    context,
                                                    Routes
                                                        .getCustomizationShowRoute());
                                              },
                                              child: Container(
                                                height: size.height * 0.7,
                                                width: size.width * 0.9,
                                                child: CachedNetworkImage(
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  imageUrl:
                                                      "${customProvider.customList[index].imageUrl}",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 20,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ],
                        );
            },
          )),
    );
  }
}
