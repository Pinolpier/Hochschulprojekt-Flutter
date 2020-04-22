import 'package:flutter/material.dart';

/// option model for the settings_screen
class Option {
  Icon icon;
  String title;
  String subtitle;

  Option({this.icon, this.title, this.subtitle});
}

final options = [
  Option(
    icon: Icon(Icons.account_circle, size: 40.0),
    title: 'My Account',
    subtitle: 'personal account settings',
  ),
  Option(
    icon: Icon(Icons.notifications_active, size: 40.0),
    title: 'Notifications',
    subtitle: 'notification settings',
  ),
  Option(
    icon: Icon(Icons.contacts, size: 40.0),
    title: 'Invite Friends',
    subtitle: 'if you enjoy using our app please consider inviting your friends through this option',
  ),
  Option(
    icon: Icon(Icons.star, size: 40.0),
    title: 'Rate App',
    subtitle: 'please give us a 5 star rating in google play/app store',
  ),
  Option(
    icon: Icon(Icons.developer_mode, size: 40.0),
    title: 'Feedback',
    subtitle: 'give us feedback on our app or report bugs here to help us improve further in the future',
  ),
  Option(
    icon: Icon(Icons.dvr, size: 40.0),
    title: 'Terms of Use',
    subtitle: '',
  ),
  Option(
    icon: Icon(Icons.lock, size: 40.0),
    title: 'Data Protection',
    subtitle: '',
  ),
  Option(
    icon: Icon(Icons.mail_outline, size: 40.0),
    title: 'Imprint',
    subtitle: '',
  ),
];