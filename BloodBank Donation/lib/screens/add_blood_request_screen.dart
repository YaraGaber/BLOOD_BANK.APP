import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../data/lists/blood_banks.dart';
import '../data/medical_center.dart';
import '../utils/blood_types.dart';
import '../utils/tools.dart';
import '../utils/validators.dart';
import '../widgets/action_button.dart';
import '../widgets/medical_center_picker.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/blood_utils.dart'; // Import the blood_utils.dart file
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBloodRequestScreen extends StatefulWidget {
  static const route = 'add-request';
  const AddBloodRequestScreen({Key? key}) : super(key: key);

  @override
  _AddBloodRequestScreenState createState() => _AddBloodRequestScreenState();
}

class _AddBloodRequestScreenState extends State<AddBloodRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _noteController = TextEditingController();
  String? _contactNumber;
  PhoneNumber patientNumber = PhoneNumber(isoCode: 'JO');
  String _bloodType = 'A+';
  MedicalCenter? _medicalCenter;
  String initialCountry = 'JO';
  DateTime _requestDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _patientNameController.dispose();
    _contactNumberController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const elementsSpacer = SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Blood Request')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _patientNameField(),
                  elementsSpacer,
                  _contactNumberField(),
                  elementsSpacer,
                  _bloodTypeSelector(),
                  elementsSpacer,
                  _medicalCenterSelector(),
                  elementsSpacer,
                  _requestDatePicker(),
                  elementsSpacer,
                  _noteField(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ActionButton(
                      callback: _submit,
                      text: 'Submit',
                      isLoading: _isLoading, key: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit()  {
    debugPrint(_medicalCenter!.name);
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        final requests =
            FirebaseFirestore.instance.collection('blood_requests');
        requests.add({
          'uid': user!.uid,
          'submittedBy': user.displayName,
          'patientName': _patientNameController.text,
          'bloodType': _bloodType,
          'contactNumber': _contactNumber.toString(),
          'note': _noteController.text,
          'submittedAt': DateTime.now(),
          'requestDate': _requestDate,
          'isFulfilled': false,
          'medicalCenter': _medicalCenter!.toJson(),
        }).then((value){
          Fluttertoast.showToast(msg: 'Request successfully Submitted',backgroundColor: Colors.green);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
        });
        // await _resetFields();
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong. Please try again and the error is $e');
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _patientNameField() => TextFormField(
        controller: _patientNameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        validator: (v) => Validators.required(v!, 'Patient name'),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Patient Name',
        ),
      );

  Widget _contactNumberField() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.withOpacity(0.5))
    ),
    child: InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        // print(number.isoCode);
        _contactNumber = number.phoneNumber ;
        print(number.phoneNumber);
      },
      onFieldSubmitted: (finalNumber){
        print("saved success $finalNumber");
      },
      onInputValidated: (bool value) {
        print(value);
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      selectorTextStyle: const TextStyle(color: Colors.black),
      initialValue: patientNumber,
      textFieldController: _contactNumberController,
      formatInput: false,
      keyboardType:
      const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: InputBorder.none,
      onSaved: (PhoneNumber number) {
        debugPrint('On Saved: $number');
      },
    ),
  );

  Future<void> getPatientNumber(String phoneNumber) async {
    final PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'JO');

    setState(() {
      patientNumber = number;
    });
  }

  Widget _noteField() => TextFormField(
        controller: _noteController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        minLines: 3,
        maxLines: 5,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Notes (Optional)',
          alignLabelWithHint: true,
        ),
      );

  Widget _bloodTypeSelector() => DropdownButtonFormField<String>(
        value: _bloodType,
        onChanged: (v) => setState(() => _bloodType = v!),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Blood Type',
        ),
        items: BloodTypeUtils.bloodTypes
            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
            .toList(),
      );

  Widget _medicalCenterSelector()=> DropdownSearch<String>(
    popupProps: PopupProps.menu(
      showSelectedItems: true,
      disabledItemFn: (String s) => s.startsWith('I'),
    ),
    items: bloodBanks.map((item) => item.name).toList(),
    dropdownDecoratorProps: const DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: "Menu mode",
        hintText: "country in menu mode",
        border: OutlineInputBorder()
      ),
    ),
    onChanged: (val) async
    {
      await loopOnBloodBankToGetIndexForSelectedBank(val.toString());        // this method to loop on bloodBanks to get the index which user chosen to send medicalCenter model to fireStore with requested
    },
    selectedItem: bloodBanks.first.name,
  );

  // this method to loop on bloodBanks to get the index which user chosen to send medicalCenter model to fireStore with requested
  Future<void> loopOnBloodBankToGetIndexForSelectedBank(String val) async {
    for( int i=0; i < bloodBanks.length ; i++ )
    {
      if( bloodBanks[i].name == val )
      {
        setState(()
        {
          _medicalCenter = bloodBanks[i];
          print("the bank is .... $val");
        });
      }
    }
  }

  Widget _requestDatePicker() => GestureDetector(
        onTap: () async {
          final today = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: today,
            lastDate: today.add(const Duration(days: 365)),
          );
          if (picked != null) {
            setState(() => _requestDate = picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            key: ValueKey<DateTime>(DateTime.now()),
            initialValue: Tools.formatDate(_requestDate!),
            validator: (_) =>
                _requestDate == null ? '* Please select a date' : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Request date',
              helperText: 'The date on which you need the blood to be ready',
            ),
          ),
        ),
      );

}

// this for choosing from multi choices like hospitals or banks and so on
/*
Widget medicalCenterSelector() => GestureDetector(
        onTap: () async {
          final picked = await showModalBottomSheet<MedicalCenter>(
            context: context,
            builder: (_) => const MedicalCenterPicker(),
            isScrollControlled: true,
          );
          if (picked != null)
          {
            setState(() => _medicalCenter = picked);
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            key: ValueKey<String>(_medicalCenter?.name ?? 'none'),
            initialValue: _medicalCenter?.name,
            validator: (_) => _medicalCenter == null
                ? '* Please select a medical center'
                : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Medical Center',
            ),
          ),
        ),
      );
 */