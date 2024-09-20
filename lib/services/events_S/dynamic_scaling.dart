import 'package:flutter/cupertino.dart';

extension Dimensionon on num{
  double ws (BuildContext context){
    final deviceWidth = MediaQuery.of(context).size.width;
    return  deviceWidth * (this/100);
  }
  double pixelScale(BuildContext context){
    return (this /4).ws(context);
  }
}