import 'dart:convert';
import 'package:coffee_shop_admin/services/apis/location_api.dart';
import 'package:coffee_shop_admin/services/blocs/map_picker/map_picker_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/map_picker/map_picker_state.dart';
import 'package:coffee_shop_admin/services/models/location.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreenDialog extends StatefulWidget {
  final GoogleMapController? mapController;
  const LocationScreenDialog({super.key, required this.mapController});

  @override
  State<LocationScreenDialog> createState() => _LocationScreenDialogState();
}

class _LocationScreenDialogState extends State<LocationScreenDialog> {
  final TextEditingController textController = TextEditingController();
  bool isShowClearButton = false;

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      setState(() {
        isShowClearButton = textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: BlocBuilder<MapPickerBloc, MapPickerState>(builder: (context, state) {
          return Stack(children: [
            TypeAheadField<MLocation>(
              loadingBuilder: (context) =>
                  SizedBox(height: Dimension.height230, child: Center(child: CircularProgressIndicator())),
              textFieldConfiguration: TextFieldConfiguration(
                  controller: textController,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: Dimension.width40, vertical: Dimension.height16),
                    hintText: 'search...',
                    hintStyle: AppText.style.regularGrey16,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                    ),
                  ),
                  style: AppText.style.regularBlack16),
              suggestionsCallback: (query) {
                if (query.isNotEmpty) {
                  return LocationApi.getLocationData(query).then((response) {
                    var data = jsonDecode(response.body.toString());
                    if (data['status'] == 'OK') {
                      return MLocation.parseLocationList(data);
                    }
                    return [];
                  });
                } else {
                  return [];
                }
              },
              itemBuilder: (context, suggestion) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.blueColor,
                    ),
                    Expanded(
                        child: Text(
                      suggestion.formattedAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.style.regularBlack14,
                    )),
                  ]),
                );
              },
              onSuggestionSelected: (suggestion) {
                Navigator.of(context).pop(suggestion);
              },
            ),
            Positioned(top: Dimension.height16, left: Dimension.width8, child: Icon(Icons.search)),
            isShowClearButton
                ? Positioned(
                    top: Dimension.height4,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          textController.clear();
                        },
                        icon: Icon(Icons.clear)),
                  )
                : SizedBox.shrink(),
          ]);
        }),
      ),
    );
  }
}
