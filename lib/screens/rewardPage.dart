import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/screens/discountDetailsPage.dart';
import 'package:sustainfy/screens/landingPage.dart';
import 'package:sustainfy/screens/profilePage.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/utils/font.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponModelPageState createState() => _CouponModelPageState();
}

class _CouponModelPageState extends State<CouponPage> {
  UserClassOperations operations = UserClassOperations();



  // **Updated Redeem Coupon Logic**
  void _redeemCouponModel(CouponModel coupon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountDetailsPage(couponId: coupon.couponId),
      ),
    ).then((value) {
  if (value == true) {
    _getcoupons();  // Refresh the coupons list
  }
});
  }


  void initState() {
    super.initState();
    _getUserPoints();
    _getcoupons();
  }

  void _getUserPoints() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    int updatedPoints = await operations.getUserPoints(userEmail);

    // Update Provider with new points
    Provider.of<userProvider>(context, listen: false).setPoints(updatedPoints);
  }

  void _getcoupons() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    List<CouponModel> updatedCoupons = await operations.getUnclaimedCoupons(userEmail);

    Provider.of<userProvider>(context, listen: false).setCoupon(updatedCoupons);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CustomCurvedEdges(),
            child: Container(
              height: 150, // Specify a height for the curved app bar
              color: const Color.fromRGBO(52, 168, 83, 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Image.asset(
                      'assets/images/SustainifyLogo.png',
                      width: 50,
                      height: 60,
                    ),
                  ),
                  SizedBox(width: 17),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search a coupon...',
                        hintStyle: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.inter,
                          fontWeight: AppFonts.interRegularWeight,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          ),
          // Points Display
          Consumer<userProvider>(
            builder: (BuildContext context, provider, child) {  
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${provider.points ?? 0}',
                      style: TextStyle(
                        color: AppColors.greenappBar,
                        fontFamily: AppFonts.inter,
                        fontSize: 70,
                        fontWeight: AppFonts.interSemiBoldWeight,
                      ),
                    ),
                    TextSpan(
                      text: ' points',
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: 42,
                        fontWeight: AppFonts.interSemiBoldWeight,
                        color: const Color.fromRGBO(50, 50, 55, 1),
                      ),
                    ),
                  ],
                ),
              ),
            );},
          ),
          SizedBox(height: 20),
          // Rewards Title
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Rewards',
                style: TextStyle(
                  color: const Color.fromRGBO(50, 50, 55, 1),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // List of coupon cards
          Consumer<userProvider>(
            builder: (BuildContext context, provider, child) {
            return Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  mainAxisSpacing: 10, // Spacing between rows
                  crossAxisSpacing: 10, // Spacing between columns
                  childAspectRatio: 1.22, // Aspect ratio for the cards
                ),
                itemCount: provider.coupons!.length,
                itemBuilder: (context, index) {
                  return CouponModelCard(
                    coupon: provider.coupons![index],
                    redeemCouponModel: _redeemCouponModel,
                  );
                },
              ),
            );},
          )
        ],
      ),
    );
  }
}

class CouponModelCard extends StatefulWidget {
  final CouponModel coupon;
  final Function(CouponModel) redeemCouponModel;

  CouponModelCard({
    Key? key,
    required this.coupon,
    required this.redeemCouponModel,
  }) : super(key: key);

  @override
  State<CouponModelCard> createState() => _CouponModelCardState();
}

class _CouponModelCardState extends State<CouponModelCard> {
  bool _isWishlisted = false;
  UserClassOperations operations = UserClassOperations();

  void toggleWishlist() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    await operations.toggleWishlist(userEmail, widget.coupon.couponId);
    await checkWishlistStatus();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(_isWishlisted ? "Added to Wishlist" : "Removed from Wishlist"),
    ));
  }

  Future<void> checkWishlistStatus() async {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    bool status =
        await operations.checkIfWishlisted(userEmail, widget.coupon.couponId);
    setState(() {
      _isWishlisted = status;
    });
  }

  @override
  void initState() {
    super.initState();
    checkWishlistStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.redeemCouponModel(widget.coupon),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          child: SizedBox(
            width: double.infinity, // Ensures width consistency
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Prevents unnecessary height issues
              children: [
                Center(
                  child: FutureBuilder<String?>(
                    future: operations.getCompanyImage(widget.coupon.compRef),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Icon(Icons.image_not_supported);
                      }
                      return Image.network(
                        snapshot.data!,
                        width: double.infinity,
                        height: 50,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),

                /// **Flexible Description Handling**
                Flexible(
                  child: Text(
                    widget.coupon.couponDesc,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: AppFonts.inter,
                      fontWeight: AppFonts.interSemiBoldWeight,
                    ),
                    maxLines: 1, // Ensures 2-line limit
                    overflow: TextOverflow
                        .ellipsis, // Adds "..." when text is too long
                    softWrap: true,
                  ),
                ),

                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // **Points Container**
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pointsContainerReward,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.coupon.couponPoint} pts',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),

                    // **Wishlist Icon**
                    IconButton(
                      icon: Icon(
                        _isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        toggleWishlist();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
