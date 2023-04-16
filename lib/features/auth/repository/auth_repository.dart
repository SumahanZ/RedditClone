import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';

import '../../../core/constants/constants.dart';
import '../../../core/enums/enums.dart';
import '../../../core/failure.dart';
import '../../../models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseFirestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firebaseFirestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firebaseFirestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  //check for user changes
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      //show googlesignin popup and returns instance googlesigninaccount if sign in successful
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //get authentication information
      final googleAuth = await googleUser?.authentication;
      //create credentials
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      //save credentials and signin with credentials to firebase

      UserCredential userCredential;
      if (isFromLogin) {
        //create a new google account
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        //take guest account and link with google sign in account
        userCredential =
            await _auth.currentUser!.linkWithCredential(credential);
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        userModel = UserModel(
            name: userCredential.user?.displayName ?? "No Name",
            profilePic:
                userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            uid: userCredential.user!.uid,
            isAuthenticated: true,
            karma: 0,
            awards: [
              UserAwards.awesomeAns.awards,
              UserAwards.gold.awards,
              UserAwards.platinum.awards,
              UserAwards.helpful.awards,
              UserAwards.plusone.awards,
              UserAwards.rocket.awards,
              UserAwards.thankyou.awards,
              UserAwards.til.awards
            ]);
        await _users.doc(userCredential.user?.uid).set(userModel.toMap());
      } else {
        //userModel -> userModel -> userModel -> (userModel) first ->
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      UserModel userModel;

      userModel = UserModel(
          name: "Guest",
          profilePic: Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: false,
          karma: 0,
          awards: []);
      await _users.doc(userCredential.user?.uid).set(userModel.toMap());
      return right(userModel);
    } on FirebaseException catch (e) {
      throw left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
