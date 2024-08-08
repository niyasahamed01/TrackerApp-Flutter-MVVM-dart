class User {
  final String gender;
  final String title;
  final String firstName;
  final String lastName;
  final String streetNumber;
  final String streetName;
  final String city;
  final String state;
  final String country;
  final String postcode;
  final String latitude;
  final String longitude;
  final String timezoneOffset;
  final String timezoneDescription;
  final String email;
  final String uuid;
  final String username;
  final String password;
  final String salt;
  final String md5;
  final String sha1;
  final String sha256;
  final String dobDate;
  final int dobAge;
  final String registeredDate;
  final int registeredAge;
  final String phone;
  final String cell;
  final String idName;
  final String idValue;
  final String pictureLarge;
  final String pictureMedium;
  final String pictureThumbnail;
  final String nationality;

  User({
    required this.gender,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.streetNumber,
    required this.streetName,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.timezoneOffset,
    required this.timezoneDescription,
    required this.email,
    required this.uuid,
    required this.username,
    required this.password,
    required this.salt,
    required this.md5,
    required this.sha1,
    required this.sha256,
    required this.dobDate,
    required this.dobAge,
    required this.registeredDate,
    required this.registeredAge,
    required this.phone,
    required this.cell,
    required this.idName,
    required this.idValue,
    required this.pictureLarge,
    required this.pictureMedium,
    required this.pictureThumbnail,
    required this.nationality,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      gender: json['gender'],
      title: json['name']['title'],
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      streetNumber: json['location']['street']['number'].toString(),
      streetName: json['location']['street']['name'],
      city: json['location']['city'],
      state: json['location']['state'],
      country: json['location']['country'],
      postcode: json['location']['postcode'].toString(),
      latitude: json['location']['coordinates']['latitude'],
      longitude: json['location']['coordinates']['longitude'],
      timezoneOffset: json['location']['timezone']['offset'],
      timezoneDescription: json['location']['timezone']['description'],
      email: json['email'],
      uuid: json['login']['uuid'],
      username: json['login']['username'],
      password: json['login']['password'] ?? '',
      salt: json['login']['salt'] ?? '',
      md5: json['login']['md5'] ?? '',
      sha1: json['login']['sha1'] ?? '',
      sha256: json['login']['sha256'] ?? '',
      dobDate: json['dob']['date'],
      dobAge: json['dob']['age'],
      registeredDate: json['registered']['date'],
      registeredAge: json['registered']['age'],
      phone: json['phone'],
      cell: json['cell'],
      idName: json['id']['name'],
      idValue: json['id']['value'] ?? '',
      pictureLarge: json['picture']['large'],
      pictureMedium: json['picture']['medium'],
      pictureThumbnail: json['picture']['thumbnail'],
      nationality: json['nat'],
    );
  }
}