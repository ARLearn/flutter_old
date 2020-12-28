import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/general_item.dart';

import '../../../general_item.dart';
import 'button_text_style.dart';
import 'content_card.dart';

class ContentCardText extends StatelessWidget {
  GeneralItem item;
  GeneralItemViewModel giViewModel;
  Widget button;
  String title;
  String text;
  bool showOnlyButton;

  ContentCardText({this.giViewModel, this.button, this.text, this.title, this.showOnlyButton});

  // : super(item: giViewModel.item,
  // content:  null,
  // button: button, showOnlyButton: showOnlyButton);

  @override
  Widget build(BuildContext context) {
    // if (this.button == null) return Container();
    List<Widget> widgets = [];
    bool hasTitle = title != null && title.trim().isNotEmpty;
    bool hasText = text != null && text.trim().isNotEmpty;
    if (hasTitle) widgets.add(buildTitle());
    if (hasText) widgets.add(buildContent(context));
    if (button != null) widgets.add(buildButton());
    if (widgets.isEmpty) {
      return Container();
    }
    if (!hasTitle && !hasText) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 30),
        child: button,
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }

  buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
      child: Text('${this.title.toUpperCase()}',
          style: AppConfig.isTablet()
              ? AppConfig().customTheme.cardTitleStyleTablet
              : AppConfig().customTheme.cardTitleStyle),
    );
  }

  buildContent(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.width / 3 * 2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Stack(
          children: [
            new SingleChildScrollView(
              scrollDirection: Axis.vertical, //.horizontal(
              child: Text('${this.text} \n\n', style:
              AppConfig().customTheme.cardContentStyle),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.transparent, Colors.white],
                    ).createShader(bounds);
                  },
                  child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical, //.horizontal(
                    child: Container(
                      height: 50,
                      color: Colors.white,
                    ),
                  ),
                  blendMode: BlendMode.dstATop,
                ))
          ],
        ),
      ),
    );
  }

  buildButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
      child: button,
    );
  }
}
