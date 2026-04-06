import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wasel/core/utils/app_colors.dart';
import 'package:wasel/core/utils/app_styles.dart';
import 'package:wasel/features/auth/data/models/auth_model.dart';
import 'package:wasel/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel/features/profile/presentation/manager/profile_state.dart';

class AddEditAddressScreen extends StatefulWidget {
  final SavedAddress? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _labelController;
  late TextEditingController _governorateController;
  late TextEditingController _cityController;
  late TextEditingController _streetController;
  late TextEditingController _buildingController;
  late TextEditingController _floorController;
  late TextEditingController _doorController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    _labelController = TextEditingController(text: addr?.label ?? '');
    _governorateController = TextEditingController(
      text: addr?.address.governorate ?? '',
    );
    _cityController = TextEditingController(text: addr?.address.city ?? '');
    _streetController = TextEditingController(text: addr?.address.street ?? '');
    _buildingController = TextEditingController(
      text: addr?.address.building ?? '',
    );
    _floorController = TextEditingController(text: addr?.address.floor ?? '');
    _doorController = TextEditingController(text: addr?.address.door ?? '');
    _isDefault = addr?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _governorateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _doorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final body = {
        "label": _labelController.text,
        "location": {
          "type": "Point",
          "coordinates": [
            31.2357116,
            30.0444196,
          ], // Mock coordinates or use current location
        },
        "address": {
          "governorate": _governorateController.text,
          "city": _cityController.text,
          "street": _streetController.text,
          "building": _buildingController.text,
          "floor": _floorController.text,
          "door": _doorController.text,
        },
        "isDefault": _isDefault,
      };

      if (widget.address != null) {
        context.read<ProfileCubit>().editAddress(widget.address!.id!, body);
      } else {
        context.read<ProfileCubit>().addAddress(body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.address != null
                ? translate('edit_address')
                : translate('add_new_address'),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  _labelController,
                  translate('label'),
                  isRequired: true,
                ),
                _buildTextField(
                  _governorateController,
                  translate('governorate'),
                  isRequired: true,
                ),
                _buildTextField(
                  _cityController,
                  translate('city'),
                  isRequired: true,
                ),
                _buildTextField(
                  _streetController,
                  translate('street'),
                  isRequired: true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        _buildingController,
                        translate('building'),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildTextField(
                        _floorController,
                        translate('floor'),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildTextField(
                        _doorController,
                        translate('door'),
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: Text(translate('set_as_default')),
                  value: _isDefault,
                  onChanged: (val) {
                    setState(() {
                      _isDefault = val;
                    });
                  },
                ),
                SizedBox(height: 24.h),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileUpdating) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          translate('save'),
                          style: AppStyles.textstyle16.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        validator: isRequired
            ? (value) => value == null || value.isEmpty
                  ? '$label ${translate('required')}'
                  : null
            : null,
      ),
    );
  }
}
