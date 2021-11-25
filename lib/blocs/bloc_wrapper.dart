import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_im/blocs/global/global_bloc.dart';
import 'package:flutter_im/blocs/login/login_bloc.dart';

/// 说明: Bloc提供器包裹层

class BlocWrapper extends StatefulWidget {
  final Widget child;

  BlocWrapper({this.child});

  @override
  _BlocWrapperState createState() => _BlocWrapperState();
}

class _BlocWrapperState extends State<BlocWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 新增的状态组件，在此依次添加
        BlocProvider<GlobalBloc>(create: (_) => GlobalBloc()),
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
      ],
      child: widget.child,
    );
  }

  @override
  void dispose() {
    // 这里将用到的所有组件移除，防止内存溢出
    super.dispose();
  }
}
