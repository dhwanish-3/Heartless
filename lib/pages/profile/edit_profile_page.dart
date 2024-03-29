import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/pages/log/file_upload_preview_page.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser user;
  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
    _nameController.text = widget.user.name;
    _passwordController.text = widget.user.password;
  }

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier = Provider.of<WidgetNotifier>(
      context,
      listen: false,
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _ProfileImage(user: widget.user),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFieldInput(
                          textEditingController: _nameController,
                          hintText: 'Enter your email',
                          labelText: 'name',
                          startIcon: 'assets/Icons/user.svg',
                          textInputType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
                        TextFieldInput(
                          textEditingController: _emailController,
                          hintText: 'Enter your email',
                          labelText: 'email',
                          startIcon: 'assets/Icons/Email.svg',
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        Consumer<WidgetNotifier>(
                            builder: (context, value, child) {
                          return TextFieldInput(
                            textEditingController: _passwordController,
                            hintText: 'Enter your password',
                            labelText: 'password',
                            startIcon: 'assets/Icons/lock.svg',
                            endIcon: 'assets/Icons/eyeClosed.svg',
                            endIconAlt: 'assets/Icons/eyeOpened.svg',
                            passwordShown: widgetNotifier.passwordShown,
                            textInputType: TextInputType.visiblePassword,
                          );
                        }),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 20,
                          ),
                          child: IntlPhoneField(
                            initialCountryCode: 'IN',
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                              counterText: '',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                            ),
                            onChanged: (phone) {
                              _phoneNumber = phone.completeNumber;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomFormSubmitButton(
                          onTap: () {
                            //todo edit changes,
                          },
                          padding: 10,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({
    super.key,
    required this.user,
  });

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
            width: 1,
          ),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: Uri.parse(user.imageUrl).isAbsolute
                ? user.imageUrl
                : 'https://via.placeholder.com/150',
            height: 160,
            width: 160,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            // todo: modify the error widget
            errorWidget: (context, url, error) => Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).shadowColor,
                ),
                child: const Icon(
                  Icons.person_2_outlined,
                  color: Colors.black,
                  size: 30,
                )),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            onPressed: () {
//add image picker
            },
            iconSize: 24,
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ]);
  }
}
