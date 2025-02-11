class UserClass {
  String? userName;
   String? usermail;
   String? password;
   int? phone;
   String? userProfilePhoto;




  UserClass({
    required this.usermail,
    required this.password,
  });

  UserClass.register({
    required this.userName,
    required this.usermail,
    required this.password,
    required this.phone
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
        "phone":phone

      }
    );
  }

  get getusermail => this.usermail;

 set setusermail( usermail) => this.usermail = usermail;

  get getPassword => this.password;

 set setPassword( password) => this.password = password;
 
}
