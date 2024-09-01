import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_filters_model.dart';
import 'package:gameonconnect/model/game_library_M/game_filter_model.dart';
import 'package:gameonconnect/services/game_library_S/game_filter_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FilterPage extends StatefulWidget {
  final Function(String) apiFunction;
  const FilterPage({super.key, required this.apiFunction});

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
  final ExpandableController _metacriticExpandableController = ExpandableController();

  late Future<FilterList> _filterListFuture;

  final GlobalKey<_ExpandableFilterState> _platformFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _genreFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _storeFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _tagFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _metacriticFilterKey =
      GlobalKey<_ExpandableFilterState>();

  @override
  void initState() {
    super.initState();
    _filterListFuture = GameFilterService.createFilterList();
  }

  void _updateFilterString() {
    setState(() {});
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
        title: Text(
          'Filter',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
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
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return filterList(context, snapshot.data!);
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }

  Widget filterList(BuildContext context, FilterList filterList) {
    return SingleChildScrollView(
        child: Column(children: [
      ExpandableFilter(
        key: _platformFilterKey,
        platformExpandableController: _platformExpandableController,
        filterName: "Platforms",
        filterValues: filterList.platformFilters.toList(),
        onFilterChanged: _updateFilterString,
      ),
      ExpandableFilter(
        key: _genreFilterKey,
        platformExpandableController: _genreExpandableController,
        filterName: "Genres",
        filterValues: filterList.genreFilters.toList(),
        onFilterChanged: _updateFilterString,
      ),
      ExpandableFilter(
        key: _storeFilterKey,
        platformExpandableController: _storeExpandableController,
        filterName: "Stores",
        filterValues: filterList.storeFilters.toList(),
        onFilterChanged: _updateFilterString,
      ),
      ExpandableFilter(
        key: _tagFilterKey,
        platformExpandableController: _tagExpandableController,
        filterName: "Tags",
        filterValues: filterList.tagFilters.toList(),
        onFilterChanged: _updateFilterString,
      ),
      NumberFilter(
        key: _metacriticFilterKey,
        numberExpandableController: _metacriticExpandableController,
        filterName: "Metacritic",
        minValue: 0,
        maxValue: 100,
        onFilterChanged: _updateFilterString,
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _applyFilters,
            child: const Text("Filter"),
          ),
        ),
      ),
    ]));
  }

  void _applyFilters() async {
    String concatenatedFilterString = [
      _platformFilterKey.currentState?.getFilterString() ?? '',
      _genreFilterKey.currentState?.getFilterString() ?? '',
      _storeFilterKey.currentState?.getFilterString() ?? '',
      _tagFilterKey.currentState?.getFilterString() ?? '',
    ].where((filter) => filter.isNotEmpty).join();

    await widget.apiFunction(concatenatedFilterString);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}

class NumberFilter extends StatefulWidget {
  const NumberFilter({
    super.key,
    required this.numberExpandableController,
    required this.filterName,
    required this.onFilterChanged,
    required this.minValue,
    required this.maxValue,
  });

  final ExpandableController numberExpandableController;
  final String filterName;
  final double minValue;
  final double maxValue;
  final VoidCallback onFilterChanged;

  @override
  State<NumberFilter> createState() => _NumberFilterState();
}

class _NumberFilterState extends State<NumberFilter> {
  late String _filterName;
  late double _minValue;
  late double _maxValue;
  late RangeValues valueRange;

  @override
  void initState() {
    super.initState();
    _filterName = widget.filterName;
    _minValue = widget.minValue;
    _maxValue = widget.maxValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: ExpandableNotifier(
            controller: widget.numberExpandableController,
            child: ExpandablePanel(
              header: Text(_filterName),
              collapsed: const SizedBox(width: 0, height: 0),
              expanded: RangeSlider(
                  values: RangeValues(_minValue, _maxValue),
                  onChanged: (RangeValues values) {
                    setState(() {
                      valueRange = values;
                    });
                  },
                  min: _minValue,
                  max: _maxValue),
              theme: const ExpandableThemeData(
                iconColor: Colors.grey,
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
}

class ExpandableFilter extends StatefulWidget {
  const ExpandableFilter({
    super.key,
    required this.platformExpandableController,
    required this.filterName,
    required this.filterValues,
    required this.onFilterChanged,
  });

  final ExpandableController platformExpandableController;
  final String filterName;
  final List<Filter> filterValues;
  final VoidCallback onFilterChanged;

  @override
  State<ExpandableFilter> createState() => _ExpandableFilterState();
}

class _ExpandableFilterState extends State<ExpandableFilter> {
  late String _filterName;
  late List<Filter> _filterValues;
  final List<String> _selectedValues = [];

  @override
  void initState() {
    super.initState();
    _filterName = widget.filterName;
    _filterValues = widget.filterValues;
  }

  String getFilterString() {
    if (_selectedValues.isEmpty) {
      return "";
    }
    return "&${_filterName.toLowerCase()}=${_selectedValues.join(',')}";
  }

  void _onCheckboxChanged(bool? newValue, String value) {
    setState(() {
      if (newValue == true) {
        _selectedValues.add(value);
      } else {
        _selectedValues.remove(value);
      }
      widget.onFilterChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
            width: 0.5,
          ),
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
              expanded: Column(
                children: _buildCheckboxList(context, _filterValues),
              ),
              theme: const ExpandableThemeData(
                iconColor: Colors.grey,
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

  List<Widget> _buildCheckboxList(BuildContext context, List<Filter> values) {
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
          value: _selectedValues.contains(value.id),
          onChanged: (newValue) => _onCheckboxChanged(newValue, value.id),
          title: Text(
            value.value,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Theme.of(context).colorScheme.surface,
          dense: true,
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      );
    }).toList();
  }
}
