
import 'package:flutter/material.dart';
import 'package:trackbus/log.dart';


class second_page1 extends StatelessWidget {
  const second_page1({super.key});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: Text("2nd page"),
      ),
      body: Center(
        child: Container(
          child: Text('Name:Swapnil Belkar')
          ,


        ),
      ),
    );
  }
}
