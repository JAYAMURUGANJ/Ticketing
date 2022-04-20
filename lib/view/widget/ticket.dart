// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class TicketShape extends StatelessWidget {
  const TicketShape(
      {Key? key,
      this.t_id,
      this.t_name,
      this.t_date,
      this.t_time,
      this.t_price,
      this.t_count,
      this.t_total})
      : super(key: key);

  final int? t_id;
  final String? t_name;
  final String? t_date;
  final String? t_time;
  final String? t_price;
  final int? t_count;
  final String? t_total;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(255, 184, 114, 149),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Ticket No: " + t_id!.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  t_name!,
                  style: TextStyle(color: Colors.white),
                ),
                const Text(
                  "---------------------------------------------",
                  style: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "\u{20B9} $t_price * $t_count  = \u{20B9} $t_total",
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 41, 40, 40),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t_date!,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          t_time!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                // Text("Ticket Name: " + t_name!),
                // Text("Ticket Date: " + t_date!),
                // Text("Ticket Time: " + t_time!),
                // Text("Ticket Amount: " + t_price!),
              ],
            ),
          ),
        ),
        Positioned(
            left: -5,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            )),
        Positioned(
            right: -5,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            )),
      ],
    );
  }
}

class TicketShapeIcon extends StatelessWidget {
  const TicketShapeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 18,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
              border: Border.all(
                  color: Color.fromARGB(255, 184, 114, 149), width: 1),
            ),
          ),
          Positioned(
              left: -5,
              child: Container(
                height: 8,
                width: 10,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Color.fromARGB(255, 184, 114, 149)),
                    shape: BoxShape.circle),
              )),
          Positioned(
              right: -5,
              child: Container(
                height: 8,
                width: 10,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border:
                        Border.all(color: Color.fromARGB(255, 184, 114, 149)),
                    shape: BoxShape.circle),
              )),
        ],
      ),
    );
  }
}
