import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';

class TotalTimeComponent extends StatelessWidget {
  final double todayTime;
  final double pastWeekTime;
  final double pastMonthTime;
  final double allTime;
  final double playPercentage;

  const TotalTimeComponent({
    super.key,
    required this.todayTime,
    required this.pastWeekTime,
    required this.pastMonthTime,
    required this.allTime,
    required this.playPercentage,
  });

  String formatTime(double time) {
    if (time < 1) {
      return '${(time * 60 * 1000).toStringAsFixed(0)} minutes';
    } else {
      return '${time.toStringAsFixed(1)} hours';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.pixelScale(context), 20.pixelScale(context), 12.pixelScale(context), 10.pixelScale(context)),
          child: Text(
            'Total Time Played',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.pixelScale(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20.pixelScale(context)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.pixelScale(context), 10.pixelScale(context), 12.pixelScale(context), 10.pixelScale(context)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 110.pixelScale(context),
                      height: 110.pixelScale(context),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10.pixelScale(context)),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Padding(
                            padding: EdgeInsets.all(2.pixelScale(context)),
                            child: Text(
                              'Today',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(2.pixelScale(context)),
                            child: Text(
                              formatTime(todayTime),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 110.pixelScale(context),
                      height: 110.pixelScale(context),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10.pixelScale(context)),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Padding(
                            padding: EdgeInsets.all(2.pixelScale(context)),
                            child: Text(
                              'Past week',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(2.pixelScale(context)),
                            child: Text(
                              formatTime(pastWeekTime),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 110.pixelScale(context),
                      height: 110.pixelScale(context),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10.pixelScale(context)),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Padding(
                            padding: EdgeInsets.all(2.pixelScale(context)),
                            child: Text(
                              'Past month',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(2.pixelScale(context)),
                            child: Text(
                              formatTime(pastMonthTime),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.pixelScale(context), 10.pixelScale(context), 12.pixelScale(context), 10.pixelScale(context)),
                child: Container(
                  width: double.infinity,
                  height: 110.pixelScale(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10.pixelScale(context)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(6.pixelScale(context)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                 Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 2.pixelScale(context), 0),
                                  child: Text(
                                    'You have played',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.pixelScale(context),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsetsDirectional.fromSTEB(2.pixelScale(context), 0, 2.pixelScale(context), 0),
                                  child: Text(
                                    allTime.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.pixelScale(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(2.pixelScale(context), 0, 0, 0),
                              child: Text(
                                'hours in total. Wow!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.pixelScale(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.asset(
                            'assets/images/stats_icon1.png',
                            width: 100.pixelScale(context),
                            height: 100.pixelScale(context),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsetsDirectional.fromSTEB(12.pixelScale(context), 10.pixelScale(context), 12.pixelScale(context), 12.pixelScale(context)),
                child: Container(
                  width: double.infinity,
                  height: 100.pixelScale(context),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10.pixelScale(context)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(6.pixelScale(context)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.asset(
                            'assets/images/stats_icon2.png',
                            width: 110.pixelScale(context),
                            height: 100.pixelScale(context),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              'You have played more than',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.pixelScale(context),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:  EdgeInsetsDirectional.fromSTEB(0, 0, 2.pixelScale(context), 0),
                                  child: Text(
                                    '${playPercentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.pixelScale(context),
                                    ),
                                  ),
                                ),
                                 Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(2.pixelScale(context), 0, 0, 0),
                                  child: Text(
                                    'of players',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.pixelScale(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
