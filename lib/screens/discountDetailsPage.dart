import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sustainfy/utils/colors.dart';
import 'package:sustainfy/widgets/customCurvedEdges.dart';

class DiscountDetailsPage extends StatefulWidget {
  final String couponId;

  DiscountDetailsPage({required this.couponId});

  @override
  _DiscountDetailsPageState createState() => _DiscountDetailsPageState();
}

class _DiscountDetailsPageState extends State<DiscountDetailsPage> {
  Map<String, dynamic>? couponData;

  //  Dummy Coupons List
  final List<Map<String, dynamic>> dummyCoupons = [
    {
      "couponId": "JMAo4cubhnu2N0oFbXaM",
      "couponDesc": "15% Discount on Sony Bravia TVs",
      "couponPoint": 850,
      "totalClaims": 25,
      "compRef": "Sony",
      "couponStart": DateTime(2025, 4, 1),
      "couponExp": DateTime(2025, 4, 30),
      "shortDesc": "Get an exclusive 15% discount* on Sony Bravia TVs when you shop at sony.com.",
      "terms": [
        "This coupon is valid from April 1, 2025, to April 30, 2025. After this period, the coupon will expire and cannot be used.",
        "Discount applies only to Sony Bravia TVs and PlayStation accessories purchased from official Sony outlets or online.",
        "A minimum order value of ₹2050 is required to use this coupon.",
        "Coupons cannot be combined with other promotions or offers.",
        "This coupon cannot be used on sale items, clearance items, or gift cards.",
        "If the order is canceled or refunded, the coupon will not be reissued or replaced."
      ]
    },
    {
      "couponId": "Pd4nBbpydpjld82hnNJI",
      "couponDesc": "20% Discount on Ericsson 5G Equipment",
      "couponPoint": 500,
      "totalClaims": 60,
      "compRef": "Ericsson",
      "couponStart": DateTime(2025, 2, 1),
      "couponExp": DateTime(2025, 2, 28),
      "shortDesc": "Enjoy an extra 20% off* on Ericsson's latest 5G Equipment at ericsson.com.",
      "terms": [
        "Valid from February 1, 2025, to February 28, 2025.",
        "This coupon is only valid on orders over ₹2050.",
        "Offer not valid for resellers or bulk distributors.",
        "Coupons cannot be combined with other promotions or offers.",
        "This coupon cannot be used on sale items, clearance items, or gift cards.",
        "Coupons cannot be used for subscription-based services or software renewals.",
        "This coupon cannot be used on discounted items, clearance sales, or gift cards.",
        "Ericsson reserves the right to modify or terminate this offer at any time without notice."
      ]
    },
    {
      "couponId": "salLjKyxquJsprTvudAE",
      "couponDesc": "Flat ₹1000 Off on Zara Clothing",
      "couponPoint": 300,
      "totalClaims": 50,
      "compRef": "Zara",
      "couponStart": DateTime(2025, 5, 1),
      "couponExp": DateTime(2025, 5, 31),
      "shortDesc": "Shop the latest Zara collection and get ₹1000 off* on orders above ₹5000!",
      "terms": [
        "Valid on Zara online store and physical outlets.",
        "Applicable only on minimum purchases of ₹5000.",
        "Not valid on sale items, accessories, or gift cards.",
        "Only one coupon per user is allowed.",
        "Cannot be clubbed with other ongoing sale or clearance discounts.",
        "Zara reserves the right to cancel or modify the coupon if fraudulent activity is detected."
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _fetchCouponDetails();
  }

  void _fetchCouponDetails() {
    print(" Received couponId: ${widget.couponId}");

    couponData = dummyCoupons.firstWhere(
      (coupon) => coupon["couponId"] == widget.couponId,
      orElse: () {
        print(" No matching coupon found in dummy data!");
        return {};
      },
    );

    setState(() {});
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
      body: couponData != null && couponData!.isNotEmpty
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
            height: 120,
            color: Color.fromRGBO(52, 168, 83, 1),
            child: Row(
              children: [
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 5),
                Text(
                  couponData!["compRef"], // Company Name
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
                Text('Limited Time Offer!', style: TextStyle(color: Colors.red,fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),

                // Validity Period
                Text(
                  'Valid from ${_formatDate(couponData!["couponStart"])} to ${_formatDate(couponData!["couponExp"])}',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                SizedBox(height: 25),

                // Discount Title
                RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: _getStyledText(couponData!["couponDesc"]),
                ),
              ),

                SizedBox(height: 23),

                //Coupon Short Description
                Text(couponData!["shortDesc"], textAlign: TextAlign.center, 
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),),
                SizedBox(height: 19),

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
                        // "AB5YZ09MY1V4H",
                          couponData!["couponId"],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal, 
                            color: Colors.grey.shade700, 
                          ),
                        ),                  
                        ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: couponData!["couponId"]));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coupon code copied!')));
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
                  (couponData!["terms"] as List<dynamic>).length,
                  (index) => Text(
                    '${index + 1}. ${couponData!["terms"][index]}',
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
  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";
}
