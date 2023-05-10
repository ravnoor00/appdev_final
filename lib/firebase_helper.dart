import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

var db = FirebaseFirestore.instance;
final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

