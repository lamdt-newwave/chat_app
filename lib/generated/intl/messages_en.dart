// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(phoneNumber) =>
      "We have sent you an SMS with the code to ${phoneNumber}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "button_continue": MessageLookupByLibrary.simpleMessage("Continue"),
        "button_start_messaging":
            MessageLookupByLibrary.simpleMessage("Start Messaging"),
        "text_enter_code": MessageLookupByLibrary.simpleMessage("Enter Code"),
        "text_enter_phone":
            MessageLookupByLibrary.simpleMessage("Enter Your Phone Number"),
        "text_on_boarding": MessageLookupByLibrary.simpleMessage(
            "Connect easily with your family and friends over countries"),
        "text_phone_number":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "text_please_confirm_country": MessageLookupByLibrary.simpleMessage(
            "Please confirm your country code and enter your phone number"),
        "text_policy":
            MessageLookupByLibrary.simpleMessage("Terms & Privacy Policy"),
        "text_sent_sms": m0
      };
}
