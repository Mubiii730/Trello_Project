import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BoardScreen(),
    );
  }
}

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  List<AppFlowyGroupItem> group1Items = [
    TextItem("Task 1", 'To Do', ['Travel', 'Fun', 'Work', 'Health']),
    TextItem("Task 2", 'To Do', ['Travel', 'Fun', 'Work', 'Health']),
  ];
  List<AppFlowyGroupItem> group2Items = [
    TextItem("Task 3", 'In Progress', ['Travel', 'Fun', 'Work', 'Health']),
    TextItem("Task 4", 'In Progress', ['Travel', 'Fun', 'Work', 'Health']),
  ];
  List<AppFlowyGroupItem> group3Items = [];

  addItem(int groupIndex) {
    setState(() {
      final newItem = TextItem(
        "Task ${group1Items.length + group2Items.length + group3Items.length + 1}",
        groupIndex == 1 ? 'To Do' : groupIndex == 2 ? 'In Progress' : 'Done',
        ['Travel', 'Fun', 'Work', 'Health'],
      );
      if (groupIndex == 1) {
        group1Items.add(newItem);
      } else if (groupIndex == 2) {
        group2Items.add(newItem);
      } else if (groupIndex == 3) {
        group3Items.add(newItem);
      }
    });
  }

  @override
  void initState() {
    final group1 =
        AppFlowyGroupData(id: "To Do", items: group1Items, name: 'Group 1');
    final group2 = AppFlowyGroupData(
        id: "In Progress", items: group2Items, name: 'Group 2');
    final group3 =
        AppFlowyGroupData(id: "Done", items: group3Items, name: 'Group 3');

    controller.addGroup(group1);
    controller.addGroup(group2);
    controller.addGroup(group3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Board Example',
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.white,
            width: 200,
            height: MediaQuery.sizeOf(context).height,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomTextWidget(
                      text1: "😀",
                      text2: 'Me',
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.settings))
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    const Text(' Getting started'),
                    const SizedBox(width: 38),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        iconSize: 20),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: AppFlowyBoard(
              controller: controller,
              cardBuilder: (context, group, groupItem) {
                final textItem = groupItem as TextItem;

                final TextEditingController textController = TextEditingController(text: textItem.s);

                return AppFlowyGroupCard(
                  key: ObjectKey(textItem),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Container(
                    
                   // width: MediaQuery.sizeOf(context).width / 4,
                    ///height: MediaQuery.sizeOf(context).height / 10,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: textItem.isEditing
                                  ? Expanded(
                                      child: TextField(
                                        controller: textController,
                                        decoration: const InputDecoration(
                                          labelText: 'Enter text',
                                        ),
                                        onSubmitted: (value) {
                                          setState(() {
                                            textItem.s = value;
                                            textItem.isEditing = false;
                                          });
                                        },
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          textItem.isEditing = true;
                                        });
                                      },
                                      child: Text(
                                        textItem.s,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                            PopupMenuButton<int>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (index) {
                                setState(() {
                                  textItem.selectedOptions[index] =
                                      !textItem.selectedOptions[index];
                                });
                              },
                              itemBuilder: (context) {
                                return textItem.entries
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  String option = entry.value;
                                  return PopupMenuItem<int>(
                                    value: index,
                                    child: ListTile(
                                      title: Text(option),
                                      //minLeadingWidth: 400,
                                      //minTileHeight: 400,
                                    ),
                                  );
                                }).toList();
                              },
                              offset: const Offset(-40, 35),
                              constraints: const BoxConstraints(
                                minWidth: 250,
                                minHeight: 200,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
  children: textItem.entries.asMap().entries.map((entry) {
    int index = entry.key;
    String text = entry.value;
    Color? backgroundColor;
    switch (text) {
      case 'Fun':
        backgroundColor = const Color.fromARGB(255, 235, 227, 156);
        break;
      case 'Work':
        backgroundColor = const Color.fromARGB(255, 155, 212, 238);
        break;
      case 'Health':
        backgroundColor = const Color.fromARGB(255, 233, 141, 141);
        break;
      case 'Travel':
        backgroundColor = const Color.fromARGB(255, 195, 247, 136);
        break;
      default:
        backgroundColor = null;
    }
    if (textItem.selectedOptions[index]) {
      return Container(
        constraints: const BoxConstraints(
          minWidth: 50,
          minHeight: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        child: Chip(
          label: Text(text, style: const TextStyle(fontSize: 12)),
          backgroundColor: backgroundColor,
          deleteIcon: const Icon(Icons.close, size: 12),
          onDeleted: () {
            setState(() {
              textItem.selectedOptions[index] = false;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }).toList(),
),
                      ],
                    ),
                  ),
                );
              },
              headerBuilder: (context, groupData) {
                return AppFlowyGroupHeader(
                  title: Row(
                    children: [
                      const SizedBox(width: 20),
                      Text(groupData.id),
                      const SizedBox(width: 10),
                      Text('(${groupData.items.length})'),
                    ],
                  )
                );
              },
              footerBuilder: (context, groupData) {
                return AppFlowyGroupFooter(
                  title: ElevatedButton(
                    onPressed: () {
                      if (groupData.id == 'To Do') {
                        addItem(1);
                      } else if (groupData.id == 'In Progress') {
                        addItem(2);
                      } else if (groupData.id == 'Done') {
                        addItem(3);
                      }
                    },
                    child: const Row(
                      children: [
                        Text('New'),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                );
              },
              groupConstraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width / 3.4,
                maxWidth: MediaQuery.sizeOf(context).width / 3.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    this.icon,
  });
  final String text1;
  final String text2;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          style: const TextStyle(color: Colors.yellow),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text2,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  String s;
  final String heading;
  final List<String> entries;
  final List<bool> selectedOptions;
  bool isEditing;

  TextItem(
    this.s,
    this.heading,
    this.entries, {
    List<bool>? selectedOptions,
    this.isEditing = false,
  }) : selectedOptions = selectedOptions ?? List.filled(entries.length, false);

  @override
  String get id => s;
}
