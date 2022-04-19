// To parse this JSON data, do
//
//     final ticketData = ticketDataFromJson(jsonString);

import 'dart:convert';

List<TicketData> ticketDataFromJson(String str) =>
    List<TicketData>.from(json.decode(str).map((x) => TicketData.fromJson(x)));

String ticketDataToJson(List<TicketData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketData {
  int? ticketId;
  String? ticketName;
  double? ticketAmount;

  TicketData({this.ticketId, this.ticketName, this.ticketAmount});

  TicketData.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    ticketName = json['ticket_name'];
    ticketAmount = json['ticket_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_id'] = ticketId;
    data['ticket_name'] = ticketName;
    data['ticket_amount'] = ticketAmount;
    return data;
  }
}
