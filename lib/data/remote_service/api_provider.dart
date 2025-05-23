import 'package:google_sign_in/google_sign_in.dart';

import '../../export_file.dart';

class APIRepository {
  static var deviceName, deviceType, deviceID, deviceVersion;

  APIRepository() {
    getDeviceData();
  }

  getDeviceData() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await info.androidInfo;
      deviceName = androidDeviceInfo.model;
      deviceID = androidDeviceInfo.id;
      deviceVersion = androidDeviceInfo.version.release;
      deviceType = "1";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await info.iosInfo;
      deviceName = iosDeviceInfo.model;
      deviceID = iosDeviceInfo.identifierForVendor;
      deviceVersion = iosDeviceInfo.systemVersion;
      deviceType = "2";
    }
  }

  Future<void> checkCurrentUser() async {
    var documentReference =
        FirebaseFirestore.instance.collection("users").doc(currentUser?.uid);
    var dataSnapShot = await documentReference.get();
    if (dataSnapShot.exists) {
      var data = dataSnapShot.data();
      currentUserModel = CurrentUserModel.fromJson(data!);
    }
  }

  Future registerNewUser(Map<String, dynamic> userData) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );
      currentUser = userCredential.user;
      currentUser?.updateDisplayName(
          "${userData['firstName'] + " " + userData['lastName']}");
      currentUser?.reload();
      currentUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .set({
        'firstName': userData['firstName'],
        'uid': currentUser?.uid,
        'lastName': userData['lastName'],
        'email': userData['email'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /*===================================================================== login API Call  ==========================================================*/
  Future loginApiCall(Map<String, dynamic> dataBody) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: dataBody['email'], password: dataBody['password']);
      currentUser?.reload();
      currentUser = userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future resetPassword({email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showToast("Password reset email sent!");
    } catch (e) {
      rethrow;
    }
  }

  Future googleSignInCall() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      currentUser?.reload();
      currentUser = userCredential.user;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .set({
        'firstName': userCredential.user?.displayName?.split(" ")[0] ?? "",
        'lastName': userCredential.user?.displayName?.split(" ")[1] ?? '',
        'email': userCredential.user?.email ?? "",
        'uid': userCredential.user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      showToast(
        e.toString(),
      );
    } catch (e) {
      showToast(
        e.toString(),
      );
    }
  }
}
