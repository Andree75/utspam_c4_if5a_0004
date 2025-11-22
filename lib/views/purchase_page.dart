import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../controllers/database_helper.dart';
import 'history_page.dart';

class PurchasePage extends StatefulWidget {
  final User user;
  final String medicineName;
  final int price;

  const PurchasePage({
    super.key,
    required this.user,
    required this.medicineName,
    required this.price,
  });

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}
