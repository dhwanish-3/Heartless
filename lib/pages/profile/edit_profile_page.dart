import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/auth_controller.dart';
import 'package:heartless/backend/services/firebase_storage/firebase_storage_service.dart';
import 'package:heartless/pages/log/file_upload_preview_page.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker picker = ImagePicker();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  File? _image;
  String _phoneNumber = '';

  void _pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        ToastMessage().showError("No image picked");
      }
    });
  }

  void _submitForm(WidgetNotifier widgetNotifier) async {
    widgetNotifier.setLoading(true);

    if (_formKey.currentState!.validate()) {
      // check if the user has changed the profile image
      if (_image != null) {
        // delete the old image
        await FirebaseStorageService.deleteImage(widget.user.imageUrl);
        await FirebaseStorageService.uploadFile(widget.user.uid, _image!)
            .then((value) {
          widget.user.imageUrl = value;
        }).catchError((error) {
          ToastMessage().showError(error.toString());
          widgetNotifier.setLoading(false);

          return;
        });
      }

      // update the user profile
      widget.user.name = _nameController.text;
      widget.user.email = _emailController.text;
      widget.user.phone = _phoneNumber;
      await AuthController().updateProfile(widget.user);
      widgetNotifier.setLoading(false);
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
    _nameController.text = widget.user.name;
    _phoneNumber = widget.user.phone == null ? '' : widget.user.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                _ProfileImage(
                    user: widget.user, image: _image, onTap: _pickImage),
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
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 20,
                          ),
                          child: IntlPhoneField(
                            initialCountryCode: 'IN',
                            initialValue: _phoneNumber,
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
                        const SizedBox(height: 40),
                        CustomFormSubmitButton(
                          text: 'Update Profile',
                          onTap: () {
                            _submitForm(Provider.of<WidgetNotifier>(context,
                                listen: false));
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
    required this.image,
    required this.onTap,
  });

  final AppUser user;
  final File? image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).secondaryHeaderColor,
            width: 1,
          ),
        ),
        child: ClipOval(child: _showProfile(user.imageUrl, image)),
      ),
      Positioned(
        bottom: 6,
        right: 6,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            onPressed: onTap,
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

  _showProfile(String profileUrl, File? image) {
    if (profileUrl == '' && image == null) {
      return const Center(
          child: Icon(
        Icons.account_box,
        color: Colors.blue,
        size: 130,
      ));
    } else if (image != null) {
      return Container(
        height: 200.0,
        width: 200.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.file(
              image,
              fit: BoxFit.cover,
            )),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: Uri.parse(user.imageUrl).isAbsolute
            ? user.imageUrl
            : 'https://via.placeholder.com/150',
        height: 200,
        width: 200,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        // todo: modify the error widget
        errorWidget: (context, url, error) => Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).shadowColor,
            ),
            child: const Icon(
              Icons.person_2_outlined,
              color: Colors.black,
              size: 30,
            )),
      );
    }
  }
}
