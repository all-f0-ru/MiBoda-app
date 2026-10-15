import 'package:flutter/material.dart';

/// Tono de un chip de estado (RSVP, cotizaciones, pagos, etc.).
enum StatusTone { success, warning, error, info, neutral }

class Vendor {
  const Vendor({
    required this.id,
    required this.category,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.priceFrom,
    required this.photo,
  });

  final String id;
  final String category;
  final String name;
  final double rating;
  final int reviews;
  final String location;
  final String priceFrom;
  final Color photo;
}

class VendorPackage {
  const VendorPackage(this.name, this.detail, this.price);
  final String name;
  final String detail;
  final String price;
}

class Review {
  const Review({required this.id, required this.author, required this.stars, required this.text, required this.date, this.reply});
  final String id;
  final String author;
  final int stars;
  final String text;
  final String date;
  final String? reply;
}

class TaskItem {
  const TaskItem({required this.id, required this.title, required this.meta, this.overdue = false});
  final String id;
  final String title;
  final String meta;
  final bool overdue;
}

class TaskGroup {
  const TaskGroup(this.label, this.tasks);
  final String label;
  final List<TaskItem> tasks;
}

enum Rsvp { confirmed, pending, declined, notSent }

class Guest {
  const Guest({
    required this.id,
    required this.initials,
    required this.name,
    required this.group,
    this.extra = '',
    required this.rsvp,
    this.seats = 1,
  });

  final String id;
  final String initials;
  final String name;
  final String group;
  final String extra;
  final Rsvp rsvp;
  final int seats;
}

class SeatingTable {
  const SeatingTable(this.name, this.occupied, this.capacity);
  final String name;
  final int occupied;
  final int capacity;
}

class Conversation {
  const Conversation({required this.initials, required this.name, required this.lastMessage, required this.time, this.unread = 0});
  final String initials;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
}

class Payment {
  const Payment({required this.id, required this.concept, required this.due, required this.amount, required this.tone, required this.label});
  final String id;
  final String concept;
  final String due;
  final String amount;
  final StatusTone tone;
  final String label;
}

class BudgetCategory {
  const BudgetCategory(this.name, this.real, this.estimate, this.progress, {this.over = false});
  final String name;
  final String real;
  final String estimate;
  final double progress;
  final bool over;
}

class AppNotification {
  const AppNotification({required this.icon, required this.tone, required this.text, required this.time, required this.route, this.unread = false});
  final IconData icon;
  final StatusTone tone;
  final String text;
  final String time;
  final String route;
  final bool unread;
}

class QuoteRequest {
  const QuoteRequest({
    required this.initials,
    required this.couple,
    required this.ago,
    required this.summary,
    required this.status,
    required this.tone,
  });
  final String initials;
  final String couple;
  final String ago;
  final String summary;
  final String status;
  final StatusTone tone;
}

class QuoteLine {
  const QuoteLine(this.name, this.detail, this.price);
  final String name;
  final String detail;
  final String price;
}

class QuotePackage {
  const QuotePackage(this.name, this.total, this.deposit, this.lines);
  final String name;
  final String total;
  final String deposit;
  final List<QuoteLine> lines;
}

enum QuoteStatus { pending, accepted, rejected, changesRequested }

enum DayStatus { available, booked, blocked }
