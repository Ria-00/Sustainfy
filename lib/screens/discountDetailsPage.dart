import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sustainfy/model/couponModel.dart';
import 'package:sustainfy/providers/userProvider.dart';
import 'package:sustainfy/services/userOperations.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class DiscountDetailsPage extends StatefulWidget {
  final String couponId;

  DiscountDetailsPage({required this.couponId});

  @override
  _DiscountDetailsPageState createState() => _DiscountDetailsPageState();
}

class _DiscountDetailsPageState extends State<DiscountDetailsPage> {
  CouponModel? couponData;
  String? comp;
  bool isLoading = true;
  UserClassOperations operations = UserClassOperations();


  @override
  void initState() {
    super.initState();
    _fetchCouponDetails();
  }

  void _fetchCouponDetails() async {
    print("Received couponId: ${widget.couponId}");

    CouponModel? coupon = await operations.getCouponById(widget.couponId);

    if (coupon != null) {
      String company = await operations.getCompanyName(coupon.compRef);
      
      setState(() {
        couponData = coupon;
        comp = company;
        isLoading = false; // Fetch complete
      });
    } else {
      print("Error: Coupon not found!");
      setState(() {
        isLoading = false; // Avoid infinite loading
      });
    }
  }

  void _claimCoupon() async {
  try {
    String userEmail =
        Provider.of<userProvider>(context, listen: false).email ?? '';

    String result = await operations.claimCoupon(userEmail, widget.couponId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)), // Display the returned message
    );
    // Update the user's coupon list & points
    List<CouponModel> updatedCoupons = await operations.getUnclaimedCoupons(userEmail);
    Provider.of<userProvider>(context, listen: false).setCoupon(updatedCoupons);
    int points = await operations.getUserPoints(userEmail);
    Provider.of<userProvider>(context, listen: false).setPoints(points);
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ An error occurred. Please try again.')),
    );
  }
}




List<TextSpan> _getStyledText(String text) {
  final regex = RegExp(r'(\d+%)'); // Match any number followed by '%'
  final matches = regex.allMatches(text);

  if (matches.isNotEmpty) {
    final match = matches.first;
    return [
      TextSpan(
        text: text.substring(0, match.start), // Text before percentage
        style: TextStyle(color: Colors.black),
      ),
      TextSpan(
        text: match.group(0), // Percentage text (colored green)
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: text.substring(match.end), // Text after percentage
        style: TextStyle(color: Colors.black),
      ),
    ];
  } else {
    // If no percentage is found, return normal black text
    return [TextSpan(text: text, style: TextStyle(color: Colors.black))];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : couponData != null
              ? _buildCouponDetails()
              : _buildCouponNotFound(),
    );
  }

  // Coupon Details 
  Widget _buildCouponDetails() {
    return Column(
      children: [
        ClipPath(
          clipper: CustomCurvedEdges(),
          child: Container(
            height: 150,
            color: Color.fromRGBO(52, 168, 83, 1),
            child: Row(
              children: [
                SizedBox(width: 10),
                IconButton(
  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
  onPressed: () async {
    setState(() {}); // Rebuild the screen to reflect the latest data
    Navigator.pop(context);
  },
),

                SizedBox(width: 5),
                Text(
                  comp!, // Company Name
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
          
        Expanded(
          child: SingleChildScrollView(
             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                // Validity Period
                
                SizedBox(height: 6),

                // Discount Title
                RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: _getStyledText(couponData!.couponDesc),
                ),
              ),

                SizedBox(height: 23),

              Text(
                  'Valid from "${DateFormat('d/MM/yyyy').format(couponData!.couponStart.toDate())}" to "${DateFormat('d/MM/yyyy').format(couponData!.couponExp.toDate())}"',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),

                SizedBox(height: 20),
                // Coupon Code Box
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15), 
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          couponData!.couponCode,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal, 
                            color: Colors.grey.shade700, 
                          ),
                        ),                  
                        ElevatedButton(
                        onPressed: () {
                          _claimCoupon();
                          Clipboard.setData(ClipboardData(text: couponData!.couponId));
                        },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), 
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                        child: Text('Redeem Now', 
                        style: TextStyle(color: Colors.white ,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                

                // Terms and Conditions
                Text('Terms and Conditions*', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 22),

                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  (couponData!.terms as List<dynamic>).length,
                  (index) => Text(
                    '${index + 1}. ${couponData!.terms[index]}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ],
    );
  }


Widget _buildCouponNotFound() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20), 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            "Coupon not found!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Centers text
          ),
          SizedBox(height: 5),
          Text(
            "This coupon may have expired or is not available.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center, // Centers text
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Go Back", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}
}
