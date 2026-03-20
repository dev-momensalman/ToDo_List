import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      log('Starting email sign-up process for: $email');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update user profile with display name
      await userCredential.user?.updateDisplayName(displayName);
      log('User profile updated with display name: $displayName');

      // Create user document in Firestore
      await _createUserDocument(
        userCredential.user!,
        displayName,
        provider: 'email',
      );
      log('User document created in Firestore for: $email');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Exception during sign-up: ${e.code} - ${e.message}');
      throw _getErrorMessage(e);
    } catch (e) {
      log('Unexpected error during sign-up: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      log('Starting email sign-in process for: $email');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('Email sign-in successful for: $email');

      // Update last login time
      await _updateLastLogin(userCredential.user!);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Exception during sign-in: ${e.code} - ${e.message}');
      throw _getErrorMessage(e);
    } catch (e) {
      log('Unexpected error during sign-in: $e');
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);

        // Update Firestore document
        await _firestore.collection('users').doc(user.uid).update({
          'displayName': displayName,
          'photoURL': photoURL,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw 'Error updating profile. Please try again.';
    }
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } catch (e) {
      throw 'Error changing password. Please try again.';
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        log('Starting account deletion for user: ${user.email}');

        // Delete user document from Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        log('User document deleted from Firestore');

        // Delete user from Authentication
        await user.delete();
        log('User deleted from Firebase Authentication');

        log('Account deletion completed successfully for: ${user.email}');
      }
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth Exception during account deletion: ${e.code} - ${e.message}',
      );
      throw _getErrorMessage(e);
    } catch (e) {
      log('Unexpected error during account deletion: $e');
      throw 'Error deleting account. Please try again.';
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(
    User user,
    String displayName, {
    String provider = 'email',
  }) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': displayName,
      'photoURL': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'isEmailVerified': user.emailVerified,
      'phoneNumber': user.phoneNumber,
      'provider': provider, // Add provider info
    });
  }

  // Update last login time
  Future<void> _updateLastLogin(User user) async {
    await _firestore.collection('users').doc(user.uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Error fetching user data. Please try again.';
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      log('Starting Google Sign-In process...');

      // Force sign out to ensure clean state
      await _googleSignIn.signOut();
      log('Signed out from any previous Google session');

      log('Attempting to sign in with Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      log('Google user selected: ${googleUser?.email}');

      if (googleUser == null) {
        log('Google Sign-In was cancelled by user');
        throw 'Sign in with Google was cancelled';
      }

      // Obtain the auth details from the request
      log('Getting Google authentication details...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      log('Google authentication obtained successfully');

      // Check if we have the required tokens
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        log('Error: No access token or ID token received from Google');
        throw 'Failed to get authentication tokens from Google';
      }

      // Create a new credential
      log('Creating Google credential...');
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('Google credential created successfully');

      // Sign in with the credential
      log('Signing in with Google credential...');
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      log('Google Sign-In successful for user: ${userCredential.user?.email}');

      // Create user document in Firestore
      log('Creating user document in Firestore...');
      await _createUserDocument(
        userCredential.user!,
        googleUser.displayName ?? 'Google User',
        provider: 'google',
      );
      log('User document created successfully');

      // Update last login time
      await _updateLastLogin(userCredential.user!);
      log('Last login time updated');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth Exception during Google Sign-In: ${e.code} - ${e.message}',
      );
      throw _getErrorMessage(e);
    } catch (e) {
      log('Error during Google Sign-In: $e');
      throw 'An error occurred during Google sign in: ${e.toString()}';
    }
  }

  // Sign out from Google
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Get error message from FirebaseAuthException
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get user ID
  String? get userId => currentUser?.uid;

  // Get user email
  String? get userEmail => currentUser?.email;

  // Get user display name
  String? get userDisplayName => currentUser?.displayName;

  // Get user photo URL
  String? get userPhotoURL => currentUser?.photoURL;

  // Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      throw 'Error sending verification email. Please try again.';
    }
  }

  // Reload user
  Future<void> reloadUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
      }
    } catch (e) {
      throw 'Error reloading user data. Please try again.';
    }
  }
}
