import 'package:ecommerce/dashboard/reservationAdmin.dart';
import 'package:ecommerce/dashboard/table_Category.dart';
import 'package:ecommerce/dashboard/table_Users.dart';
import 'package:flutter/material.dart';

import 'demandeAgnet.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Dashboard Admin'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(child: Text('Categories')),
                  Tab(child: Text('Utilisateurs')),
                  Tab(child: Text('Demandes')),
                  Tab(child: Text('Réservations')),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            TableCategory(),
            TableUsers(),
            TableDemande(),
            ResDemandeAdmin(),
          ],
        ),
      )),
    );
  }
}
