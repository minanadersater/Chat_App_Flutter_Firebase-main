import 'package:flutter/material.dart';
import 'delete_massege.dart';

Future<void> bottomsheet({
  required BuildContext context,
  required String docid,
  required String collection,
  required String reciverid,
  required String layer,
  required int who,
  required bool status, 
}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 70,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      child: Text(status==false?'Recover':'Delete'),
                      onPressed: () {
                        Up().update(
                          id: docid,
                          collection: collection,
                          receiverid: reciverid,
                          layer: layer,
                          who: who,
                          status: status,
                         );
                        Navigator.pop(context);
                      })
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
