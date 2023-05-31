import 'dart:convert';

import 'package:coffee_shop_admin/services/blocs/map_picker/map_picker_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/map_picker/map_picker_event.dart';
import 'package:coffee_shop_admin/services/blocs/map_picker/map_picker_state.dart';
import 'package:coffee_shop_admin/services/models/location.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/apis/location_api.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/custom_app_bar.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "/map_screen";
  final LatLng? latLng;
  const MapScreen({super.key, required this.latLng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng draggedLatlng;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isShowClearButton = false;
  bool isSearching = false;

  @override
  void initState() {
    draggedLatlng =
        widget.latLng ?? LatLng(10.870023145812784, 106.80306064596698);
    textController.addListener(() {
      setState(() {
        isShowClearButton = textController.text.isNotEmpty;
      });
    });
    focusNode.addListener(() {
      setState(() {
        isSearching = focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Expanded(
                child: Stack(
              children: [_getMap(), _getCustomPin(), _showDraggedAddress()],
            )),
            CustomAppBar(
              color: Colors.transparent,
              middle: BlocBuilder<MapPickerBloc, MapPickerState>(
                  builder: (context, state) {
                return Stack(children: [
                  TypeAheadField<MLocation>(
                    noItemsFoundBuilder: (context) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimension.height16,
                          horizontal: Dimension.width16),
                      child: Text(
                        "No location found",
                        style: AppText.style.regularBlack14,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    loadingBuilder: (context) => SizedBox(
                        height: Dimension.height230,
                        child: Center(child: CircularProgressIndicator())),
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: textController,
                        focusNode: focusNode,
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: Dimension.width40,
                              vertical: Dimension.height8),
                          hintText: 'Search...',
                          hintStyle: AppText.style.regularGrey16,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: AppColors.greyBoxColor),
                          ),
                        ),
                        style: AppText.style.regularBlack16),
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        return LocationApi.getLocationData(query)
                            .then((response) {
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
                      BlocProvider.of<MapPickerBloc>(context).add(MoveCamera(
                          location: LatLng(suggestion.lat, suggestion.lng)));

                      focusNode.unfocus();
                    },
                  ),
                  Positioned(
                      top: Dimension.height10,
                      left: Dimension.width8,
                      child: Icon(
                        Icons.search,
                        color:
                            isSearching ? Colors.blue : AppColors.greyTextColor,
                      )),
                  isShowClearButton
                      ? Positioned(
                          right: 0,
                          child: IconButton(
                              onPressed: () {
                                textController.clear();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: isSearching
                                    ? Colors.blue
                                    : AppColors.greyTextColor,
                              )),
                        )
                      : const SizedBox.shrink(),
                ]);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showDraggedAddress() {
    return Positioned(
      bottom: Dimension.height16,
      left: Dimension.width16,
      right: Dimension.width16,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimension.width16, vertical: Dimension.height8),
          child: BlocBuilder<MapPickerBloc, MapPickerState>(
              builder: (context, state) {
            if (state is LoaddingLocation) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimension.height8,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is LoaddedLocation) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    state.currentLocation,
                    style: AppText.style.mediumBlack14,
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  ),
                  TextButton(
                      onPressed: () async {
                        print(draggedLatlng.latitude);
                        print(draggedLatlng.longitude);
                        print(state.currentLocation);
                        Navigator.of(context).pop(MLocation(
                            formattedAddress: state.currentLocation,
                            lat: draggedLatlng.latitude,
                            lng: draggedLatlng.longitude));
                      },
                      child: Text(
                        "Select this address",
                        style: AppText.style.regularBlue16,
                      ))
                ],
              );
            } else if (state is LoaddedErrorLocation) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimension.height8,
                ),
                child: Center(
                  child: Text(
                    "Location not found",
                    style: AppText.style.mediumBlack14,
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }

  Widget _getMap() {
    return IgnorePointer(
      ignoring: isSearching,
      child:
          BlocBuilder<MapPickerBloc, MapPickerState>(builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
              target: widget.latLng ??
                  LatLng(10.870023145812784, 106.80306064596698),
              zoom: 20),
          mapType: MapType.normal,
          onCameraIdle: () {
            BlocProvider.of<MapPickerBloc>(context)
                .add(UpdatedLocation(location: draggedLatlng));
          },
          onCameraMove: (cameraPosition) {
            BlocProvider.of<MapPickerBloc>(context).add(UpdatingLocation());
            draggedLatlng = cameraPosition.target;
          },
          onMapCreated: (GoogleMapController controller) {
            BlocProvider.of<MapPickerBloc>(context).add(InitController(
                controller: controller,
                currentLocation: widget.latLng ??
                    LatLng(10.870023145812784, 106.80306064596698)));
          },
          zoomControlsEnabled: false,
        );
      }),
    );
  }

  Widget _getCustomPin() {
    return Center(
      child: IconTheme(
        data: IconThemeData(
          size: 40,
        ),
        child: Icon(
          Icons.location_on,
          color: AppColors.redColor,
        ),
      ),
    );
  }
}
