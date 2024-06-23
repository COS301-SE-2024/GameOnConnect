import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_filters.dart'; 
import 'package:gameonconnect/model/game_filter.dart'; 

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final ExpandableController _platformExpandableController = ExpandableController();
  final ExpandableController _storeExpandableController = ExpandableController();
  final ExpandableController _genreExpandableController = ExpandableController();
  final ExpandableController _tagExpandableController = ExpandableController();

  late Future<FilterList> _filterListFuture;

  @override
  void initState() {
    super.initState();
    _filterListFuture = FilterList.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pop(context);
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
          child: FutureBuilder<FilterList>(
            future: _filterListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return filterList(context, snapshot.data!);
              } else {
                return Center(child: Text('No data'));
              }
            },
          ),
        )
    );
  }

  ListView filterList(BuildContext context, FilterList filterList) {
    return ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: [
        ExpandableFilter(
          platformExpandableController: _platformExpandableController,
          filterName: "Platforms",
          filterValues: filterList.platformFilters.map((filter) => filter.value).toList(),
        ),
        ExpandableFilter(
          platformExpandableController: _genreExpandableController,
          filterName: "Genres",
          filterValues: filterList.genreFilters.map((filter) => filter.value).toList(),
        ),
        ExpandableFilter(
          platformExpandableController: _storeExpandableController,
          filterName: "Stores",
          filterValues: filterList.storeFilters.map((filter) => filter.value).toList(),
        ),
        ExpandableFilter(
          platformExpandableController: _tagExpandableController,
          filterName: "Tags",
          filterValues: filterList.tagFilters.map((filter) => filter.value).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FilledButton(
            onPressed: () {
              // Handle filter button click
            },
            child: const Text("Filter"),
          ),
        )
      ],
    );
  }
}

class ExpandableFilter extends StatefulWidget {
  const ExpandableFilter({
    super.key,
    required this.platformExpandableController,
    required this.filterName,
    required this.filterValues,
  });

  final ExpandableController platformExpandableController;
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
            controller: widget.platformExpandableController,
            child: ExpandablePanel(
              header: Text(_filterName),
              collapsed: const SizedBox(width: 0, height: 0),
              expanded: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: _buildCheckboxList(context, _filterValues),
              ),
              theme: const ExpandableThemeData(
                tapHeaderToExpand: true,
                tapBodyToExpand: false,
                tapBodyToCollapse: false,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
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
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          unselectedWidgetColor: Theme.of(context).colorScheme.tertiary,
        ),
        child: CheckboxListTile(
          value: false,
          onChanged: (newValue) async {
            // Change the checkbox state
          },
          title: Text(value),
          tileColor: Theme.of(context).colorScheme.surface,
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Theme.of(context).colorScheme.surface,
          dense: true,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      );
    }).toList();
  }
}
