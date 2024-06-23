import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final ExpandableController _platformExpandableController =
      ExpandableController();
  final ExpandableController _storeExpandableController =
      ExpandableController();
  final ExpandableController _genreExpandableController =
      ExpandableController();
  final ExpandableController _tagExpandableController = ExpandableController();
  // final ExpandableController _metacriticExpandableController =
  //     ExpandableController();
  // final ExpandableController _releaseExpandableController =
  //     ExpandableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              //pop this page;
            },
          ),
          title: Text('Filter',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              )),
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
            top: true,
            child: filterList(context)));
  }

  ListView filterList(BuildContext context) {
    return ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                ExpandableFilter(platformExpandableController: _platformExpandableController, filterName: "Platforms", filterValues: const ["PC", "Xbox", "PlayStation"]),
                ExpandableFilter(platformExpandableController: _genreExpandableController, filterName: "Genres", filterValues: const ["PC", "Xbox", "PlayStation"]),
                ExpandableFilter(platformExpandableController: _storeExpandableController, filterName: "Stores", filterValues: const ["PC", "Xbox", "PlayStation"]),
                ExpandableFilter(platformExpandableController: _tagExpandableController, filterName: "Tags", filterValues: const ["PC", "Xbox", "PlayStation"],),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: FilledButton(
                    onPressed: () {
                      // print("Filter clicked");
                    },
                    child: const Text("Filter"),
                  ),
                )
              ]);
  }
}

class ExpandableFilter extends StatefulWidget {
  const ExpandableFilter({
    super.key,
    required ExpandableController platformExpandableController,
    required this.filterName,
    required this.filterValues,
  }) : _platformExpandableController = platformExpandableController;

  final ExpandableController _platformExpandableController;
  final String filterName;
  final List<String> filterValues;

  @override
  State<ExpandableFilter> createState() => _ExpandableFilterState();
}

class _ExpandableFilterState extends State<ExpandableFilter> {
  late String _filterName;
  late List<String> _filterValues;

  @override
  void initState() {
    super.initState();
    _filterName = widget.filterName; 
    _filterValues = widget.filterValues; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: ExpandableNotifier(
            controller: widget._platformExpandableController,
            child: ExpandablePanel(
              header: Text(
                _filterName,
              ),
              collapsed: const SizedBox(
                width: 0,
                height: 0,
              ),
              expanded: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: 
                  _buildCheckboxList(context, _filterValues),
              ),
              theme: const ExpandableThemeData(
                tapHeaderToExpand: true,
                tapBodyToExpand: false,
                tapBodyToCollapse: false,
                headerAlignment:
                    ExpandablePanelHeaderAlignment.center,
                hasIcon: true,
                expandIcon: Icons.chevron_right,
                collapseIcon: Icons.keyboard_arrow_down,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCheckboxList(BuildContext context, List<String> values) {
    return values.map((value) {
      return Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    unselectedWidgetColor:
                        Theme.of(context).colorScheme.tertiary,
                  ),
                  child: CheckboxListTile(
                    value: false,
                    onChanged: (newValue) async {
                      //change the checkbox state
                    },
                    title: Text(
                      value,
                    ),
                    tileColor:
                        Theme.of(context).colorScheme.surface,
                    activeColor:
                        Theme.of(context).colorScheme.primary,
                    checkColor:
                        Theme.of(context).colorScheme.surface,
                    dense: true,
                    controlAffinity:
                        ListTileControlAffinity.trailing,
                  ),
                );
    }).toList();
    
  }
}
