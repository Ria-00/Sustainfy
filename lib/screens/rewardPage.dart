import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
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
  final List<CouponModel> coupons = [
  ];

  int? _currentPoints; // Store the current points

  // Redeem coupon logic
  void _redeemCouponModel(CouponModel coupon) {
    if (_currentPoints! >= coupon.couponPoint) {
      setState(() {
        _currentPoints = (_currentPoints ?? 0) - coupon.couponPoint; // Deduct points on redeem
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CouponModel redeemed!')),
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

  void _getUserPoints(){
    String userEmail = Provider.of<userProvider>(context, listen: false).email ?? '';
    operations.getUserPoints(userEmail).then((value) {
      setState(() {
        _currentPoints = value;
      });
    });
  }

  void _getcoupons() async {
  List<CouponModel>? fetchedCoupons = await operations.getAllCoupons();
  String userEmail = Provider.of<userProvider>(context, listen: false).email ?? '';
  print(userEmail);

  if (fetchedCoupons != null && mounted) {
    List<Future<bool>> claimCheckFutures = [];

    // Create a list of coupon references
    List<Future<DocumentReference?>> refFutures = fetchedCoupons.map((coupon) {
      return operations.getDocumentRef(collection: "coupons", field: "couponId", value: coupon.couponId);
    }).toList();

    // Wait for all document references to be fetched
    List<DocumentReference?> couponRefs = await Future.wait(refFutures);

    // Check if user has claimed each coupon in parallel
    for (int i = 0; i < fetchedCoupons.length; i++) {
      if (couponRefs[i] != null) {
        claimCheckFutures.add(operations.hasUserClaimedCoupon(userEmail, couponRefs[i]!));
      } else {
        claimCheckFutures.add(Future.value(false)); // Default to unclaimed if ref is null
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
                    text: '$_currentPoints',
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
          // Claim CouponModels Title
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Claim Coupons',
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
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return CouponModelCard(
                    coupon: coupons[index],
                    redeemCouponModel: _redeemCouponModel,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CouponModelCard extends StatelessWidget {
  UserClassOperations operations = UserClassOperations();
  final CouponModel coupon;
  final Function(CouponModel) redeemCouponModel;

  CouponModelCard({
    Key? key,
    required this.coupon,
    required this.redeemCouponModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 15),
            FutureBuilder<String?>(
              future: operations.getCompanyImage(coupon.compRef),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Icon(Icons.image_not_supported); // Show fallback if no image
                }
                return Image.network(
                    snapshot.data!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  );
              },
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.couponDesc,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green.shade800,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${coupon.couponPoint} points',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () => redeemCouponModel(coupon),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreen,
                          minimumSize: Size(30, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Claim',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
