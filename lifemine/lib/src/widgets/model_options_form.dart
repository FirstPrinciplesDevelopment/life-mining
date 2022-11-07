import 'package:flutter/material.dart';

import '../constants.dart';
import '../view_models.dart';


class ModelOptionsForm extends StatefulWidget {
  const ModelOptionsForm({required this.modelVM, Key? key}) : super(key: key);

  final ModelViewModel modelVM;

  @override
  _ModelOptionsFormState createState() => _ModelOptionsFormState();
}

class _ModelOptionsFormState extends State<ModelOptionsForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Options',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: widget.modelVM.options.singleField ?? false,
                        onChanged: (value) {
                          setState(() {
                            widget.modelVM.options.singleField = value;
                          });
                        },
                      ),
                      const Text('Single Field'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: Column(children: [
                    const Text('Aggregation'),
                    DropdownButton<String>(
                        value: widget.modelVM.options.aggregation,
                        onChanged: (String? value) {
                          setState(() {
                            widget.modelVM.options.aggregation = value;
                          });
                        },
                        items: Constants.frequencyOptionList
                            .map((String opt) =>
                                DropdownMenuItem(value: opt, child: Text(opt)))
                            .toList()),
                  ]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: Column(children: [
                    const Text('Limit'),
                    DropdownButton<String>(
                        value: widget.modelVM.options.limit,
                        onChanged: (String? value) {
                          setState(() {
                            widget.modelVM.options.limit = value;
                          });
                        },
                        items: Constants.frequencyOptionList
                            .map((String opt) =>
                                DropdownMenuItem(value: opt, child: Text(opt)))
                            .toList()),
                  ]),
                ),
              ),
            ],
          ),
          // Reminders
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Reminders',
              style: TextStyle(fontSize: 16),
            ),
          ),

          Column(
            children: [
              if (widget.modelVM.options.reminders?.isNotEmpty ?? false)
                Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Day Of Week'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('Time Of Day'),
                      ),
                    ),
                  ],
                ),
              if (widget.modelVM.options.reminders != null)
                for (ReminderViewModel reminder
                    in widget.modelVM.options.reminders!)
                  // Reminder Form
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<String>(
                              value: reminder.dayOfWeek,
                              onChanged: (String? value) {
                                setState(() {
                                  reminder.dayOfWeek = value;
                                });
                              },
                              items: Constants.dayOfWeekList
                                  .map((String opt) => DropdownMenuItem(
                                        value: opt,
                                        child: Text(opt),
                                      ))
                                  .toList()),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextButton(
                            onPressed: () async {
                              final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: reminder.timeOfDay);
                              if (picked != null &&
                                  picked != reminder.timeOfDay) {
                                setState(() {
                                  reminder.timeOfDay = picked;
                                });
                              }
                            },
                            child: Text(
                              reminder.timeOfDay.format(context),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              widget.modelVM.options.reminders
                                  ?.removeWhere((r) => r == reminder);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            ],
          ),
          // Add Reminder Button
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  widget.modelVM.options.reminders ??= [];
                  widget.modelVM.options.reminders?.add(ReminderViewModel());
                });
              },
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue)),
              child: const Text('Add Reminder'),
            ),
          ),
        ],
      ),
    );
  }
}
