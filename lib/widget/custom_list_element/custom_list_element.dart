import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class CustomListElement extends StatelessWidget {
  const CustomListElement({super.key, required this.data, required this.date, required this.icon, required this.onTap, required this.onDelete});

  final String data;
  final DateTime date;
  final Icon icon;
  final void Function() onTap;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            key: const ValueKey(0),
            onPressed: (context) => onDelete(),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          tileColor: Colors.black.withOpacity(0.2),
          onTap: onTap,
          title: Text(data, style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis, ),maxLines: 1, textAlign: TextAlign.start,),
          subtitle: Text(DateFormat('yyyy-MM-dd kk:mm').format(date), style: const TextStyle(color: Colors.white),),
          trailing: icon
      ),
    );
  }
}
