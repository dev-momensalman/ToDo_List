import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final bool isEmailVerified;
  final Timestamp createdAt;
  final Timestamp lastLoginAt;
  final Timestamp updatedAt;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.isEmailVerified,
    required this.createdAt,
    required this.lastLoginAt,
    required this.updatedAt,
  });

  // Create UserProfile from Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      lastLoginAt: data['lastLoginAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  // Convert UserProfile to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'updatedAt': updatedAt,
    };
  }

  // Create a copy with updated fields
  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isEmailVerified,
    Timestamp? createdAt,
    Timestamp? lastLoginAt,
    Timestamp? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Create UserProfile from Firebase User
  factory UserProfile.fromFirebaseUser(
    User user, {
    String? displayName,
    String? photoURL,
  }) {
    final now = Timestamp.now();
    
    return UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: displayName ?? user.displayName ?? '',
      photoURL: photoURL ?? user.photoURL,
      isEmailVerified: user.emailVerified,
      createdAt: now,
      lastLoginAt: now,
      updatedAt: now,
    );
  }

  // Get display name with fallback
  String get displayNameOrEmail {
    if (displayName.isNotEmpty) return displayName;
    if (email.isNotEmpty) {
      final parts = email.split('@');
      return parts[0];
    }
    return 'Unknown User';
  }

  // Get initials for avatar
  String get initials {
    if (displayName.isNotEmpty) {
      final parts = displayName.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        return displayName.substring(0, 1).toUpperCase();
      }
    } else if (email.isNotEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    return 'U';
  }

  // Check if user has profile picture
  bool get hasProfilePicture => photoURL != null && photoURL!.isNotEmpty;

  // Get formatted creation date
  String get formattedCreatedAt {
    return _formatTimestamp(createdAt);
  }

  // Get formatted last login date
  String get formattedLastLoginAt {
    return _formatTimestamp(lastLoginAt);
  }

  // Format timestamp to readable string
  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

// Extension for User to easily convert to UserProfile
extension UserExtension on User {
  UserProfile toUserProfile({String? displayName, String? photoURL}) {
    return UserProfile.fromFirebaseUser(
      this,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}
