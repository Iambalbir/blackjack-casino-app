class AuthRequestModel {
  static loginReq(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      deviceToken,
      deviceType,
      deviceName}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['LoginForm[device_token]'] = deviceToken;
    data['LoginForm[device_type]'] = deviceType;
    data['LoginForm[device_name]'] = deviceName;
    return data;
  }

  static forgetReq({String? email}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = email;
    return data;
  }

  static deleteNotificationReq({String? notificationId}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = notificationId;
    return data;
  }

  static changePass({var password, currentPassword}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = password;
    data['current_password'] = currentPassword;
    return data;
  }

  static modifyJobApplicationRequestModel(
      {var id, actionType, type, applicationId}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['action_type'] = actionType;
    data['type'] = type;
    data['application_id'] = applicationId;
    return data;
  }

  static loadMessageRequestModel({var receiverId, jobId, message, page}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiver_id'] = receiverId;
    data['job_id'] = jobId;
    data['message'] = message;
    data['page'] = page;
    return data;
  }

  static addQualification({var id, var qualification}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['qualification'] = qualification;
    return data;
  }

  static deleteChat({var chatId}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = chatId;
    return data;
  }

  static updateProfileRequestModel(
      {var firstName,
      var lastName,
      var telephoneNotification,
      var emailNotification,
      var smsNotification}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['telephone_notification'] = telephoneNotification;
    data['email_notification'] = emailNotification;
    data['sms_notification'] = smsNotification;
    return data;
  }

  //========================================= Publish Job Request Model

  static publishJobRequestModel(
      {var id, var transactionId, var response, var amount, var paymentId}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['response'] = response;
    data['amount'] = amount;
    data['payment_id'] = paymentId;
    return data;
  }

  static deleteQualification({var id}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    return data;
  }

  static updateAddressRequestModel(
      {var id, var address, var latitude, var longitude}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }

  static jobAddRequestModel(
      {var id,
      var title,
      var description,
      var location,
      var latitude,
      var longitude,
      trades,
      var minAmount,
      var maxAmount,
      var amountType,
      var startDate,
      var timeZone,
      var lengthOfJob,
      var transactionId,
      dynamic file,
      imageFiles}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['trades'] = trades;
    data['min_amount'] = minAmount;
    data['max_amount'] = maxAmount;
    data['amount_type'] = amountType;
    data['start_date'] = startDate;
    data['timezone'] = timeZone;
    data['length_of_job'] = lengthOfJob;
    data['images'] = imageFiles;
    data['transaction_id'] = transactionId;
    data['file'] = file;
    return data;
  }

  static jobDetailsRequestModel({
    var location,
    var latitude,
    var longitude,
    var distance,
    var trades,
    var minRate,
    var maxRate,
    var startDate,
    var endDate,
    var page,
    var type,
    var sortBy,
  }) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = location;
    data['latitude'] = latitude;
    data['page'] = page;
    data['type'] = type;
    data['longitude'] = longitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['trades'] = trades;
    data['min_rate'] = minRate;
    data['max_rate'] = maxRate;
    data['start_date_from'] = startDate;
    data['start_date_to'] = endDate;
    data['sort_by'] = sortBy;

    return data;
  }

  static loginRequestModel(
      {var firstName,
      var lastName,
      var companyName,
      var registrationNumber,
      var tempUserId,
      var validationType,
      var profilePic,
      var typeId,
      var faceId,
      var dob,
      var email,
      var mobileNumber,
      var countryCode,
      var countryIsoCode,
      var otp,
      var requestToken,
      var address,
      var latitude,
      var longitude,
      var trades,
      var tradeId,
      var password,
      var deviceToken,
      var deviceType,
      var deviceName}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = firstName;
    data['dob'] = dob;
    data['last_name'] = lastName;
    data['email'] = email;
    data['type_id'] = typeId;
    data['face_id'] = faceId;
    data['temp_user_id'] = tempUserId;
    data['profile_pic'] = profilePic;
    data['mobile_no'] = mobileNumber;
    data['country_code'] = countryCode;
    data['country_iso_code'] = countryIsoCode;
    data['address'] = address;
    data['company_name'] = companyName;
    data['validate_type'] = validationType;
    data['registration_number'] = registrationNumber;
    data['trades'] = trades;
    data['trade_id'] = tradeId;
    data['password'] = password;
    data['otp'] = otp;
    data['request_token'] = requestToken;
    data['device_token'] = deviceToken;
    data['device_type'] = deviceType;
    data['device_name'] = deviceName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }

  static companyLoginRequestModel(
      {var firstName,
      var lastName,
      var email,
      var mobileNumber,
      var countryCode,
      var countryIsoCode,
      var otp,
      var address,
      var latitude,
      var longitude,
      var password,
      var deviceToken,
      var deviceType,
      var deviceName,
      var logo,
      var companyName,
      var registrationNumber,
      var companyAddress,
      var companyMobileNo,
      var companyLatitude,
      var companyLongitude,
      var companyCountryCode,
      var companyCountryIsoCode}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile_no'] = mobileNumber;
    data['country_code'] = countryCode;
    data['country_iso_code'] = countryIsoCode;
    data['address'] = address;
    data['password'] = password;
    data['otp'] = otp;
    data['logo'] = logo;
    data['device_token'] = deviceToken;
    data['device_type'] = deviceType;
    data['device_name'] = deviceName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['company_name'] = companyName;
    data['registration_number'] = registrationNumber;
    data['company_address'] = companyAddress;
    data['company_mobile_no'] = companyMobileNo;
    data['company_latitude'] = companyLatitude;
    data['company_longitude'] = companyLongitude;
    data['company_country_code'] = companyCountryCode;
    data['company_country_iso_code'] = companyCountryIsoCode;
    return data;
  }

  static logCrashErrorReq({
    error,
    packageVersion,
    phoneModel,
    ip,
    stackTrace,
  }) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Log[error]'] = error;
    data['Log[link]'] = packageVersion;
    data['Log[referer_link]'] = phoneModel;
    data['Log[user_ip]'] = ip;
    data['Log[description]'] = stackTrace;
    return data;
  }

  static forgotPasswordRequestModel(
      {var mobileNo, var countryCode, var countryCodeIsoNumber, var otp}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_no'] = mobileNo;
    data['country_code'] = countryCode;
    data['country_iso_code'] = countryCodeIsoNumber;
    data['otp'] = otp;

    return data;
  }

  static verifyMobileNumberRequestModel({
    var emailAddress,
    var tempUserToken,
    var otp,
  }) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = emailAddress;
    data['temp_user_id'] = tempUserToken;
    data['otp'] = otp;

    return data;
  }
}
