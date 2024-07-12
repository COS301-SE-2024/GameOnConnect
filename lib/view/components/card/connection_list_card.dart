import 'package:flutter/material.dart';

class ConnectionCardWidget extends StatelessWidget {
  const ConnectionCardWidget(
  {
    super.key,
    required this.image,
    required this.username,
    required this.uniqueNum
}
      );
  final String image;
  final String username;
  final String uniqueNum;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 388,
        height: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: Theme.of(context).colorScheme.surface,
              offset: const Offset(
                0,
                1,
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(44),
                    child: Image.network(
                      image,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                        child: Text(
                          username,
                          style:
                          TextStyle(
                            fontFamily: 'Inter',
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '# $uniqueNum',
                        style:
                       TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
