import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar(
      {
        Key? key,
        required this.height,
        required this.items,
        required this.backgroundColor
      }) : super(key: key);

  final double height;
  final List<Widget> items;

  final Color backgroundColor;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: widget.height,
      color: widget.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: widget.items,
      ),
    );
  }
}

class CustomNavigationBarItem extends StatefulWidget {
  const CustomNavigationBarItem(
      {Key? key,
        required this.size,
        required this.title,
        required this.selectedIcon,
        required this.unselectedIcon,
        required this.selectedColorBegin,
        required this.selectedColorEnd,
        required this.isSelected,
        required this.onClicked
      }) : super(key: key);

  final double size;

  final Text title;
  final Widget selectedIcon;
  final Widget unselectedIcon;

  final Color selectedColorBegin;
  final Color selectedColorEnd;

  final bool isSelected;

  final Function onClicked;

  @override
  State<CustomNavigationBarItem> createState() => _CustomNavigationBarItemState();
}

class _CustomNavigationBarItemState extends State<CustomNavigationBarItem> with TickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.4),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          widget.onClicked();
        },
        child: SlideTransition(
          position: _offsetAnimation,
          child: AnimatedContainer(
            width: widget.size,
            height: widget.size,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              gradient: LinearGradient(
                  colors: widget.isSelected ? [widget.selectedColorBegin, widget.selectedColorEnd] : [Colors.transparent, Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isSelected ? widget.selectedIcon : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [widget.unselectedIcon, widget.title],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
