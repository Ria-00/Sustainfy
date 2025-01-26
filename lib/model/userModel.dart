class UserClass {
  String? userName;
   String? usermail;
   String? password;
   int? phone;
   String? address;
   Map<dynamic,dynamic>? cart;
   Map<dynamic,dynamic>? orders;
   String? userProfilePhoto;




  UserClass({
    required this.usermail,
    required this.password,
  });

  UserClass.withPhoto({
    required this.userName,
    required this.userProfilePhoto
  });

  Map<String,dynamic> toMap(){
    return(
      {
        "userName":userName,
        "email":usermail,
        "password":password,
        "phone":phone,
        "address":address,
        "cart":cart,
        "orders":orders

      }
    );
  }

  get getusermail => this.usermail;

 set setusermail( usermail) => this.usermail = usermail;

  get getPassword => this.password;

 set setPassword( password) => this.password = password;
 
}
