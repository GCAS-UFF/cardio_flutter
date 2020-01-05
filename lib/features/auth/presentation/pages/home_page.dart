import 'package:cardio_flutter/features/auth/presentation/pages/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/core/widgets/patient_tile.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PgFoudation(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 20),
              width: double.infinity),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              alignment: Alignment.center,
              width: Dimensions.getConvertedWidthSize(context, 280),
              height: Dimensions.getConvertedHeightSize(context, 60),
              decoration: BoxDecoration(
                  color: Color(0xffc9fffd),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        offset: Offset(3, 3), color: Colors.blue, blurRadius: 3)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person_add,
                    //color: Colors.white,
                  ),
                  Text(
                    Strings.new_patient,
                    style: TextStyle(
                        //color: Colors.white,
                        fontSize: Dimensions.getTextSize(context, 18)),
                  )
                ],
              ),
            ),
            onTap: () {
              return Navigator.pushNamed(context, "/patientSignUp");
            },
          ),
          SizedBox(
              height: Dimensions.getConvertedHeightSize(context, 10),
              width: double.infinity),
          Expanded(
            child: Column(
              children: <Widget>[
                PatientTile(),
                PatientTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
