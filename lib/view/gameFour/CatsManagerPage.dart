import 'package:common_utils/common_utils.dart';
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
          color: Color(0xffb0f4e6),
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
    String leaderName = Application.gameContext.leader==null?"!!!":Application.gameContext.leader.name;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
              "幸福度${NumUtil.getNumByValueDouble(Application.gameContext.saturability * 100, 1)} %",
              style: TextStyle(
                  color: Colors.purple[200], fontSize: 20, fontFamily: 'Miao')),
        ),
        Center(
          child: Text("这里一共有$count只喵喵",
              style: TextStyle(
                  color: Colors.purple[200], fontSize: 20, fontFamily: 'Miao')),
        ),
        lazy == 0
            ? SizedBox(
                width: 0,
                height: 0,
              )
            : Text("$lazy只喵喵在睡懒觉，快把${lazy > 1 ? '它们' : '它'}叫醒",
                style: TextStyle(
                    color: Colors.purple[200],
                    fontSize: 14,
                    fontFamily: 'Miao')),
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
                    child: Text(list[index].name),
                    flex: 1,
                  ),
                  Expanded(
                    child: Center(child: Text('等级:${list[index].level}')),
                    flex: 1,
                  ),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('职业:  ', style: TextStyle(fontSize: 15)),
                          DropdownButton<CatJob>(
                            items: FuncUtil()
                                .getCatJobs()
                                .map<DropdownMenuItem<CatJob>>((CatJob value) {
                              return DropdownMenuItem<CatJob>(
                                value: value,
                                child: Text(
                                  EnumCovert().getAmbitionName(value),
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }).toList(),
                            onChanged: (job) {
                              list[index].arrange = job;
                              setState(() {
                                replaceAllCatsJob();
                              });
                            },
                            value: list[index].arrange,
                          ),
                        ]),
                    flex: 2,
                  ),
                  IconButton(
                    onPressed: () {
                      if (Application.gameContext.leader != list[index])
                        Application.gameContext.leader = list[index];
                      else {
                        Application.gameContext.leader = null;
                      }
                      setState(() {});
                    },
                    icon: Icon(
                        leaderName == list[index].name
                            ? Icons.favorite
                            : Icons.favorite_border),
                  ),
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
