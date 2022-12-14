import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:neko_cc/widget/overlay.dart';
import 'package:neko_cc/widget/tableData.dart';
import 'package:neko_cc/widget/toast.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../core/baseCore.dart';
import '../core/mainCore.dart';
import '../core/flowCore.dart';
import '../core/styleCore.dart';
import '../widget/Expander.dart';

List expanderKey = [
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey(),
  GlobalKey()
];

class CharTable extends StatefulWidget {
  final Map? file;

  const CharTable({this.file});

  @override
  State<CharTable> createState() => _CharTableState(this.file);
}

class _CharTableState extends State<CharTable> {
  Map? file;

  _CharTableState(this.file);

  @override
  Widget build(BuildContext context) {
    Future FileList(i) async {
      return await i["content"]["基础信息"];
    }

    ;

    return FutureBuilder(
        future: FileList(file),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ScaffoldPage
                  .scrollable(padding: EdgeInsets.all(0), children: [
                ClsCol(children: [
                  NekoExpander(
                      listkey: expanderKey[0],
                      header: ClsTextTitle(text: snapshot.data["角色姓名"][1]),
                      content: ClsCharImg(file: file)),
                  NekoExpander(
                      listkey: expanderKey[1],
                      header: ClsTextTitle(text: "人物简介"),
                      content: NekoCard(
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 5, top: 10, bottom: 10),
                              child: ClsCol(children: [
                                ClsRow(children: [
                                  Expanded(child: SizedBox()),
                                  IconButton(
                                      icon: const Icon(FluentIcons.copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: snapshot.data["简介"][1]
                                                .toString()));
                                        Toast.show("结果已复制",
                                            gravity: Toast.bottom);
                                      })
                                ]),
                                SelectableText(
                                    snapshot.data["简介"][1].toString(),
                                    style: NekoText.nromalContent)
                              ])))),
                  NekoExpander(
                      listkey: expanderKey[2],
                      header: const ClsTextTitle(text: "称号"),
                      content: NekoTable(
                          map: snapshot.data,
                          value: "称号",
                          type: TableType.title)),
                  NekoExpander(
                      listkey: expanderKey[3],
                      header: const ClsTextTitle(text: "个人信息"),
                      content: NekoTable(map: snapshot.data, value: "个人信息")),
                  NekoExpander(
                      listkey: expanderKey[4],
                      header: const ClsTextTitle(text: "属性数据"),
                      content:
                          OrientationBuilder(builder: (context, orientation) {
                        bool o = MediaQuery.of(context).size.width >
                                MediaQuery.of(context)
                                    .size
                                    .height // 还可以 * 1.2 之类的（根据场景自己看着办[滑稽]）
                            ? true
                            : false;
                        if (o) {
                          return ClsCol(children: [
                            ClsRow(children: [
                              FittedBox(
                                  child: SizedBox(
                                      width: 250,
                                      child: NekoTable(
                                          map: snapshot.data,
                                          value: "属性数据(基本)"))),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: Container(
                                      height: 400,
                                      child: ClsDataAttrChart(snapshot.data)))
                            ]),
                            Container(
                                height: 400,
                                child: NekoTable(
                                    map: snapshot.data,
                                    value: "属性数据(属性)",
                                    type: TableType.attr))
                          ]);
                        } else {
                          return ClsCol(children: [
                            Container(
                                width: double.infinity,
                                child: NekoTable(
                                    map: snapshot.data, value: "属性数据(基本)")),
                            Container(
                                height: 400,
                                child: ClsDataAttrChart(snapshot.data)),
                            Container(
                                child: NekoTable(
                                    map: snapshot.data,
                                    value: "属性数据(属性)",
                                    type: TableType.attr))
                          ]);
                        }
                      })),
                  NekoExpander(
                      listkey: expanderKey[5],
                      header: ClsTextTitle(
                          text: snapshot.data["生活与学术侧技能栏"]["生活与学术侧技能栏"][1]),
                      content: NekoTable(
                          headerColWidth: FlexColumnWidth(1),
                          map: snapshot.data,
                          value: "生活与学术侧技能栏",
                          type: TableType.studyAbility)),
                  NekoExpander(
                      listkey: expanderKey[6],
                      header: ClsTextTitle(
                          text: snapshot.data["人物能力栏"]["人物能力栏"][1]),
                      content: NekoTable(
                          headerColWidth: FlexColumnWidth(1),
                          map: snapshot.data,
                          value: "人物能力栏",
                          type: TableType.ability)),
                  NekoExpander(
                      listkey: expanderKey[7],
                      header:
                          ClsTextTitle(text: snapshot.data["主要特质"]["主要特质"][1]),
                      content: NekoTable(
                          headerColWidth: FlexColumnWidth(1),
                          map: snapshot.data,
                          value: "主要特质",
                          type: TableType.ability)),
                  NekoExpander(
                      listkey: expanderKey[8],
                      header:
                          ClsTextTitle(text: snapshot.data["次要特质"]["次要特质"][1]),
                      content: NekoTable(
                          headerColWidth: FlexColumnWidth(1),
                          map: snapshot.data,
                          value: "次要特质",
                          type: TableType.ability)),
                  NekoExpander(
                      listkey: expanderKey[9],
                      header: ClsTextTitle(text: "公式判定"),
                      content: NekoTable(
                          map: snapshot.data,
                          value: "公式判定",
                          type: TableType.judge))
                ])
              ]);
            default:
              return Text("加载中");
          }
        });
  }
}

ClsDataAttrChart(map) {
  var box = Hive.box("config");
  var boxData = box.get("view");
  var data = boxData["char"]["属性数据(属性)"];
  List l = ClsSource(data, map).attr;
  l.removeAt(0);
  List<ChartData> list = [];
  for (var i in l) {
    list.add(ChartData(i[0].toString(), int.parse(i[i.length - 1])));
  }

  return SfCartesianChart(primaryXAxis: CategoryAxis(), series: <ChartSeries>[
// Renders column chart
    StackedColumnSeries<ChartData, String>(
        dataSource: list,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y)
  ]);
}
