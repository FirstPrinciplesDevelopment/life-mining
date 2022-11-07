import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:provider/provider.dart';

import '../service.dart';

class ModelList extends StatefulWidget {
  const ModelList({
    required this.initialModels,
    this.onTap,
    this.onTrack,
    this.onChart,
    this.onViewJson,
    this.onEditModel,
    Key? key,
  }) : super(key: key);

  final List<Model> initialModels;
  final ValueChanged<Model>? onTap;
  final ValueChanged<Model>? onTrack;
  final ValueChanged<Model>? onChart;
  final ValueChanged<Model>? onViewJson;
  final ValueChanged<Model>? onEditModel;

  @override
  _ModelListState createState() => _ModelListState();
}

class _ModelListState extends State<ModelList> {
  List<Model> models = [];

  @override
  void initState() {
    super.initState();
    models = widget.initialModels;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GridView.count(
      childAspectRatio: 4.5,
      crossAxisCount: ((screenSize.width) / 600).round().ceil(),
      children: List.generate(models.length, (index) {
        return Card(
          elevation: 4,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Color(0xff4accfa), Color(0xff4afacf)]),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text(
                      models[index].name,
                    ),
                    subtitle: Text(
                      models[index].description ?? '',
                    ),
                    onTap: widget.onTap != null
                        ? () => widget.onTap!(models[index])
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: IconButton(
                      iconSize: 30.0,
                      onPressed: widget.onTrack != null
                          ? () => widget.onTrack!(models[index])
                          : null,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: IconButton(
                      iconSize: 30.0,
                      onPressed: widget.onChart != null
                          ? () => widget.onChart!(models[index])
                          : null,
                      icon: const Icon(
                        Icons.bar_chart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: PopupMenuButton<String>(
                    onSelected: (String result) {
                      switch (result) {
                        case 'edit':
                          widget.onEditModel!(models[index]);
                          break;
                        case 'json':
                          // call onViewJson callback
                          widget.onViewJson!(models[index]);
                          break;
                        case 'delete':
                          String name = models[index].name;
                          showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Warning!'),
                              content: Text([
                                'Are you sure you want to delete?\n',
                                'This will delete all $name records ',
                                'as well as the $name Model itself.',
                              ].join()),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<DataService>(context,
                                            listen: false)
                                        .deleteModel(models[index].id);
                                    setState(() {
                                      models.removeWhere(
                                          (m) => m.id == models[index].id);
                                    });
                                    Navigator.popUntil(context,
                                        ModalRoute.withName('/models'));
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit Model'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'json',
                        child: Text('View Json'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete Model'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
