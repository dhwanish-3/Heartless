import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import 'package:heartless/widgets/schedule/date_time_carousel.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    return Scaffold(
        body: Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter title of task',
              labelText: 'Title',
              textInputType: TextInputType.text,
            ),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Instructions or Description',
              labelText: 'Description',
              maxLines: 2,
              textInputType: TextInputType.text,
            ),
            const TimePickerButton(),
          ],
        ),
      ),
    ));
  }
}
