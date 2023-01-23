import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/map.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:admin/screens/RequestManagement/Shelter_component/shelter_Manager.dart';
import 'package:admin/screens/RequestManagement/Shelter_component/shelterStats.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/mapZoom.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      mapViews(),
                      SizedBox(height: defaultPadding),
                      SummaryInfo(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.height / 2,
                      child: ShelterManagers(),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
