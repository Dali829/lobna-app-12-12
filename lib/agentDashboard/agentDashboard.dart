import 'package:ecommerce/dashboard/table_Product.dart';
import 'package:flutter/material.dart';

import 'demandeReservation.dart';

class DashboardAgentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              title: Text('Dashboard Agent'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(child: Text('Articles')),
                  Tab(child: Text('Mes demandes de réservationss')),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            TableProduct(),
            ResDemande(),
          ],
        ),
      )),
    );
  }
}
