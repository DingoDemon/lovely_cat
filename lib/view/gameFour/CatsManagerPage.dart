import 'package:flutter/material.dart';
import 'package:lovely_cats/application.dart';
import 'package:lovely_cats/object/Cats.dart';
import 'package:lovely_cats/object/ResourceEnum.dart';
import 'package:lovely_cats/util/EnumCovert.dart';
import 'package:lovely_cats/util/FuncUtil.dart';
import 'package:lovely_cats/view/GamePage.dart';

class CatsManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatsManagerState();
  }

  CatsManagerPage();
}

class CatsManagerState extends State<CatsManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Card(
          color: Colors.yellow[50],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: Container(
              padding: EdgeInsets.all(8),
              child: Application.gameContext.cats.isEmpty
                  ? Center(
                      child: Text(
                      "没有喵喵在此驻足",
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 24,
                          fontFamily: 'Miao'),
                    ))
                  : Container(
                      child: getWidget(),
                    ))),
    );
  }

  Widget getWidget() {
    int count = Application.gameContext.cats.length;
    int lazy = Application.gameContext.catProfession[CatJob.Sleeper];
    List<Cat> list = Application.gameContext.cats;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text("这里一共有$count只喵喵",
              style: TextStyle(
                  color: Colors.purple[200], fontSize: 20, fontFamily: 'Miao')),
        ),
        Text("$lazy只喵喵在睡懒觉，快把${lazy > 1 ? '它们' : '它'}叫醒",
            style: TextStyle(
                color: Colors.purple[200], fontSize: 14, fontFamily: 'Miao')),
        ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(list[index].name),
                      Text(EnumCovert().getBloodName(list[index].bloodLines))
                    ],
                  )),
                  Expanded(
                    child: Text('等级:${list[index].level}'),
                  ),
                  Expanded(
                    child: Text('经验:${list[index].exp}'),
                  ),
                  Expanded(
                    child: Column(children: <Widget>[
                      Text('职业:${list[index].exp}'),
                      DropdownButton<CatJob>(
                        items: FuncUtil()
                            .getCatJobs()
                            .map<DropdownMenuItem<CatJob>>((CatJob value) {
                          return DropdownMenuItem<CatJob>(
                            value: value,
                            child: Text(EnumCovert().getAmbitionName(value)),
                          );
                        }).toList(),
                        onChanged: (job) {
                          list[index].arrange = job;
                          setState(() {
                            replaceAllCatsJob();
                          });
                        },
                      )
                    ]),
                  ),
                  IconButton(
                    tooltip: 'collection',
                    onPressed: () {
                      if (Application.gameContext.leader != list[index])
                        Application.gameContext.leader = list[index];
                      else {
                        Application.gameContext.leader = null;
                      }
                      setState(() {});
                    },
                    icon: Icon(Application.gameContext.leader == list[index]
                        ? Icons.favorite
                        : Icons.favorite_border),
                  )
                ],
              ),
            );
          },
          shrinkWrap: true,
          itemCount: list.length,
        )
      ],
    );
  }
}

void replaceAllCatsJob() {
  Application.gameContext.initCatProfession();
  for (Cat cat in Application.gameContext.cats) {
    Application.gameContext.catProfession[cat.arrange] += 1;
  }
}
