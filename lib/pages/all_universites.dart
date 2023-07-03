import 'package:flutter/material.dart';
import 'package:my_api/api/my_api.dart';
import 'package:my_api/models/my_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class AllUni extends StatefulWidget {
  final String theName;
  const AllUni({
    super.key,
    required this.theName,
  });

  @override
  State<AllUni> createState() => _AllUniState();
}

class _AllUniState extends State<AllUni> {
  List<MainModel>? allResponse;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final RefreshController _refreshController2 =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await getAllRequest(widget.theName).then(
      (value) => setState(
        () {
          allResponse = value;
        },
      ),
    );

    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    getAllRequest(widget.theName).then((value) => allResponse = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white12,
                content: Text(
                  "(${allResponse![0].country})\nNumber of university in this list:\n${allResponse!.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.info,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: getAllRequest(widget.theName),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MainModel>> snapshot) {
                if (!(snapshot.hasData)) {
                  return const LinearProgressIndicator();
                }
                return allResponse == null || allResponse!.isEmpty == true
                    ? SmartRefresher(
                        controller: _refreshController2,
                        onRefresh: onRefresh,
                        child: const Center(
                          child: Text(
                            "Bad internet connection or entered wrong Country name!!!Please try again",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      )
                    : Center(
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: onRefresh,
                          child: ListView.builder(
                            itemCount: allResponse!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  color: Colors.black,
                                  elevation: 10.0,
                                  child: ListTile(
                                    trailing: const Icon(
                                      Icons.school,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      "Country: ${allResponse![index].country}\nName:  ${allResponse![index].name}\n",
                                      style: TextStyle(
                                        color: Colors.green.shade500,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            final Uri url = Uri.parse(
                                              "${allResponse![index].webPages[0]}",
                                            );
                                            if (!await launchUrl(url)) {
                                              throw Exception(
                                                  'Could not launch $url');
                                            }
                                          },
                                          child: LimitedBox(
                                            maxWidth: 200.0,
                                            child: Text(
                                              "${allResponse![index].webPages[0]}",
                                              style: TextStyle(
                                                color: Colors.blue.shade600,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
