import 'package:flutter/material.dart';

import '../constants.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? enableHours;
  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final bool singleSelection;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enableHours,
  }) : singleSelection = false;

  const HoursPanel.singleSelection({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enableHours,
  }) : singleSelection = true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    final HoursPanel(:singleSelection, :enableHours) = widget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.startTime; i <= widget.endTime; i++)
              TimeButton(
                selectedHour: lastSelection,
                singleSelection: singleSelection,
                enableHours: enableHours,
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                onPressed: (int selectedHour) {
                  widget.onHourPressed(selectedHour);

                  setState(() {
                    if (singleSelection) {
                      if (lastSelection == selectedHour) {
                        lastSelection = null;
                      } else {
                        lastSelection = selectedHour;
                      }
                    }
                  });
                },
              )
          ],
        )
      ],
    );
  }
}

class TimeButton extends StatefulWidget {
  final List<int>? enableHours;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;
  final bool singleSelection;
  final int? selectedHour;
  const TimeButton({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    required this.singleSelection,
    required this.selectedHour,
    this.enableHours,
  });

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final TimeButton(
      :value,
      :label,
      :enableHours,
      :onPressed,
      :singleSelection,
      :selectedHour,
    ) = widget;

    if (singleSelection) {
      if (selectedHour != null) {
        if (selectedHour == value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brown : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brown : ColorsConstants.greyLight;

    final disableHour = enableHours != null && !enableHours.contains(value);
    if (disableHour) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableHour
          ? null
          : () {
              setState(() {
                selected = !selected;
                onPressed(value);
              });
            },
      child: Container(
        width: 64,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor,
          border: Border.all(color: buttonBorderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
