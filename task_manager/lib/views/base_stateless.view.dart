import 'package:flutter/cupertino.dart';

abstract class BaseStatelessView<BaseController> extends StatelessWidget {
  final BaseController controller;

  const BaseStatelessView({Key? key, required this.controller}) : super(key: key);
}
