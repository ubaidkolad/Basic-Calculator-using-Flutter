import 'package:flutter/material.dart';

class Report {
  String base64Image;
  int penoProb;
  String filename;
  String result;
  Report(this.filename, this.base64Image, this.penoProb) {
    this.penoProb = this.penoProb * 100;
    if (this.penoProb > 0.35) {
      this.result = "Penumonia";
    } else
      this.result = "Normal";
  }
}

class Classesof {
  int prob;
  String name;
}
