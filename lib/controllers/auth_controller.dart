import 'package:flutter/material.dart';
import 'package:money_manager/repository/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  String? name = '';

  Future login({required String name}) async {
    await AuthRepository.login(name: name);
  }

  Future<void> saveName() async {
    name = await AuthRepository().saveName();
    notifyListeners();
  }

  static Future checkSaved(BuildContext context) async {
    await AuthRepository.checkSaved(context);
  }

  Future resetApp() async {
    _nameController.clear();
    await AuthRepository.resetApp();
  }
}
