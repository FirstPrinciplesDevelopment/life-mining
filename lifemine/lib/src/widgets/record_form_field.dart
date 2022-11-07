import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../data.dart';

class RecordFormField extends StatefulWidget {
  RecordFormField({Key? key, required this.field, this.initialValue})
      : super(key: key) {
    currentSliderValue = field.widget?.numericDefault ?? 0;
    selectedOption = field.widget?.stringDefault;
    // initialize controller with default value if provided
    if (field.widget?.type == 'ElapsedTime' ||
        field.widget?.type == 'NumberInput') {
      controller =
          TextEditingController(text: field.widget?.numericDefault.toString());
    } else {
      controller = TextEditingController(text: field.widget?.stringDefault);
    }
    // set initial field value if provided, e.g. in an edit scenario
    if (initialValue != null) {
      value = initialValue;
    }
  }

  final Field field;
  final Object? initialValue;
  // TODO: see if all these binding variables can be condensed into one object,
  // and see if that object can behave like the nice TextEditingController
  num currentSliderValue = 0;
  bool isChecked = false;
  DateTime currentDateTime = DateTime.now();
  TimeOfDay currentTimeOfDay = TimeOfDay.now();
  DateTimeRange currentDateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  Duration currentDuration = const Duration(hours: 1);
  Object? selectedOption;
  TextEditingController controller = TextEditingController();

  @override
  _RecordFormFieldState createState() => _RecordFormFieldState();

  Object? get value {
    switch (field.widget?.type) {
      case 'Text':
      case 'MultilineText':
      case 'NumberInput':
        return controller.value.text;
      case 'Slider':
        return currentSliderValue;
      case 'Date':
        return currentDateTime;
      case 'DateTime':
        return DateTime(
          currentDateTime.year,
          currentDateTime.month,
          currentDateTime.day,
          currentTimeOfDay.hour,
          currentTimeOfDay.minute,
        );
      case 'DateRange':
        return currentDateRange.toString();
      case 'Timestamp':
        return DateTime.now().millisecondsSinceEpoch;
      case 'ElapsedTime':
        Duration? elapsedTime;
        switch (selectedOption) {
          case 'Hours':
            elapsedTime = Duration(hours: int.parse(controller.value.text));
            break;
          case 'Minutes':
            elapsedTime = Duration(minutes: int.parse(controller.value.text));
            break;
          case 'Seconds':
            elapsedTime = Duration(seconds: int.parse(controller.value.text));
            break;
        }
        return elapsedTime?.toString();
      case 'Checkbox':
        return isChecked;
      case 'Radio':
        return selectedOption;
      case 'MultiSelect':
        break;
      case 'Select':
        return selectedOption;
      default:
        break;
    }
    return null;
  }

  set value(Object? object) {
    switch (field.widget?.type) {
      case 'Text':
      case 'MultilineText':
      case 'NumberInput':
        controller = TextEditingController(text: object as String);
        break;
      case 'Slider':
        currentSliderValue = object as num;
        break;
      case 'Date':
        currentDateTime = DateTime.parse(object as String);
        break;
      case 'DateTime':
        currentDateTime = DateTime.parse(object as String);
        currentTimeOfDay = TimeOfDay.fromDateTime(currentDateTime);
        break;
      case 'DateRange':
        String val = object as String;
        String start = (val).split(' - ').first;
        String end = (val).split(' - ').last;
        currentDateRange = DateTimeRange(
          start: DateTime.parse(start),
          end: DateTime.parse(end),
        );
        break;
      case 'Timestamp':
        break;
      case 'ElapsedTime':
        // stored as a string like "0:30:00.000000"
        String val = object as String;
        Duration? elapsedTime = Duration(
          hours: int.parse(val.substring(0, val.length - 13)),
          minutes: int.parse(val.substring(val.length - 12, val.length - 10)),
          seconds: int.parse(val.substring(val.length - 9, val.length - 7)),
          microseconds: int.parse(val.substring(val.length - 6, val.length)),
        );
        // set selectedOption and controller
        if (elapsedTime.inHours > 0) {
          controller =
              TextEditingController(text: elapsedTime.inHours.toString());
          selectedOption = 'Hours';
        } else if (elapsedTime.inMinutes > 0) {
          controller =
              TextEditingController(text: elapsedTime.inMinutes.toString());
          selectedOption = 'Minutes';
        } else if (elapsedTime.inSeconds > 0) {
          controller =
              TextEditingController(text: elapsedTime.inSeconds.toString());
          selectedOption = 'Seconds';
        }
        break;
      case 'Checkbox':
        isChecked = object as bool;
        break;
      case 'Radio':
        selectedOption = object as String;
        break;
      case 'MultiSelect':
        break;
      case 'Select':
        selectedOption = object as String;
        break;
      default:
        break;
    }
  }
}

class _RecordFormFieldState extends State<RecordFormField> {
  late Field _field;

