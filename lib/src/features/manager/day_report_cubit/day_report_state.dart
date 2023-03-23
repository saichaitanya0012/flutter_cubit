part of 'day_report_cubit.dart';

@immutable
abstract class DayReportState {}

class DayReportInitial extends DayReportState {}

class DayReportLoading extends DayReportState {}

class DayReportSuccess extends DayReportState {
  final List<Map<dynamic, dynamic>> jsonList;

  DayReportSuccess({required this.jsonList});
}

class DayReportFailed extends DayReportState {
  final String message;

  DayReportFailed({required this.message});
}

