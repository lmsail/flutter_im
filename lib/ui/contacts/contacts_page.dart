import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_im/blocs/global/global_bloc.dart';
import 'package:flutter_im/constant/style.dart';
import 'package:flutter_im/ui/contacts/contacts_service.dart';
import 'package:flutter_im/ui/contacts/contacts_widget.dart';
import 'package:flutter_im/http/model/contact/contact.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with AutomaticKeepAliveClientMixin {
  List<ContactInfo> contactList = [];
  SlidableController _slidableController; // 侧滑controller
  bool _showSearch = false; // 是否展示搜索页
  double _offset = 0.0; // 偏移量（导航栏）
  bool _slideIsOpen = false; // 侧滑按钮是否展开

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fectContactsList();

    /// 监听侧滑事件
    _slidableController = SlidableController(
      onSlideAnimationChanged: (Animation<double> slideAnimation) {},
      onSlideIsOpenChanged: (bool isOpen) => setState(() => _slideIsOpen = isOpen),
    );
  }

  /// 加载联系人列表
  void _fectContactsList() async {
    List<ContactInfo> list = await ContactsService.loadContactList();
    setState(() => contactList = list);
  }

  /// 关闭slidable
  void _closeSlidable() {
    if (!_slideIsOpen) return; // 容错处理
    _slidableController.activeState?.close();
  }

  /// 构建侧滑按钮组件
  Widget _buildUserListItem(BuildContext context, ContactInfo model, {Color defHeaderBgColor}) {
    return IndexBarWidget.buildUserListItem(context, model, _slideIsOpen, _slidableController, onTapValue: (cxt) {
      if (!_slideIsOpen) return;
      if (Slidable.of(cxt)?.renderingMode == SlidableRenderingMode.none) {
        _closeSlidable(); // 关闭上一个侧滑
      } else {
        Slidable.of(cxt)?.close();
      }
    }, slidableTap: () {
      print('🔥点了备注按钮咯！');
    });
  }

  void setSearchAndNavBarStatus(bool searchStatus) {
    setState(() => _showSearch = searchStatus);
    BlocProvider.of<GlobalBloc>(context).add(NavBarStatusChangeEvent(status: !searchStatus));
  }

  /// 构建通讯录列表
  Widget buildListView(List<ContactInfo> contactList) {
    return AzListView(
      data: contactList,
      itemCount: contactList.length,
      itemBuilder: (BuildContext context, int index) {
        ContactInfo model = contactList[index];
        if (index == 0) {
          /// 新增状态监听
          return BlocConsumer<GlobalBloc, GlobalState>(
            builder: (BuildContext context, GlobalState state) {
              return IndexBarWidget.buildListViewHeader(
                context,
                Color(0xFFE5E5E5),
                onEdit: () => setSearchAndNavBarStatus(true),
                onCancel: () => setSearchAndNavBarStatus(false),
              );
            },
            listener: (BuildContext context, GlobalState state) {},
          );
        }
        return _buildUserListItem(context, model, defHeaderBgColor: Color(0xFFE5E5E5));
      },
      // physics: BouncingScrollPhysics(), // 页面弹动
      susItemBuilder: (BuildContext context, int index) {
        ContactInfo model = contactList[index];
        if ('🔍' == model.getSuspensionTag()) return Container();
        return IndexBarWidget.getSusItem(context, model.getSuspensionTag());
      },
      indexBarData: ['🔍', ...kIndexBarData],
      indexBarOptions: IndexBarWidget.indexBarOptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Style.pBackgroundColor,
        child: Stack(clipBehavior: Clip.none, children: <Widget>[
          IndexBarWidget.buildAppBarWidget(_showSearch),
          ContactsWidget.buildAnimatedPositioned(
            key: 'list',
            hasBox: true,
            top: _showSearch ? -kToolbarHeight : _offset,
            child: buildListView(contactList),
          ),
          ContactsWidget.buildSearchContent(_showSearch),
        ]),
      ),
    );
  }
}
