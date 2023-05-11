

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Request{
  final String id;
  final String name;
  final String phone;
  final String email;
  final String category;
  final String message;
  final Timestamp date;
  final String status;

  Request(
      this.id,
      this.name,
      this.phone,
      this.email,
      this.category,
      this.message,
      this.date,
      this.status
      );
}