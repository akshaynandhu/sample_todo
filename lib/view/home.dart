import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample_todo/view/widgets.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        backgroundColor: Colors.redAccent,
      ),
      backLayerBackgroundColor: Colors.redAccent,
      backLayer: Container(),
      headerHeight: 400.h,
      frontLayer: Scaffold(
        body:  const Padding(padding: EdgeInsets.all(20),
        child: ListTask(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: (){
            showDialogBox(context);
          },
          child: const Icon(Icons.add_task),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.blueGrey,
          notchMargin: 5.0,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none,color: Colors.transparent,),label: ''
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_a_photo,color: Colors.transparent,),label: ''
            ),
          ],
            backgroundColor: Colors.redAccent,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
