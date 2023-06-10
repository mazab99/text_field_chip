import 'package:flutter/material.dart';
import 'package:text_field_chip/core/util/enum.dart';

class TextFieldChipTags extends StatefulWidget {
  final Color? iconColor;
  final Color? chipColor;
  final Color? textColor;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? separator;
  final List<String> list;

  final ChipPosition chipPosition;
  final bool createTagOnSubmit;

  const TextFieldChipTags({
    Key? key,
    this.iconColor,
    this.chipColor,
    this.textColor,
    this.decoration,
    this.keyboardType,
    this.separator,
    this.createTagOnSubmit = false,
    this.chipPosition = ChipPosition.below,
    required this.list,
  }) : super(key: key);

  @override
  State<TextFieldChipTags> createState() => _TextFieldChipTagsState();
}

class _TextFieldChipTagsState extends State<TextFieldChipTags>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Visibility(
          visible: widget.chipPosition == ChipPosition.above,
          child: _chipListPreview(),
        ),
        Form(
          key: _formKey,
          child: TextField(
            controller: _inputController,
            decoration: widget.decoration ??
                InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: widget.createTagOnSubmit
                      ? ""
                      : " '${widget.separator ?? ''}'",
                ),
            keyboardType: widget.keyboardType ?? TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _focusNode,
            onSubmitted: widget.createTagOnSubmit
                ? (value) {
                    widget.list.add(value);

                    _inputController.clear();

                    _formKey.currentState!.reset();

                    setState(() {});
                    _focusNode.requestFocus();
                  }
                : null,
            onChanged: widget.createTagOnSubmit
                ? null
                : (value) {
                    if (value.endsWith(widget.separator ?? " ")) {
                      if (value != widget.separator &&
                          !widget.list.contains(value.trim())) {
                        widget.list.add(value
                            .replaceFirst(widget.separator ?? " ", '')
                            .trim());
                      }

                      _inputController.clear();
                      _formKey.currentState!.reset();
                      setState(() {});
                    }
                  },
          ),
        ),
        Visibility(
          visible: widget.chipPosition == ChipPosition.below,
          child: _chipListPreview(),
        ),
      ],
    );
  }

  Visibility _chipListPreview() {
    return Visibility(
      visible: widget.list.isNotEmpty,
      child: Wrap(
        children: widget.list.map(
          (text) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: FilterChip(
                backgroundColor: widget.chipColor ?? Colors.blue,
                label: Text(
                  text,
                  style: TextStyle(color: widget.textColor ?? Colors.white),
                ),
                avatar: Icon(
                  Icons.remove_circle_outline,
                  color: widget.iconColor ?? Colors.white,
                ),
                onSelected: (value) {
                  widget.list.remove(text);
                  setState(
                    () {},
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
