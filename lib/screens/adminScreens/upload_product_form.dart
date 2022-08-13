import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:dog_share/consts/colors.dart';
import 'package:dog_share/services/global_method.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

enum IndGrp { Individual, Group, Either }

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _petName = '';
  var _petAge = '';
  var _petGender = '';
  var _petBreed = '';
  var _petDescription = '';
  String? _gameTime = "20";
  var _pellets = '';

  final TextEditingController _petGenderController = TextEditingController();
  String? _categoryValue;
  String? _brandValue;
  GlobalMethods _globalMethods = GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String? url;
  var uuid = const Uuid();
  final FixedExtentScrollController _petGenderPickerScrollController =
      FixedExtentScrollController(initialItem: 0);

  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print(_petName);
      print(_petAge);
      print(_petGender);
      print(_petBreed);
      print(_petDescription);
      print(_gameTime);
      // Use those values to send our request ...
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('petImages')
              .child(_petName + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final productId = uuid.v4();
          await FirebaseFirestore.instance
              .collection('pets')
              .doc(productId)
              .set({
            'petId': productId,
            'petName': _petName,
            'age': _petAge,
            'petGender': _petGender,
            'petBreed': _petBreed,
            'petImage': url,
            'petDescription': _petDescription,
            'userId': _uid,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          height: kBottomNavigationBarHeight * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorsConsts.white,
            border: const Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Material(
            child: InkWell(
              onTap: _trySubmit,
              splashColor: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator()))
                        : const Text('Upload',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                  ),
                  GradientIcon(
                    Icons.upload,
                    20,
                    LinearGradient(
                      colors: <Color>[
                        Colors.green,
                        Colors.yellow,
                        Colors.deepOrange,
                        Colors.orange,
                        Colors.yellow.shade800
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    key: const ValueKey('Title'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a Title';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Pet Name',
                                    ),
                                    onSaved: (value) {
                                      _petName = value!;
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  key: const ValueKey('Age'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Price is missed';
                                    }
                                    return null;
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    //  prefixIcon: Icon(Icons.mail),
                                    // suffixIcon: Text(
                                    //   '\n \n ₦',
                                    //   textAlign: TextAlign.start,
                                    // ),
                                  ),
                                  //obscureText: true,
                                  onSaved: (value) {
                                    _petAge = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          /* Image picker here ***********************************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                //  flex: 2,
                                child: this._pickedImage == null
                                    ? Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 200,
                                        width: 200,
                                        child: Container(
                                          height: 200,
                                          // width: 200,
                                          decoration: BoxDecoration(
                                            // borderRadius: BorderRadius.only(
                                            //   topLeft: const Radius.circular(40.0),
                                            // ),
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                          child: Image.file(
                                            this._pickedImage!,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _pickImageCamera,
                                      icon: const Icon(Icons.camera),
                                      label: const Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _pickImageGallery,
                                      icon: const Icon(Icons.image),
                                      label: const Text(
                                        'Gallery',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _removeImage,
                                      icon: const Icon(
                                        Icons.remove_circle_rounded,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        'Remove',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                              key: const ValueKey('Description'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'service description is required';
                                }
                                return null;
                              },
                              //controller: this._controller,
                              maxLines: 10,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                //  counterText: charLength.toString(),
                                labelText: 'Description',
                                hintText: 'Pet description',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _petDescription = value!;
                              },
                              onChanged: (text) {
                                // setState(() => charLength -= text.length);
                              }),
                          //    SizedBox(height: 10),
                          Padding(
                              padding: const EdgeInsets.only(right: 9),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                key: const ValueKey('Pet Breed'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Pet Breed is missed';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Pet Breed',
                                ),
                                onSaved: (value) {
                                  _petBreed = value!;
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text("Pet Gender"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: petGenderPicker(
                                    controller: _petGenderPickerScrollController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container petGenderPicker({
    final controller,
  }) {
    return Container(
      // width: 200,
      height: 80,
      child: CupertinoPicker(
        selectionOverlay: null,
        // squeeze: 1.5,
        onSelectedItemChanged: (int value) {
          setState(() {
            if (value == 0) {
              _petGender = 'male';
            } else if (value == 1) {
              _petGender = 'female';
            }
          });
        },
        itemExtent: 25,
        scrollController: controller,
        children: const [
          Text(
            "Female",
          ),
          Text(
            "Male",
          ),
        ],
        useMagnifier: true, diameterRatio: 1,
        magnification: 1.1,
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
