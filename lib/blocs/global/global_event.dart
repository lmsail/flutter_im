part of 'global_bloc.dart';

@immutable
abstract class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class EventInitApp extends GlobalEvent {
  const EventInitApp();

  @override
  List<Object> get props => [];
}

/// 控制底部导航栏显示或隐藏的时间
class NavBarStatusChangeEvent extends GlobalEvent {
  final bool status;
  NavBarStatusChangeEvent({this.status});
}
