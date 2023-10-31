import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nurserygardenapp/providers/cart_provider.dart';
import 'package:nurserygardenapp/providers/order_provider.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/routes.dart';
import 'package:nurserygardenapp/view/base/circular_indicator.dart';
import 'package:nurserygardenapp/view/screen/payment/payment_helper/payment_type.dart';
import 'package:provider/provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late CartProvider cart_prov =
      Provider.of<CartProvider>(context, listen: false);
  late OrderProvider order_prov =
      Provider.of<OrderProvider>(context, listen: false);
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return _getTotalAmount();
    });
  }

  _getTotalAmount() {
    double total = 0;
    cart_prov.addedCartList.forEach((element) {
      total += element.quantity! * element.price!;
    });
    setState(() {
      totalAmount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorResources.COLOR_PRIMARY,
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.popAndPushNamed(context, Routes.getCartRoute());
              },
            ),
            title: Text(
              "Checkout",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.white),
            )),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            padding: EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey,
                      offset: const Offset(0, 2),
                      blurRadius: 10.0),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorResources.COLOR_WHITE,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Total RM: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: ColorResources.COLOR_BLACK),
                                ),
                                Text(totalAmount.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: ColorResources.COLOR_BLACK))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<OrderProvider>(
                          builder: (context, orderProvider, child) {
                        return GestureDetector(
                          onTap: () async {
                            if (orderProvider.isLoading) return;
                            await orderProvider
                                .addOrder(cart_prov.addedCartList, context)
                                .then((value) {
                              if (value == true) {
                                Navigator.pushReplacementNamed(
                                    context,
                                    Routes.getPaymentRoute(
                                        (PaymentType.card).toString(),
                                        orderProvider.orderIdCreated));
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorResources.COLOR_PRIMARY,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                orderProvider.isLoading
                                    ? CircularProgress()
                                    : Text(
                                        'Place Order',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ]),
            )),
        body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Container(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Address",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Divider(
                      color: ColorResources.COLOR_GREY.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      shrinkWrap: true,
                      itemCount: cartProvider.addedCartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 10.0),
                                      ],
                                    ),
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 120,
                                        width: double.infinity,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            if (cartProvider
                                                    .addedCartList[index]
                                                    .plantId !=
                                                null)
                                              Container(
                                                height: 80,
                                                width: 80,
                                                child: CachedNetworkImage(
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  imageUrl:
                                                      "${cartProvider.getCartPlantList.where((element) {
                                                            return element.id ==
                                                                cartProvider
                                                                    .addedCartList[
                                                                        index]
                                                                    .plantId;
                                                          }).first.imageURL!}",
                                                  memCacheHeight: 200,
                                                  memCacheWidth: 200,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: ColorResources
                                                          .COLOR_GRAY,
                                                    )),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            if (cartProvider
                                                    .addedCartList[index]
                                                    .productId !=
                                                null)
                                              Container(
                                                height: 80,
                                                width: 80,
                                                child: CachedNetworkImage(
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  imageUrl:
                                                      "${"${cartProvider.getCartProductList.where((element) {
                                                            return element.id ==
                                                                cartProvider
                                                                    .addedCartList[
                                                                        index]
                                                                    .productId;
                                                          }).first.imageURL!}"}",
                                                  memCacheHeight: 200,
                                                  memCacheWidth: 200,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: ColorResources
                                                          .COLOR_GRAY,
                                                    )),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (cartProvider
                                                              .addedCartList[
                                                                  index]
                                                              .plantId !=
                                                          null)
                                                        Text(
                                                          "${cartProvider.getCartPlantList.where((element) {
                                                                            return element.id ==
                                                                                cartProvider.addedCartList[index].plantId;
                                                                          }).first.name}"
                                                                      .length >
                                                                  10
                                                              ? "${cartProvider.getCartPlantList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .plantId;
                                                                  }).first.name!.substring(0, 10)}"
                                                              : "${cartProvider.getCartPlantList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .plantId;
                                                                  }).first.name}",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      if (cartProvider
                                                              .addedCartList[
                                                                  index]
                                                              .productId !=
                                                          null)
                                                        Text(
                                                          "${cartProvider.getCartProductList.where((element) {
                                                                            return element.id ==
                                                                                cartProvider.addedCartList[index].productId;
                                                                          }).first.name}"
                                                                      .length >
                                                                  10
                                                              ? "${cartProvider.getCartProductList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .productId;
                                                                  }).first.name!.substring(0, 10)}"
                                                              : "${cartProvider.getCartProductList.where((element) {
                                                                    return element
                                                                            .id ==
                                                                        cartProvider
                                                                            .addedCartList[index]
                                                                            .productId;
                                                                  }).first.name}",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          "Quantity: ${cartProvider.addedCartList[index].quantity}",
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                            "RM" +
                                                                "${(cartProvider.addedCartList[index].quantity! * cartProvider.addedCartList[index].price!).toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                                color: ColorResources
                                                                    .COLOR_PRIMARY,
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ]);
                      }),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order Total",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "RM" + "${totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorResources.COLOR_PRIMARY),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.monetization_on),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "Payment Options",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Debit/Credit card",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ColorResources.COLOR_PRIMARY),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}