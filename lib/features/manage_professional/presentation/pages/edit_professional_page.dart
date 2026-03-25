import 'package:cardio_flutter/core/input_validators/cpf_input_validator.dart';
import 'package:cardio_flutter/core/utils/converter.dart';
import 'package:cardio_flutter/core/utils/multimasked_text_controller.dart';
import 'package:cardio_flutter/core/widgets/button.dart';
import 'package:cardio_flutter/core/widgets/custom_text_form_field.dart';
import 'package:cardio_flutter/core/widgets/loading_widget.dart';
import 'package:cardio_flutter/features/auth/domain/entities/professional.dart';
import 'package:cardio_flutter/features/auth/presentation/pages/basePage.dart';
import 'package:flutter/material.dart';
import 'package:cardio_flutter/resources/dimensions.dart';
import 'package:cardio_flutter/resources/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 1. O pacote mudou para another_flushbar (ou use ScaffoldMessenger)
// import 'package:another_flushbar/flushbar.dart'; 
import 'package:cardio_flutter/features/manage_professional/presentation/bloc/manage_professional_bloc.dart';

class EditProfessionalPage extends StatefulWidget {
  final Professional professional;

  // 2. Uso do required nativo e super.key
  const EditProfessionalPage({super.key, required this.professional});

  @override
  _EditProfessionalPageState createState() => _EditProfessionalPageState();
}

class _EditProfessionalPageState extends State<EditProfessionalPage> {
  static const String LABEL_NAME = "LABEL_NAME";
  static const String LABEL_CPF = "LABEL_CPF";
  static const String LABEL_REGIONAL_REGISTER = "LABEL_REGIONAL_REGISTER";
  static const String LABEL_EXPERTISE = "LABEL_EXPERTISE";

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 3. Uso do late para controladores
  late TextEditingController _cpfController;
  late TextEditingController _nameController;
  late TextEditingController _regionalRegisterController;
  late TextEditingController _expertiseController;

  @override
  void initState() {
    super.initState();

    // 4. Correção dos nomes dos parâmetros (Secondary com 'o') e Null Safety no callback
    _cpfController = MultimaskedTextController(
      maskDefault: "", // maskDefault não pode ser null agora
      maskSecondary: "xxx.xxx.xxx-xx",
      onlyDigitsDefault: false,
      onlyDigitsSecondary: true,
      changeMask: (String? text) {
        return (text != null &&
            text.isNotEmpty &&
            int.tryParse(text.substring(0, 1)) != null);
      },
    ).maskedTextFieldController;

    _formData[LABEL_CPF] = Converter.convertStringToMaskedString(
        value: widget.professional.cpf, mask: 'xxx.xxx.xxx-xx');
    _formData[LABEL_NAME] = widget.professional.name;
    _formData[LABEL_EXPERTISE] = widget.professional.expertise;
    _formData[LABEL_REGIONAL_REGISTER] = widget.professional.regionalRecord;
    
    _cpfController.text = _formData[LABEL_CPF] ?? "";
    _nameController = TextEditingController(text: _formData[LABEL_NAME]);
    _regionalRegisterController = TextEditingController(text: _formData[LABEL_REGIONAL_REGISTER]);
    _expertiseController = TextEditingController(text: _formData[LABEL_EXPERTISE]);
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _regionalRegisterController.dispose();
    _expertiseController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    BlocProvider.of<ManageProfessionalBloc>(context).add(
      EditProfessionalEvent(
        professional: Professional(
          id: widget.professional.id,
          cpf: _formData[LABEL_CPF],
          name: _formData[LABEL_NAME],
          expertise: _formData[LABEL_EXPERTISE],
          regionalRecord: _formData[LABEL_REGIONAL_REGISTER],
          email: widget.professional.email, // 5. Campo email agora é obrigatório
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BasePage(
        signOutButton: false,
        backgroundColor: const Color(0xffc9fffd),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 15)),
              CustomTextFormField(
                textEditingController: _nameController,
                isRequired: true,
                hintText: Strings.name_hint,
                title: Strings.name_title,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => setState(() => _formData[LABEL_NAME] = value),
              ),
              CustomTextFormField(
                textEditingController: _cpfController,
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: CpfInputValidator(),
                hintText: Strings.cpf_hint,
                title: Strings.cpf_title,
                onChanged: (value) => setState(() => _formData[LABEL_CPF] = value),
              ),
              CustomTextFormField(
                textEditingController: _regionalRegisterController,
                isRequired: true,
                hintText: "",
                title: Strings.register,
                onChanged: (value) => setState(() => _formData[LABEL_REGIONAL_REGISTER] = value),
              ),
              CustomTextFormField(
                textEditingController: _expertiseController,
                isRequired: true,
                hintText: "",
                title: Strings.specialty,
                onChanged: (value) => setState(() => _formData[LABEL_EXPERTISE] = value),
              ),
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
              Button(
                onTap: _submitForm,
                title: Strings.edit_patient_done,
              ),
              SizedBox(height: Dimensions.getConvertedHeightSize(context, 20)),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageProfessionalBloc, ManageProfessionalState>(
      listener: (context, state) {
        if (state is Error) {
          // 6. Recomendação: Use ScaffoldMessenger se o Flushbar estiver dando erro de import
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is Loaded) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ManageProfessionalBloc, ManageProfessionalState>(
        builder: (context, state) {
          if (state is Loading) {
            return LoadingWidget(_buildForm(context));
          } else {
            return _buildForm(context);
          }
        },
      ),
    );
  }
}