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

  // List of coupons
  final List<CouponModel> coupons = [];

  int? _currentPoints; // Store the current points

  // **Updated Redeem Coupon Logic**
  void _redeemCouponModel(CouponModel coupon) {
    if (_currentPoints! >= coupon.couponPoint) {
      setState(() {
        _currentPoints = (_currentPoints ?? 0) - coupon.couponPoint;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiscountDetailsPage(couponId: coupon.couponId),
        ),
      );
     
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough points to redeem this coupon')),
      );
    }
  }

  void initState() {
    super.initState();
    _getUserPoints();
    _getcoupons();
  }

  void _getUserPoints() {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    operations.getUserPoints(userEmail).then((value) {
      setState(() {
        _currentPoints = value;
      });
    });
  }

  void _getcoupons() async {
    List<CouponModel>? fetchedCoupons = await operations.getAllCoupons();
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';
    print(userEmail);

    if (fetchedCoupons != null && mounted) {
      List<Future<bool>> claimCheckFutures = [];

      // Create a list of coupon references
      List<Future<DocumentReference?>> refFutures =
          fetchedCoupons.map((coupon) {
        return operations.getDocumentRef(
            collection: "coupons", field: "couponId", value: coupon.couponId);
      }).toList();

      // Wait for all document references to be fetched
      List<DocumentReference?> couponRefs = await Future.wait(refFutures);

      // Check if user has claimed each coupon in parallel
      for (int i = 0; i < fetchedCoupons.length; i++) {
        if (couponRefs[i] != null) {
          claimCheckFutures
              .add(operations.hasUserClaimedCoupon(userEmail, couponRefs[i]!));
        } else {
          claimCheckFutures
              .add(Future.value(false)); // Default to unclaimed if ref is null
        }
      }

      // Wait for all claim checks to complete
      List<bool> claimResults = await Future.wait(claimCheckFutures);

      // Filter unclaimed coupons efficiently
      List<CouponModel> unclaimedCoupons = [];
      for (int i = 0; i < fetchedCoupons.length; i++) {
        if (!claimResults[i]) {
          print("CouponModel not claimed: ${fetchedCoupons[i].couponDesc}");
          unclaimedCoupons.add(fetchedCoupons[i]);
        }
      }

      if (mounted) {
        setState(() {
          coupons.addAll(unclaimedCoupons);
        });
      }
    } else {
      print("User not found!");
    }
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${_currentPoints ?? 0}',
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
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                mainAxisSpacing: 10, // Spacing between rows
                crossAxisSpacing: 10, // Spacing between columns
                childAspectRatio: 1.22, // Aspect ratio for the cards
              ),
              itemCount: coupons.length, 
              itemBuilder: (context, index) {
                return CouponModelCard(
                  coupon: coupons[index],
                  redeemCouponModel: _redeemCouponModel,
                );
              },
            ),
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
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  widget.coupon.couponDesc,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: AppFonts.inter,
                    fontWeight: AppFonts.interSemiBoldWeight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Points Container
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pointsContainerReward,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.coupon.couponPoint} pts',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),

                    // Wishlist Icon
                    IconButton(
                      icon: Icon(
                        _isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _isWishlisted = !_isWishlisted;
                        });

                        // Show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(_isWishlisted
                              ? "Added to Wishlist"
                              : "Removed from Wishlist"),
                        ));
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