import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_filters_model.dart';
import 'package:gameonconnect/model/game_library_M/game_filter_model.dart';
import 'package:gameonconnect/services/game_library_S/game_filter_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FilterPage extends StatefulWidget {
  final Function(String, List<String>) filterFunction;
  final Function() clearFiltersFunction;
  const FilterPage(
      {super.key,
      required this.filterFunction,
      required this.clearFiltersFunction});

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
  final ExpandableController _metacriticExpandableController =
      ExpandableController();

  late Future<FilterList> _filterListFuture;

  final GlobalKey<_ExpandableFilterState> _platformFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _genreFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _storeFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_ExpandableFilterState> _tagFilterKey =
      GlobalKey<_ExpandableFilterState>();
  final GlobalKey<_NumberFilterState> _metacriticFilterKey =
      GlobalKey<_NumberFilterState>();

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
      appBar: BackButtonAppBar(
        title: 'Filter',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        iconkey: const Key('Back_button_key'),
        textkey: const Key('filter_text'),
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
        onFilterChanged: _updateFilterString,
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: _applyFilters,
                child: Text("Filter",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextButton.icon(
                icon: const Icon(Icons.clear),
                iconAlignment: IconAlignment.end,
                onPressed: _clearFilters,
                label: const Text('Clear filters'),
              ),
            ),
          ],
        ),
      ),
    ]));
  }

  void _clearFilters() {
    setState(() {});
    widget.clearFiltersFunction();
    Navigator.pop(context);
  }

  void _applyFilters() async {
    List<String> activeFilters =
        _platformFilterKey.currentState!.getFilterValues() +
            _genreFilterKey.currentState!.getFilterValues() +
            _storeFilterKey.currentState!.getFilterValues() +
            _tagFilterKey.currentState!.getFilterValues();
    activeFilters.add(_metacriticFilterKey.currentState!.getNumberValue());
    String concatenatedFilterString = [
      _platformFilterKey.currentState?.getFilterString() ?? '',
      _genreFilterKey.currentState?.getFilterString() ?? '',
      _storeFilterKey.currentState?.getFilterString() ?? '',
      _tagFilterKey.currentState?.getFilterString() ?? '',
      _metacriticFilterKey.currentState?.getFilterString() ?? '',
    ].where((filter) => filter.isNotEmpty).join();
    await widget.filterFunction(concatenatedFilterString, activeFilters);
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
  });

  final ExpandableController numberExpandableController;
  final String filterName;
  final VoidCallback onFilterChanged;

  @override
  State<NumberFilter> createState() => _NumberFilterState();
}

class _NumberFilterState extends State<NumberFilter> {
  late String _filterName;
  late RangeValues _valueRange;

  @override
  void initState() {
    super.initState();
    _filterName = widget.filterName;
    _valueRange = const RangeValues(0, 100);
  }

  String getNumberValue() {
    return 'Metacritic score: ${_valueRange.start.toInt()} - ${_valueRange.end.toInt()}';
  }

  String getFilterString() {
    return "&${_filterName.toLowerCase()}=${_valueRange.start.toInt()},${_valueRange.end.toInt()}";
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
                  values: _valueRange,
                  divisions: 100,
                  labels: RangeLabels(
                    _valueRange.start.round().toString(),
                    _valueRange.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _valueRange = values;
                    });
                    widget.onFilterChanged();
                  },
                  min: 0,
                  max: 100),
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

  List<String> getFilterValues() {
    return _selectedValues.map((id) {
      final filter = _filterValues.firstWhere((filter) => filter.id == id,
          orElse: () => Filter(value: 'Unknown', id: id));
      return filter.value;
    }).toList();
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
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_filterName),
                  _selectedValues.isNotEmpty ? Text(
                    '(${_selectedValues.length} selected)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : const SizedBox(),
                ],
              ),
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
