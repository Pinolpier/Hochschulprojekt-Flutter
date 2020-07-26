import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:univents/backend/event_service.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/constants/constants.dart';
import 'package:univents/model/event.dart';
import 'package:univents/model/eventTag.dart';
import 'package:univents/service/date_time_picker_univents.dart';
import 'package:univents/service/image_picker_univents.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/page_controller.dart';
import 'package:univents/service/toast.dart';
import 'package:univents/view/dialogs/friend_list_dialog.dart';
import 'package:univents/view/location_picker_screen.dart';

/// @author Jan Oster, Markus Häring
/// this class creates an createEventScreen which opens if you want to create a event

class CreateEventScreen extends StatefulWidget {
  /// latitude and longitude of the location you clicked on the map where you want to create your event
  final List<String> tappedPoint;

  /// constructor gets the tappedPoint from the map
  CreateEventScreen(this.tappedPoint, {Key key}) : super(key: key);

  /// todo: missing documentation
  @override
  State createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  List<EventTag> _tagsList;

  @override
  void initState() {
    _tagsList = [];
    _attendeeIDs = [];
    super.initState();
  }

  @override
  void dispose() {
    _tagsList.clear();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// specified event start date
  DateTime _selectedBeginDateTime;

  /// specified event end date
  DateTime _selectedEndDateTime;

  /// specified privacy setting of event
  bool _isPrivate = false;

  /// specified tags of the event

  /// specified attendees of the event
  List<dynamic> _attendeeIDs = new List();

  /// used to read the inputted text of the event name
  TextEditingController _eventNameController = new TextEditingController();

  TextEditingController _beginDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();

  /// used to read the inputted text of the event location
  TextEditingController _eventLocationController = new TextEditingController();

  /// used to read the inputted text of the event description
  TextEditingController _eventDescriptionController =
      new TextEditingController();

  /// used to read the inputted text of the event tags
  TextEditingController _eventTagsController = new TextEditingController();

  /// specified event image
  File _eventImage;

  /// imagePicker for selecting the image from device
  ImagePickerUnivents _ip = new ImagePickerUnivents();
  InterfaceToReturnPickedLocation _returnPickedLocation =
      new InterfaceToReturnPickedLocation();

  ///Box styles to set a red border around invalid fields
  BoxDecoration _eventNameBoxStyle = boxStyleConstant;
  BoxDecoration _beginDateBoxStyle = boxStyleConstant;
  BoxDecoration _endDateBoxStyle = boxStyleConstant;
  BoxDecoration _locationBoxStyle = boxStyleConstant;

  /// This Widget displays a placeholder image if no event image is specified
  Widget _eventImagePlaceholder() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await _ip.chooseImage(context);
          setState(() {
            _eventImage = eventImageAsync;
          });
        }, // handle your image tap here
        child: Image.asset('assets/eventImagePlaceholder.png', height: 150));
  }

  /// This widget displays the event image if set
  Widget _eventImageWidget() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await _ip.chooseImage(context);
          setState(() {
            _eventImage = eventImageAsync;
          }); // handle your image tap here
        },
        child: Image.file(_eventImage, height: 150));
  }

  /// This widgets displays a datetime textformfield with a dateTimePicker on tab
  Widget _beginDateTimeWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Beginn',
            style: labelStyleConstant,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: _beginDateBoxStyle,
            height: 60.0,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty ||
                    _selectedBeginDateTime.isBefore(DateTime.now())) {
                  setState(() {
                    _beginDateBoxStyle = boxErrorStyleConstant;
                  });
                  return "";
                } else {
                  setState(() {
                    _beginDateBoxStyle = boxStyleConstant;
                  });
                  return null;
                }
              },
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectedBeginDateTime = await getDateTime(context);
                _beginDateController.text =
                    dateTimeShortDateFormat.format(_selectedBeginDateTime);
              },
              controller: _beginDateController,
              keyboardType: TextInputType.datetime,
              style: TextStyle(
                color: univentsWhiteText,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.date_range,
                  color: univentsWhiteBackground,
                ),
                hintText: 'Set begin',
                hintStyle: textStyleConstant,
                errorStyle: TextStyle(height: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This widgets displays a datetime textformfield with a dateTimePicker on tab
  Widget _endDateTimeWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ende',
            style: labelStyleConstant,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: _endDateBoxStyle,
            height: 60.0,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty ||
                    _selectedEndDateTime.isBefore(
                        _selectedBeginDateTime.add(Duration(minutes: 1)))) {
                  setState(() {
                    _endDateBoxStyle = boxErrorStyleConstant;
                  });
                  return "";
                } else {
                  setState(() {
                    _endDateBoxStyle = boxStyleConstant;
                  });
                  return null;
                }
              },
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectedEndDateTime =
                    await getDateTime(context, _selectedBeginDateTime);
                _endDateController.text =
                    dateTimeShortDateFormat.format(_selectedEndDateTime);
              },
              controller: _endDateController,
              keyboardType: TextInputType.datetime,
              style: TextStyle(
                color: univentsWhiteText,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.date_range,
                  color: univentsWhiteBackground,
                ),
                hintText: 'Set end',
                hintStyle: textStyleConstant,
                errorStyle: TextStyle(height: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This widget displays a textfield to input the event name
  Widget _eventNameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Name',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: _eventNameBoxStyle,
          height: 60.0,
          child: TextFormField(
            controller: _eventNameController,
            validator: (value) {
              if (value.isEmpty) {
                setState(() {
                  _eventNameBoxStyle = boxErrorStyleConstant;
                });
                return "";
              } else {
                setState(() {
                  _eventNameBoxStyle = boxStyleConstant;
                });
                return null;
              }
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.create,
                  color: univentsWhiteBackground,
                ),
                hintText: 'Enter the event name',
                hintStyle: textStyleConstant,
                errorStyle: TextStyle(height: 0)),
          ),
        ),
      ],
    );
  }

  /// This widget displays a textfield to input the event description
  Widget _descriptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Description',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.topLeft,
          decoration: boxStyleConstant,
          height: 120.0,
          child: TextField(
            controller: _eventDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.comment,
                color: univentsWhiteBackground,
              ),
              hintText: 'Enter the event details',
              hintStyle: textStyleConstant,
            ),
          ),
        ),
      ],
    );
  }

  /// This widget displays a textfield to input the event tags, separated by comma e.g. Tag1, Tag2, Tag3, ...
  Widget _tagsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Tags',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        FlutterTagging<EventTag>(
          initialItems: _tagsList,
          textFieldConfiguration: TextFieldConfiguration(
            style: TextStyle(color: univentsWhiteText),
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(borderRadiusStyle),
                ),
              ),
              fillColor: univentsLightBlue,
              filled: true,
              prefixIcon: Icon(
                Icons.label_outline,
                color: univentsWhiteBackground,
              ),
              hintStyle: textStyleConstant,
              hintText: 'Search Tags',
            ),
          ),
          findSuggestions: EventTagService.getTagSuggestions,
          additionCallback: (value) {
            return EventTag(
              tag: value,
            );
          },
          onAdded: (language) {
            return language;
          },
          configureSuggestion: (lang) {
            return SuggestionConfiguration(
              title: Text(lang.tag),
              additionWidget: Chip(
                avatar: Icon(
                  Icons.add_circle,
                  color: Colors.white,
                ),
                label: Text('Add New Tag'),
                labelStyle: TextStyle(
                  color: univentsWhiteText,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                ),
                backgroundColor: univentsTagColor,
              ),
            );
          },
          configureChip: (lang) {
            return ChipConfiguration(
              label: Text(lang.tag),
              backgroundColor: univentsTagColor,
              labelStyle: TextStyle(color: univentsWhiteText),
              deleteIconColor: univentsWhiteText,
            );
          },
        ),
      ],
    );
  }

  Widget _locationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event location',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: _locationBoxStyle,
          height: 60.0,
          child: TextFormField(
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      new LocationPickerScreen(_returnPickedLocation)));
              _eventLocationController.text =
                  _returnPickedLocation.choosenLocationName;
            },
            controller: _eventLocationController,
            validator: (value) {
              if (value.isEmpty ||
                  _returnPickedLocation.choosenLocationCoords.isEmpty) {
                _locationBoxStyle = boxErrorStyleConstant;
                return "";
              } else {
                _locationBoxStyle = boxStyleConstant;
                return null;
              }
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: univentsWhiteBackground,
                ),
                hintText: 'Choose location...',
                hintStyle: textStyleConstant,
                errorStyle: TextStyle(height: 0)),
          ),
        ),
      ],
    );
  }

  Widget _visibilityWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sichtbarkeit',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          height: 60.0,
          child: ToggleSwitch(
            minWidth: 150.0,
            cornerRadius: 20.0,
            activeBgColor: univentsSelected,
            activeFgColor: univentsWhiteText,
            inactiveBgColor: univentsNotSelected,
            inactiveFgColor: univentsWhiteText,
            labels: ['Privat', 'Öffentlich'],
            icons: [Icons.perm_contact_calendar, Icons.public],
            onToggle: (index) {
              setState(() {
                _isPrivate = index == 0;
              });
            },
          ),
        ),
      ],
    );
  }

  //TODO change look to a better one
  Widget _invitedFriendsListItemWidget(index, attendeeId) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(attendeeId.toString()),
              IconButton(
                icon: Icon(Icons.cancel),
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _attendeeIDs.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
        index < _attendeeIDs.length - 1 ? Divider() : SizedBox(),
      ],
    );
  }

  Widget _friendsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Freunde',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        SizedBox(
          child: Container(
//        alignment: Alignment.centerLeft,
            decoration: _locationBoxStyle,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _attendeeIDs.length,
              itemBuilder: (context, index) {
                return _invitedFriendsListItemWidget(
                    index, _attendeeIDs[index]);
              },
            ),
          ),
        )
      ],
    );
  }

  /// This button opens the select friends dialog
  Widget _addFriendsButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          List<String> preSelectedAttendeeIDs = List();
          _attendeeIDs.forEach((element) {
            preSelectedAttendeeIDs.add(element.toString());
          });
          final List<String> result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FriendslistdialogScreen(null, preSelectedAttendeeIDs),
              ));
          setState(() {
            _attendeeIDs.clear();
            for (String s in result) {
              _attendeeIDs.add(s);
            }
          });
          //ID von alles ausgewähleten Freunde-Objekten in anttendeeIDs speichern (als String ind die Liste)
          //Friendslist schließen
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          'add friends',
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  /// This button creates the event with the specified variables and sends it to the backend
  Widget _createButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            List<String> tags = [];
            _tagsList.forEach((element) {
              tags.add(element.tag);
            });
            Event event = new Event(
                _eventNameController.text,
                _selectedBeginDateTime,
                _selectedEndDateTime,
                _eventDescriptionController.text,
                _returnPickedLocation.choosenLocationName,
                _isPrivate,
                _attendeeIDs,
                tags,
                _returnPickedLocation.choosenLocationCoords[1].toString(),
                _returnPickedLocation.choosenLocationCoords[0].toString());
            try {
              createEvent(_eventImage, event);
            } on PlatformException catch (e) {
              show_toast(exceptionHandling(e));
              Log().error(
                  causingClass: 'createEvent_screen',
                  method: '_createButtonWidget',
                  action: exceptionHandling(e));
            }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NavigationBarUI()),
                  (Route<dynamic> route) => false,
            );
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          'CREATE',
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _eventImageBlockWidget() {
    return Stack(
      children: <Widget>[
        _eventImage != null
            ? Stack(
          children: <Widget>[
            SizedBox(
              height: 200,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: FittedBox(
                child: _eventImageWidget(),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            Positioned.fill(
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 15.0,
                      sigmaY: 0,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ))),
          ],
        )
            : Container(),
        SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 200,
          child: _eventImage == null
              ? _eventImagePlaceholder()
              : _eventImageWidget(),
        )
      ],
    );
  }

  Widget _eventDateBlockWidget() {
    return Row(
      children: <Widget>[
        _beginDateTimeWidget(),
        SizedBox(width: 20.0),
        _endDateTimeWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Create Your Event"),
        centerTitle: true,
      ),
      backgroundColor: primaryColor,
      body: new Container(
        height: double.infinity,
        child: SingleChildScrollView(
          //fixes pixel overflow error when keyboard is used
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _eventImageBlockWidget(),
                Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 40.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        _eventNameWidget(),
                        SizedBox(height: 20.0),
                        _eventDateBlockWidget(),
                        SizedBox(height: 20.0),
                        _locationWidget(),
                        SizedBox(height: 20.0),
                        _descriptionWidget(),
                        SizedBox(height: 20.0),
                        _tagsWidget(),
                        SizedBox(height: 20.0),
                        _visibilityWidget(),
                        SizedBox(height: 20.0),
                        _friendsWidget(),
                        _addFriendsButtonWidget(),
                        _createButtonWidget(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
