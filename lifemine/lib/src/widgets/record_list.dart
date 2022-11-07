import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifemine/src/data.dart';
import 'package:provider/provider.dart';

import '../service.dart';

class RecordList extends StatelessWidget {
  const RecordList({
    required this.model,
    required this.records,
    Key? key,
  }) : super(key: key);

  final Model model;
  final List<Map<String, Object?>> records;
  // final ValueChanged<Model>? onTap;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(4),
        children: [
          if (records.isNotEmpty)
            SingleChildScrollView(
              child: PaginatedDataTable(
                showCheckboxColumn: false,
                header: Text(model.name),
                rowsPerPage: min(records.length, 8),
                columns: [
                  for (Field f in model.fields)
                    if (f.showOnList) DataColumn(label: Text(f.name)),
                  // delete button
                  const DataColumn(label: Text('Actions')),
                ],
                source: _DataSource(
                  context,
                  model,
                  records,
                  deleteRecord,
                ),
              ),
            ),
        ],
      );

  void deleteRecord(BuildContext context, String recordId) {
    Provider.of<DataService>(context, listen: false).deleteRecord(
      model.id,
      recordId,
    );

    // if no more records, go back to /models, otherwise close the dialog
    if (records.isEmpty) {
      Navigator.popUntil(context, ModalRoute.withName('/models'));
    } else {
      Navigator.pop(context, 'Delete');
    }
  }
}

class _Row {
  _Row(this.record);

  final Map<String, Object?> record;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(
    BuildContext context,
    Model model,
    List<Map<String, Object?>> records,
    Function(BuildContext, String) onDelete,
  ) {
    _context = context;
    _model = model;
    _rows = records.map((r) => _Row(r)).toList();
    _onDelete = onDelete;
  }

  late BuildContext _context;
  late Model _model;
  late List<_Row> _rows;
  late Function(BuildContext, String) _onDelete;

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += (value ?? false) ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value ?? false;
          notifyListeners();
        }
      },
      cells: [
        for (Field f in _model.fields)
          if (f.showOnList) DataCell(beautify(row, f)),
        DataCell(
          Row(children: [
            IconButton(
              icon: const Icon(
                Icons.edit_sharp,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.pushNamed(_context,
                  '/models/${_model.id}/records/${row.record["id"]}/edit'),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_sharp,
                color: Colors.red,
              ),
              onPressed: () => showDialog<String>(
                context: _context,
                builder: (context) => AlertDialog(
                  title: const Text('Warning!'),
                  content: const Text('Are you sure you want to delete?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () =>
                          _onDelete(_context, row.record['id'] as String),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  Widget beautify(_Row row, Field field) {
    Object? object = row.record[field.name];
    switch (field.widget?.type) {
      case 'Date':
      case 'DateTime':
        var d = DateTime.parse(object as String);
        DateFormat format = DateFormat('EEE, MMM d, yyyy');
        return Text(format.format(d.toLocal()));
      case 'Checkbox':
        return Checkbox(value: (object ?? false) as bool, onChanged: null);
    }
    // got this far, we'll just have to use toString()
    return Text(object.toString());
  }
}
