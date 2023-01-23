import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_files.dart';
import 'package:flutter/material.dart';

class shelterStatus extends StatefulWidget {
  const shelterStatus({Key? key}) : super(key: key);

  @override
  State<shelterStatus> createState() => _shelterStatusState();
}

class _shelterStatusState extends State<shelterStatus> {
  @override
  Widget build(BuildContext context) {
    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();

    return Column(
      children: [
        Text(
          "Shelter Summary",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Row(
          children: [],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
