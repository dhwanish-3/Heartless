import 'package:flutter/material.dart';

enum EventTag {
  labReport,
  admittance,
  dischargeSummary,
  medicalHistory,
  diet,
  exercise,
  medication,
  instruction,
  operativeReport,
  pil,
  prescription,
  referral,
  radiology,
  surgery,
  treatment,
  vaccination,
  xRay,
}

extension EventTagExtension on EventTag {
  String get value {
    switch (this) {
      case EventTag.labReport:
        return 'lab report';
      case EventTag.diet:
        return 'diet';
      case EventTag.dischargeSummary:
        return 'discharge report';
      case EventTag.admittance:
        return 'admittance';
      case EventTag.medicalHistory:
        return 'medical history';
      case EventTag.exercise:
        return 'exercise';
      case EventTag.medication:
        return 'medication';
      case EventTag.instruction:
        return 'instruction';
      case EventTag.operativeReport:
        return 'operative report';
      case EventTag.pil:
        return 'patient info leaflet';
      case EventTag.prescription:
        return 'prescription';
      case EventTag.referral:
        return 'referral';
      case EventTag.radiology:
        return 'radiology';
      case EventTag.surgery:
        return 'surgery';
      case EventTag.treatment:
        return 'treatment';
      case EventTag.vaccination:
        return 'vaccination';
      case EventTag.xRay:
        return 'x-ray';
      default:
        return 'other';
    }
  }

  Color get tagColor {
    switch (this) {
      case EventTag.labReport:
        return Colors.red;
      case EventTag.diet:
        return Colors.green;
      case EventTag.dischargeSummary:
        return Colors.blue;
      case EventTag.admittance:
        return Colors.purple;
      case EventTag.medicalHistory:
        return Colors.orange;
      case EventTag.exercise:
        return Colors.pink;
      case EventTag.medication:
        return Colors.teal;
      case EventTag.instruction:
        return Colors.indigo;
      case EventTag.operativeReport:
        return Colors.brown;
      case EventTag.pil:
        return Colors.cyan;
      case EventTag.prescription:
        return Colors.deepOrange;
      case EventTag.referral:
        return Colors.deepPurple;
      case EventTag.radiology:
        return Colors.amber;
      case EventTag.surgery:
        return Colors.lime;
      case EventTag.treatment:
        return Colors.lightBlue;
      case EventTag.vaccination:
        return Colors.lightGreen;
      case EventTag.xRay:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