  @override
  void initState() {
    super.initState();
    _field = widget.field;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.currentDateTime,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.currentDateTime) {
      setState(() {
        widget.currentDateTime = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: widget.currentTimeOfDay);
    if (picked != null && picked != widget.currentTimeOfDay) {
      setState(() {
        widget.currentTimeOfDay = picked;
      });
    }
  }

  void _selectNow(BuildContext context) {
    setState(() {
      widget.currentDateTime = DateTime.now();
      widget.currentTimeOfDay = TimeOfDay.now();
    });
  }

  Future<void> _selectDateTimeRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: widget.currentDateRange,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != widget.currentDateRange) {
      setState(() {
        widget.currentDateRange = picked;
      });
    }
  }

  void _selectOption(Object? value) {
    if (value is String?) {
      setState(() {
        widget.selectedOption = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_field.widget == null) {
      return const Text('No widget was defined for this field.');
    }
    FieldWidget fieldWidget = _field.widget!;
    switch (fieldWidget.type) {
      case 'Text':
        return TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: widget.field.name),
          maxLength: fieldWidget.maxLength,
          validator: (value) {
            if ((fieldWidget.isRequired) && (value ?? '').isEmpty) {
              return '${widget.field.name} is required';
            }
            if ((value?.length ?? 0) > (fieldWidget.maxLength ?? 0) &&
                fieldWidget.maxLength != null) {
              return 'Max length is ${fieldWidget.maxLength}';
            }
            return null;
          },
        );
      case 'MultilineText':
        return TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(labelText: _field.name),
          minLines: 5,
          maxLines: 10,
          maxLength: fieldWidget.maxLength,
          validator: (value) {
            if (fieldWidget.isRequired && (value ?? '').isEmpty) {
              return '${fieldWidget.fieldName} is required';
            }
            return null;
          },
        );
      case 'Slider':
        return Column(
          children: [
            Text(fieldWidget.fieldName),
            Slider(
              label: widget.currentSliderValue.round().toString(),
              value: widget.currentSliderValue.toDouble(),
              min: fieldWidget.min.toDouble(),
              max: fieldWidget.max.toDouble(),
              divisions: (fieldWidget.max.floor()) - (fieldWidget.min.ceil()),
              onChanged: (double value) {
                setState(() {
                  widget.currentSliderValue = value;
                });
              },
            ),
          ],
        );
      case 'NumberInput':
        return TextFormField(
          textAlign: TextAlign.end,
          controller: widget.controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(labelText: _field.name),
        );
      case 'Date':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(fieldWidget.fieldName),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        DateFormat('EEE, MMM d, yyyy')
                            .format(widget.currentDateTime),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: OutlinedButton(
                      onPressed: () => _selectNow(context),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue)),
                      child: const Text(
                        'Now',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 'DateTime':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(fieldWidget.fieldName),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        DateFormat('EEE, MMM d, yyyy')
                            .format(widget.currentDateTime),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextButton(
                      onPressed: () => _selectTime(context),
                      child: Text(
                        widget.currentTimeOfDay.format(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: OutlinedButton(
                      onPressed: () => _selectNow(context),
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue)),
                      child: const Text(
                        'Now',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 'DateRange':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(fieldWidget.fieldName),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextButton(
                      onPressed: () => _selectDateTimeRange(context),
                      child: Text(
                        _formatDateRange(widget.currentDateRange),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 'Timestamp':
        return const Text('Timestamp will be set automatically on save');
      case 'ElapsedTime':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: TextFormField(
                      textAlign: TextAlign.end,
                      controller: widget.controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(labelText: _field.name),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                    child: DropdownButton(
                        value: widget.selectedOption,
                        onChanged: (Object? value) => _selectOption(value),
                        items: fieldWidget.optionList
                            ?.map((SelectOption opt) => DropdownMenuItem(
                                value: opt.value, child: Text(opt.value)))
                            .toList()),
                  ),
                ),
              ],
            ),
          ],
        );
      case 'Checkbox':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.blue),
              value: widget.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  widget.isChecked = value ?? false;
                });
              },
            ),
            Text(fieldWidget.fieldName),
          ],
        );
      case 'Radio':
        return Column(
          children: <Widget>[
            Text(fieldWidget.fieldName),
            for (SelectOption option in fieldWidget.optionList ?? [])
              ListTile(
                title: Text(option.value),
                leading: Radio<String>(
                  value: option.value,
                  groupValue: widget.selectedOption as String?,
                  onChanged: (String? value) {
                    setState(() {
                      widget.selectedOption = value;
                    });
                  },
                ),
              ),
          ],
        );
      case 'MultiSelect':
        break;
      case 'Select':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(fieldWidget.fieldName),
            DropdownButton(
                value: widget.selectedOption,
                onChanged: (Object? value) => _selectOption(value),
                items: fieldWidget.optionList
                    ?.map((SelectOption opt) => DropdownMenuItem(
                        value: opt.value, child: Text(opt.value)))
                    .toList()),
          ],
        );
      default:
        return TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(labelText: _field.name),
          maxLength: fieldWidget.maxLength,
          validator: (value) {
            if (fieldWidget.isRequired && (value ?? '').isEmpty) {
              return '${_field.name} is required';
            }
            if ((value?.length ?? 0) > (fieldWidget.maxLength ?? 0) &&
                fieldWidget.maxLength != null) {
              return 'Max length is ${fieldWidget.maxLength}';
            }
            return null;
          },
        );
    }
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: _field.name),
      maxLength: fieldWidget.maxLength,
      validator: (value) {
        if (fieldWidget.isRequired && (value ?? '').isEmpty) {
          return '${_field.name} is required';
        }
        if ((value?.length ?? 0) > (fieldWidget.maxLength ?? 0) &&
            fieldWidget.maxLength != null) {
          return 'Max length is ${fieldWidget.maxLength}';
        }
        return null;
      },
    );
  }

  String _formatDateRange(DateTimeRange range) {
    DateFormat format = DateFormat('EEE, MMM d, yyyy');
    return '${format.format(range.start)} - ${format.format(range.end)}';
  }
}
