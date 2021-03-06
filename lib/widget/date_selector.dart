import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/internal/providers.dart';
import 'package:potato_notes/internal/locales/locale_strings.g.dart';

class DateFilterSelector extends StatefulWidget {
  final DateTime date;
  final DateFilterMode mode;
  final Function(DateTime, DateFilterMode) onConfirm;
  final Function() onReset;

  DateFilterSelector({
    @required this.date,
    this.mode = DateFilterMode.ONLY,
    this.onConfirm,
    this.onReset,
  });

  @override
  _DateFilterSelectorState createState() => _DateFilterSelectorState();

  static String stringFromDateMode(DateFilterMode mode) {
    switch (mode) {
      case DateFilterMode.AFTER:
        return LocaleStrings.common.dateFilterModeAfter;
        break;
      case DateFilterMode.BEFORE:
        return LocaleStrings.common.dateFilterModeBefore;
        break;
      case DateFilterMode.ONLY:
      default:
        return LocaleStrings.common.dateFilterModeExact;
        break;
    }
  }
}

class _DateFilterSelectorState extends State<DateFilterSelector> {
  DateTime selectedDate;
  DateFilterMode selectedMode;

  @override
  void initState() {
    selectedDate = widget.date ?? DateTime.now();
    selectedMode = widget.mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget list = ListView(
      shrinkWrap: true,
      children: <Widget>[
        _DateFilterSelectorHeader(
          selectedDate,
          onReset: widget.onReset,
        ),
        CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (date) => setState(() => selectedDate = date),
        ),
        ListTile(
          title: Text(LocaleStrings.common.dateFilterMode),
          contentPadding: EdgeInsets.symmetric(horizontal: 24),
          trailing: DropdownButton(
            items: [
              DropdownMenuItem(
                child: Text(
                  DateFilterSelector.stringFromDateMode(DateFilterMode.AFTER),
                ),
                value: DateFilterMode.AFTER,
              ),
              DropdownMenuItem(
                child: Text(
                  DateFilterSelector.stringFromDateMode(DateFilterMode.BEFORE),
                ),
                value: DateFilterMode.BEFORE,
              ),
              DropdownMenuItem(
                child: Text(
                  DateFilterSelector.stringFromDateMode(DateFilterMode.ONLY),
                ),
                value: DateFilterMode.ONLY,
              ),
            ],
            value: selectedMode,
            onChanged: (mode) => setState(() => selectedMode = mode),
          ),
        ),
      ],
    );
    final Widget base = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        deviceInfo.isLandscape ? Expanded(child: list) : list,
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(LocaleStrings.common.cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              SizedBox(
                width: 8,
              ),
              TextButton(
                child: Text(LocaleStrings.common.confirm),
                onPressed: () {
                  widget.onConfirm(selectedDate, selectedMode);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );

    if (deviceInfo.isLandscape) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.shortestSide,
        ),
        child: base,
      );
    } else {
      return base;
    }
  }
}

class _DateFilterSelectorHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback onReset;

  _DateFilterSelectorHeader(this.date, {this.onReset});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Row(
          children: <Widget>[
            Text(
              DateFormat("EEE, MMM d", context.locale.toLanguageTag())
                  .format(date),
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Spacer(),
            TextButton(
              child: Text(LocaleStrings.common.reset),
              onPressed: () {
                onReset?.call();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
