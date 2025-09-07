import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome_title;

  /// No description provided for @mm.
  ///
  /// In en, this message translates to:
  /// **'Mil Mujeres'**
  String get mm;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @offices.
  ///
  /// In en, this message translates to:
  /// **'Offices'**
  String get offices;

  /// No description provided for @office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// No description provided for @consulate.
  ///
  /// In en, this message translates to:
  /// **'Consulate'**
  String get consulate;

  /// No description provided for @consulates.
  ///
  /// In en, this message translates to:
  /// **'Consulates'**
  String get consulates;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donate;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @alliances_references.
  ///
  /// In en, this message translates to:
  /// **'Alliances & References'**
  String get alliances_references;

  /// No description provided for @alliances.
  ///
  /// In en, this message translates to:
  /// **'Alliances'**
  String get alliances;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @references.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get references;

  /// No description provided for @complaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get complaint;

  /// No description provided for @complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get complaints;

  /// No description provided for @logout_success.
  ///
  /// In en, this message translates to:
  /// **'Logout Success'**
  String get logout_success;

  /// No description provided for @access_key.
  ///
  /// In en, this message translates to:
  /// **'Access key'**
  String get access_key;

  /// No description provided for @email_or_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get email_or_phone_number;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get first_name;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @middle_name.
  ///
  /// In en, this message translates to:
  /// **'Middle name'**
  String get middle_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get last_name;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get username;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @password_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation'**
  String get password_confirmation;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @two.
  ///
  /// In en, this message translates to:
  /// **'Two'**
  String get two;

  /// No description provided for @three.
  ///
  /// In en, this message translates to:
  /// **'Three'**
  String get three;

  /// No description provided for @four.
  ///
  /// In en, this message translates to:
  /// **'Four'**
  String get four;

  /// No description provided for @five.
  ///
  /// In en, this message translates to:
  /// **'Five'**
  String get five;

  /// No description provided for @six.
  ///
  /// In en, this message translates to:
  /// **'Six'**
  String get six;

  /// No description provided for @seven.
  ///
  /// In en, this message translates to:
  /// **'Seven'**
  String get seven;

  /// No description provided for @eight.
  ///
  /// In en, this message translates to:
  /// **'Eight'**
  String get eight;

  /// No description provided for @nine.
  ///
  /// In en, this message translates to:
  /// **'Nine'**
  String get nine;

  /// No description provided for @ten.
  ///
  /// In en, this message translates to:
  /// **'Ten'**
  String get ten;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @executive_team.
  ///
  /// In en, this message translates to:
  /// **'Executive team'**
  String get executive_team;

  /// No description provided for @legal_team.
  ///
  /// In en, this message translates to:
  /// **'Legal team'**
  String get legal_team;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @executive_director.
  ///
  /// In en, this message translates to:
  /// **'Executive Director'**
  String get executive_director;

  /// No description provided for @deputy_director.
  ///
  /// In en, this message translates to:
  /// **'Deputy Director'**
  String get deputy_director;

  /// No description provided for @associate_director.
  ///
  /// In en, this message translates to:
  /// **'Associate Director'**
  String get associate_director;

  /// No description provided for @legal_director.
  ///
  /// In en, this message translates to:
  /// **'Legal Director'**
  String get legal_director;

  /// No description provided for @national_deputy_director.
  ///
  /// In en, this message translates to:
  /// **'National Deputy Director'**
  String get national_deputy_director;

  /// No description provided for @senior_executive.
  ///
  /// In en, this message translates to:
  /// **'Senior Executive'**
  String get senior_executive;

  /// No description provided for @executive_secretary.
  ///
  /// In en, this message translates to:
  /// **'Executive Secretary'**
  String get executive_secretary;

  /// No description provided for @senior_attorney.
  ///
  /// In en, this message translates to:
  /// **'Senior Attorney'**
  String get senior_attorney;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @emails.
  ///
  /// In en, this message translates to:
  /// **'Emails'**
  String get emails;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @phones.
  ///
  /// In en, this message translates to:
  /// **'Phones'**
  String get phones;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get edit_profile;

  /// No description provided for @basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_information;

  /// No description provided for @date_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get date_birth;

  /// No description provided for @country_birth.
  ///
  /// In en, this message translates to:
  /// **'Country of birth'**
  String get country_birth;

  /// No description provided for @select_country.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get select_country;

  /// No description provided for @select_citizenship.
  ///
  /// In en, this message translates to:
  /// **'Select citizenship'**
  String get select_citizenship;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @citizenship.
  ///
  /// In en, this message translates to:
  /// **'Citizenship'**
  String get citizenship;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete confirm'**
  String get delete_confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @edit_email.
  ///
  /// In en, this message translates to:
  /// **'Edit email'**
  String get edit_email;

  /// No description provided for @edit_phone.
  ///
  /// In en, this message translates to:
  /// **'Edit phone'**
  String get edit_phone;

  /// No description provided for @edit_address.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get edit_address;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @is_empty.
  ///
  /// In en, this message translates to:
  /// **'Is empty'**
  String get is_empty;

  /// No description provided for @add_email.
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get add_email;

  /// No description provided for @unsafe.
  ///
  /// In en, this message translates to:
  /// **'Unsafe'**
  String get unsafe;

  /// No description provided for @mailing_address.
  ///
  /// In en, this message translates to:
  /// **'Mailing address'**
  String get mailing_address;

  /// No description provided for @physical_address.
  ///
  /// In en, this message translates to:
  /// **'Physical address'**
  String get physical_address;

  /// No description provided for @add_address.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get add_address;

  /// No description provided for @add_phone.
  ///
  /// In en, this message translates to:
  /// **'Add phone'**
  String get add_phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @box_for_uscis.
  ///
  /// In en, this message translates to:
  /// **'Box for uscis'**
  String get box_for_uscis;

  /// No description provided for @fax.
  ///
  /// In en, this message translates to:
  /// **'Fax'**
  String get fax;

  /// No description provided for @city_email.
  ///
  /// In en, this message translates to:
  /// **'City email'**
  String get city_email;

  /// No description provided for @office_director.
  ///
  /// In en, this message translates to:
  /// **'Office director'**
  String get office_director;

  /// No description provided for @office_director_email.
  ///
  /// In en, this message translates to:
  /// **'Office director email'**
  String get office_director_email;

  /// No description provided for @unregistered.
  ///
  /// In en, this message translates to:
  /// **'Unregistered'**
  String get unregistered;

  /// No description provided for @test_version.
  ///
  /// In en, this message translates to:
  /// **'Test Version'**
  String get test_version;

  /// No description provided for @register_by_key.
  ///
  /// In en, this message translates to:
  /// **'Register by key'**
  String get register_by_key;

  /// No description provided for @key_code.
  ///
  /// In en, this message translates to:
  /// **'Key Code'**
  String get key_code;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @normal_register.
  ///
  /// In en, this message translates to:
  /// **'Normal register'**
  String get normal_register;

  /// No description provided for @i_have_account.
  ///
  /// In en, this message translates to:
  /// **'I have account'**
  String get i_have_account;

  /// No description provided for @active_account.
  ///
  /// In en, this message translates to:
  /// **'Active account'**
  String get active_account;

  /// No description provided for @activation_code.
  ///
  /// In en, this message translates to:
  /// **'Activation code'**
  String get activation_code;

  /// No description provided for @form.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get form;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answers;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @write_another.
  ///
  /// In en, this message translates to:
  /// **'Write another'**
  String get write_another;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @answered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get answered;

  /// No description provided for @created_at.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get created_at;

  /// No description provided for @updated_at.
  ///
  /// In en, this message translates to:
  /// **'Updated on'**
  String get updated_at;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @organizations.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get organizations;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @states.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get states;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @countries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @password_recovery.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get password_recovery;

  /// No description provided for @username_email_phone.
  ///
  /// In en, this message translates to:
  /// **'Username, email or phone'**
  String get username_email_phone;

  /// No description provided for @code_example.
  ///
  /// In en, this message translates to:
  /// **'Code Example: X8EMSP'**
  String get code_example;

  /// No description provided for @change_your_password.
  ///
  /// In en, this message translates to:
  /// **'Change your password'**
  String get change_your_password;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @follow_us.
  ///
  /// In en, this message translates to:
  /// **'Follow us'**
  String get follow_us;

  /// No description provided for @responsibility.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get responsibility;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get option;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @grievance.
  ///
  /// In en, this message translates to:
  /// **'Grievance'**
  String get grievance;

  /// No description provided for @grievances.
  ///
  /// In en, this message translates to:
  /// **'Grievances'**
  String get grievances;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @deposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits'**
  String get deposits;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @payments_refunds.
  ///
  /// In en, this message translates to:
  /// **'Payments and Refunds'**
  String get payments_refunds;

  /// No description provided for @authorized_by.
  ///
  /// In en, this message translates to:
  /// **'Authorized by'**
  String get authorized_by;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date_send.
  ///
  /// In en, this message translates to:
  /// **'Date send'**
  String get date_send;

  /// No description provided for @send_by.
  ///
  /// In en, this message translates to:
  /// **'Send by'**
  String get send_by;

  /// No description provided for @mm_fees.
  ///
  /// In en, this message translates to:
  /// **'Mil Mujeres fees'**
  String get mm_fees;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get payment_method;

  /// No description provided for @note_or_service_paid.
  ///
  /// In en, this message translates to:
  /// **'Note or service paid'**
  String get note_or_service_paid;

  /// No description provided for @deposit_type.
  ///
  /// In en, this message translates to:
  /// **'Deposit type'**
  String get deposit_type;

  /// No description provided for @credit_card_person_name.
  ///
  /// In en, this message translates to:
  /// **'Credit card person name'**
  String get credit_card_person_name;

  /// No description provided for @staate.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get staate;

  /// No description provided for @staates.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get staates;

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stage;

  /// No description provided for @stages.
  ///
  /// In en, this message translates to:
  /// **'Stages'**
  String get stages;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @caases.
  ///
  /// In en, this message translates to:
  /// **'Cases'**
  String get caases;

  /// No description provided for @caase.
  ///
  /// In en, this message translates to:
  /// **'Case'**
  String get caase;

  /// No description provided for @caases_stage.
  ///
  /// In en, this message translates to:
  /// **'Cases stage'**
  String get caases_stage;

  /// No description provided for @activity_log.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activity_log;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @uploads.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploads;

  /// No description provided for @upload_file.
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get upload_file;

  /// No description provided for @upload_files.
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get upload_files;

  /// No description provided for @remove_account.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get remove_account;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @document_request.
  ///
  /// In en, this message translates to:
  /// **'Document request'**
  String get document_request;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @pending_review.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get pending_review;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @registration_request.
  ///
  /// In en, this message translates to:
  /// **'Registration request'**
  String get registration_request;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @financial_manager.
  ///
  /// In en, this message translates to:
  /// **'Financial Manager'**
  String get financial_manager;

  /// No description provided for @human_resources_manager.
  ///
  /// In en, this message translates to:
  /// **'Human Resources Manager'**
  String get human_resources_manager;

  /// No description provided for @information_technology_coordinator.
  ///
  /// In en, this message translates to:
  /// **'Information Technology Coordinator'**
  String get information_technology_coordinator;

  /// No description provided for @public_relations_coordinator.
  ///
  /// In en, this message translates to:
  /// **'Public Relations Coordinator'**
  String get public_relations_coordinator;

  /// No description provided for @corporate_communications_coordinator.
  ///
  /// In en, this message translates to:
  /// **'Corporate Communications Coordinator'**
  String get corporate_communications_coordinator;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @important_events.
  ///
  /// In en, this message translates to:
  /// **'Important Events'**
  String get important_events;

  /// No description provided for @important_blogs.
  ///
  /// In en, this message translates to:
  /// **'Important Blogs'**
  String get important_blogs;

  /// No description provided for @event_type.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get event_type;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @upcoming_events.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcoming_events;

  /// No description provided for @past_events.
  ///
  /// In en, this message translates to:
  /// **'Past Events'**
  String get past_events;

  /// No description provided for @event_date.
  ///
  /// In en, this message translates to:
  /// **'Event date at local time'**
  String get event_date;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @internet_error.
  ///
  /// In en, this message translates to:
  /// **'You have no internet connection. Please check your connection.'**
  String get internet_error;

  /// No description provided for @inmigration_attorney.
  ///
  /// In en, this message translates to:
  /// **'Attorney Inmigration'**
  String get inmigration_attorney;

  /// No description provided for @case_details.
  ///
  /// In en, this message translates to:
  /// **'Case Details'**
  String get case_details;

  /// No description provided for @see_details.
  ///
  /// In en, this message translates to:
  /// **'See Details'**
  String get see_details;

  /// No description provided for @case_type.
  ///
  /// In en, this message translates to:
  /// **'Case Type'**
  String get case_type;

  /// No description provided for @progress_chart.
  ///
  /// In en, this message translates to:
  /// **'Case Progress'**
  String get progress_chart;

  /// No description provided for @state_pending.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get state_pending;

  /// No description provided for @state_reviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get state_reviewed;

  /// No description provided for @state_accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get state_accepted;

  /// No description provided for @state_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get state_rejected;

  /// No description provided for @state_moved_to_drive.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get state_moved_to_drive;

  /// No description provided for @state_deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get state_deleted;

  /// No description provided for @last_state.
  ///
  /// In en, this message translates to:
  /// **'Last State'**
  String get last_state;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @view_instructions.
  ///
  /// In en, this message translates to:
  /// **'View Instructions'**
  String get view_instructions;

  /// No description provided for @document_type.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get document_type;

  /// No description provided for @donate_message.
  ///
  /// In en, this message translates to:
  /// **'Help us help more people!'**
  String get donate_message;

  /// No description provided for @error_coordinates.
  ///
  /// In en, this message translates to:
  /// **'Error loading coordinates'**
  String get error_coordinates;

  /// No description provided for @no_elements.
  ///
  /// In en, this message translates to:
  /// **'No elements avalaible'**
  String get no_elements;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @insecure.
  ///
  /// In en, this message translates to:
  /// **'Insecure'**
  String get insecure;

  /// No description provided for @at_least_one_required.
  ///
  /// In en, this message translates to:
  /// **'At least one required'**
  String get at_least_one_required;

  /// No description provided for @homeDescription.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get homeDescription;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginDescription;

  /// No description provided for @dashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'View dashboard'**
  String get dashboardDescription;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get profileDescription;

  /// No description provided for @eventsDescription.
  ///
  /// In en, this message translates to:
  /// **'See events'**
  String get eventsDescription;

  /// No description provided for @mm_actionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Active initiatives'**
  String get mm_actionsDescription;

  /// No description provided for @upload_fileDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get upload_fileDescription;

  /// No description provided for @officesDescription.
  ///
  /// In en, this message translates to:
  /// **'View offices'**
  String get officesDescription;

  /// No description provided for @consulatesDescription.
  ///
  /// In en, this message translates to:
  /// **'View consulates'**
  String get consulatesDescription;

  /// No description provided for @alliances_referencesDescription.
  ///
  /// In en, this message translates to:
  /// **'See alliances'**
  String get alliances_referencesDescription;

  /// No description provided for @deposits_refundsDescription.
  ///
  /// In en, this message translates to:
  /// **'View deposits'**
  String get deposits_refundsDescription;

  /// No description provided for @caases_stageDescription.
  ///
  /// In en, this message translates to:
  /// **'Case status'**
  String get caases_stageDescription;

  /// No description provided for @donateDescription.
  ///
  /// In en, this message translates to:
  /// **'Donate now'**
  String get donateDescription;

  /// No description provided for @contact_usDescription.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contact_usDescription;

  /// No description provided for @complaintsDescription.
  ///
  /// In en, this message translates to:
  /// **'Send complaint'**
  String get complaintsDescription;

  /// No description provided for @how_meet.
  ///
  /// In en, this message translates to:
  /// **'How did you meet us?'**
  String get how_meet;

  /// No description provided for @complete_information.
  ///
  /// In en, this message translates to:
  /// **'Complete Information'**
  String get complete_information;

  /// No description provided for @please_complete_information.
  ///
  /// In en, this message translates to:
  /// **'Please complete the following information'**
  String get please_complete_information;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_and_conditions;

  /// No description provided for @accept_terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Accept Terms and Conditions'**
  String get accept_terms_and_conditions;

  /// No description provided for @signature_success.
  ///
  /// In en, this message translates to:
  /// **'The terms and conditions have been accepted correctly.'**
  String get signature_success;

  /// No description provided for @error_try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Error try again later.'**
  String get error_try_again_later;

  /// No description provided for @access_key_txt.
  ///
  /// In en, this message translates to:
  /// **'If you are currently a client of Mil Mujeres, please request \n \n your Access Key at 202 808 3311'**
  String get access_key_txt;

  /// No description provided for @contact_to_request.
  ///
  /// In en, this message translates to:
  /// **'Contact Mil Mujeres to request your registration or activate your account at 202 808 3311.'**
  String get contact_to_request;

  /// No description provided for @have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?'**
  String get have_an_account;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @mm_about_txt.
  ///
  /// In en, this message translates to:
  /// **'Mil Mujeres is a non-profit organization that was founded in 2007 to address the growing need for bilingual legal services for the Latino community in the United States with an emphasis on helping survivors of violent crime, including domestic violence, sexual assault, and assault, \n \n In the last years, we have helped more than five thousand people with our legal services and more than twenty thousand people with our information services throughout the national territory.'**
  String get mm_about_txt;

  /// No description provided for @mm_description.
  ///
  /// In en, this message translates to:
  /// **'Mil Mujeres is a non-profit organization that was founded in 2007 to address the growing need for bilingual legal services for the Latino community in the United States with an emphasis on helping survivors of violent crime, including domestic violence, sexual assault, and assault.'**
  String get mm_description;

  /// No description provided for @mm_what_we_do.
  ///
  /// In en, this message translates to:
  /// **'In the last years, we have helped more than five thousand people with our legal services and more than twenty thousand people with our information services throughout the national territory'**
  String get mm_what_we_do;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account!'**
  String get already_have_an_account;

  /// No description provided for @dont_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_an_account;

  /// No description provided for @please_login_necessary.
  ///
  /// In en, this message translates to:
  /// **'Please login necessary.'**
  String get please_login_necessary;

  /// No description provided for @information_updated.
  ///
  /// In en, this message translates to:
  /// **'Information updated.'**
  String get information_updated;

  /// No description provided for @error_updating_try_in_other_time.
  ///
  /// In en, this message translates to:
  /// **'Error updating try in other time.'**
  String get error_updating_try_in_other_time;

  /// No description provided for @accepted_key_please_update_your_password.
  ///
  /// In en, this message translates to:
  /// **'Accepted key, please update your password.'**
  String get accepted_key_please_update_your_password;

  /// No description provided for @error_key_not_found.
  ///
  /// In en, this message translates to:
  /// **'Error key not found.'**
  String get error_key_not_found;

  /// No description provided for @account_updated_go_to_login_page.
  ///
  /// In en, this message translates to:
  /// **'Account updated, go to login page.'**
  String get account_updated_go_to_login_page;

  /// No description provided for @check_your_email_inbox_txt.
  ///
  /// In en, this message translates to:
  /// **'Check your email inbox and activate the account with the code we sent you.'**
  String get check_your_email_inbox_txt;

  /// No description provided for @server_error_loading_contacts.
  ///
  /// In en, this message translates to:
  /// **'Server error loading contacts.'**
  String get server_error_loading_contacts;

  /// No description provided for @your_message_has_been_send.
  ///
  /// In en, this message translates to:
  /// **'Your message has been send.'**
  String get your_message_has_been_send;

  /// No description provided for @contribute_to_our_cause.
  ///
  /// In en, this message translates to:
  /// **'Contribute to our cause!'**
  String get contribute_to_our_cause;

  /// No description provided for @nothing_to_show.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show.'**
  String get nothing_to_show;

  /// No description provided for @write_username_email_or_recover_password.
  ///
  /// In en, this message translates to:
  /// **'Write the username, email or phone to recover your password'**
  String get write_username_email_or_recover_password;

  /// No description provided for @write_the_code_that_we_send_to_your_email.
  ///
  /// In en, this message translates to:
  /// **'Write the code that we send to your email'**
  String get write_the_code_that_we_send_to_your_email;

  /// No description provided for @password_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get password_updated_successfully;

  /// No description provided for @your_complain_has_been_send.
  ///
  /// In en, this message translates to:
  /// **'Your complain has been send.'**
  String get your_complain_has_been_send;

  /// No description provided for @wrong_activation_code.
  ///
  /// In en, this message translates to:
  /// **'Wrong activation code.'**
  String get wrong_activation_code;

  /// No description provided for @your_grievance_has_been_send.
  ///
  /// In en, this message translates to:
  /// **'Your grievance has been send.'**
  String get your_grievance_has_been_send;

  /// No description provided for @are_you_sure_you_want_to_delete_your_account.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get are_you_sure_you_want_to_delete_your_account;

  /// No description provided for @your_account_has_been_removed.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted'**
  String get your_account_has_been_removed;

  /// No description provided for @the_answer_is_wrong.
  ///
  /// In en, this message translates to:
  /// **'The answer is wrong'**
  String get the_answer_is_wrong;

  /// No description provided for @username_or_password_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Username or password incorrect'**
  String get username_or_password_incorrect;

  /// No description provided for @deleting_account.
  ///
  /// In en, this message translates to:
  /// **'Deleting account'**
  String get deleting_account;

  /// No description provided for @this_record_already_exist.
  ///
  /// In en, this message translates to:
  /// **'This record already exist'**
  String get this_record_already_exist;

  /// No description provided for @your_evaluation_request_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Your evaluation request is in process, in the next few hours you will be contacted by the email or telephone number provided to take your information and review your case.'**
  String get your_evaluation_request_in_progress;

  /// No description provided for @your_case_is_in_evaluation.
  ///
  /// In en, this message translates to:
  /// **'Your case is in an evaluation process. At the end of this stage, we will contact you and you will see more information'**
  String get your_case_is_in_evaluation;

  /// No description provided for @visit_events.
  ///
  /// In en, this message translates to:
  /// **'For more events or details, visit the events section.'**
  String get visit_events;

  /// No description provided for @mm_donate_txt.
  ///
  /// In en, this message translates to:
  /// **'Your donations will provide important support for the purpose of defending the rights of immigrants and the protection of victims of domestic violence and gender-based crimes.'**
  String get mm_donate_txt;

  /// No description provided for @terms_and_conditions_text.
  ///
  /// In en, this message translates to:
  /// **'1. The documents you upload to the application will be used exclusively for the review, analysis, and follow-up of the legal process related to your case.\n\n2. You declare that the documents you upload are truthful, complete, and your legitimate property, or that you have the necessary authorization to provide them. Mil Mujeres is not responsible for the accuracy or authenticity of the information contained in the uploaded files.\n\n3. All documents will be treated with strict confidentiality and in accordance with the current regulations on personal data protection. Only authorized Mil Mujeres staff will have access to your information.\n\n4. It is strictly prohibited to upload documents that are not related to the corresponding legal process, that contain offensive or illegal material, that infringe the rights of third parties, or that include viruses, malware, or any element that may damage the system.\n\n5. Mil Mujeres will not be responsible for errors arising from the upload of illegible, incomplete, falsified documents, or documents delivered outside the deadlines established for the legal process.\n\n6. By uploading documents to the application, you give your express consent for them to be reviewed, stored, and used by Mil Mujeres solely for legal purposes related to your case.\n\n7. Mil Mujeres may modify these terms and conditions when necessary, always ensuring the protection and confidentiality of the information. Users will be duly notified of any changes.'**
  String get terms_and_conditions_text;

  /// No description provided for @terms_and_conditions_summary.
  ///
  /// In en, this message translates to:
  /// **'Your documents will only be used for your legal case, must be truthful, and will be kept confidential. Do not upload illegal, false, or harmful files. By uploading, you consent to their legal use and accept that terms may change.'**
  String get terms_and_conditions_summary;

  /// No description provided for @read_full.
  ///
  /// In en, this message translates to:
  /// **'Read full for accept'**
  String get read_full;

  /// Validating any input
  ///
  /// In en, this message translates to:
  /// **'{item} is required'**
  String is_required(String item);

  /// Minim length
  ///
  /// In en, this message translates to:
  /// **'{itemq} is the fewest characters'**
  String fewest_characters(String itemq);

  /// Exact length
  ///
  /// In en, this message translates to:
  /// **'The {item_mh1} must have {item_mh2} characters'**
  String must_have(String item_mh1, String item_mh2);

  /// Not match
  ///
  /// In en, this message translates to:
  /// **'{itemnm} do not match'**
  String not_match(String itemnm);

  /// Enter valid item
  ///
  /// In en, this message translates to:
  /// **'Enter valid {itemv}'**
  String enter_valid(String itemv);

  /// Are you sure to delete item
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this {iteme}?'**
  String are_you_sure_delete(String iteme);

  /// No description provided for @pageSettingsInputLanguage.
  ///
  /// In en, this message translates to:
  /// **'{locale, select, ar {عربي} en {English} es {Español} other {-}}'**
  String pageSettingsInputLanguage(String locale);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
