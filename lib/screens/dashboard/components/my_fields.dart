import 'package:admin/models/MyFiles.dart';
import 'package:admin/models/shelter.dart';
import 'package:admin/models/victim.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class SummaryInfo extends StatelessWidget {
  const SummaryInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  String openShelterCount(shelters) {
    int open = 0;
    for (var shelter in shelters)
      if (shelter.status == true) {
        open += 1;
      }
    return open.toString();
  }

  String victimNeedHelp(victims) {
    int open = 0;
    for (var victim in victims)
      if (victim.status == true) {
        open += 1;
      }
    return open.toString();
  }

  @override
  Widget build(BuildContext context) {
    final _shelters = Provider.of<List<Shelter>>(context);
    final _victims = Provider.of<List<Victim>>(context);

    List GridInfo = [
      CloudStorageInfo(
        title: "Total Shelter",
        numOfFiles: 1328,
        totalStorage: _shelters.length.toString(),
        color: Colors.red,
        percentage: 0,
      ),
      CloudStorageInfo(
        title: "Open Shelter",
        numOfFiles: 1328,
        svgSrc: "assets/icons/google_drive.svg",
        totalStorage: openShelterCount(_shelters),
        color: Colors.red,
        percentage: 0,
      ),
      CloudStorageInfo(
        title: "Need Help",
        numOfFiles: 1328,
        svgSrc: "assets/icons/one_drive.svg",
        totalStorage: victimNeedHelp(_victims),
        color: Colors.red,
        percentage: 0,
      ),
      CloudStorageInfo(
        title: "Active User",
        numOfFiles: 5328,
        svgSrc: "assets/icons/drop_box.svg",
        totalStorage: "1",
        color: Colors.red,
        percentage: 0,
      ),
    ];
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: GridInfo.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: GridInfo[index]),
    );
  }
}
