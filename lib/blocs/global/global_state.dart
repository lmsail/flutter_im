part of 'global_bloc.dart';

@immutable
abstract class GlobalState extends Equatable {
  const GlobalState();

  @override
  List<Object> get props => [];
}

class GlobalInitial extends GlobalState {}

/// 底部 navBar 显示
class NavBarShow extends GlobalState {
  NavBarShow();

  @override
  List<Object> get props => [];
}

/// 底部 navBar 隐藏
class NavBarHidden extends GlobalState {
  NavBarHidden();

  @override
  List<Object> get props => [];
}
