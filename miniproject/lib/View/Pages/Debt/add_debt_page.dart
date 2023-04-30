import 'package:flutter/material.dart';
import 'package:miniproject/View/View-Model/debt_view_model.dart';
import 'package:miniproject/View/Widgets/buttons.dart';
import 'package:miniproject/View/Widgets/my_colors.dart';
import 'package:miniproject/View/Widgets/text_form_fields.dart';
import 'package:provider/provider.dart';

import '../Customer/customers_list_page.dart';

class AddDebtPage extends StatefulWidget {
  const AddDebtPage({super.key});

  static const routeName = '/addDebt';

  @override
  State<AddDebtPage> createState() => _AddDebtState();
}

class _AddDebtState extends State<AddDebtPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _utangController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final Buttons myButton = Buttons();
  final TextFormFields myTextFormField = TextFormFields();
  final MyColors myColors = MyColors();

  @override
  void dispose() {
    _utangController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DebtViewModel>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as AddDebtArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Utang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Atas nama',
                    style: TextStyle(color: myColors.subInfoColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    args.nama,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              myTextFormField.textFormField(
                enabled: true,
                textEditingController: _utangController,
                textInputType: TextInputType.number,
                textCapitalization: TextCapitalization.none,
                helperText: 'Ketikkan nominal utang yang diinginkan',
                hintText: 'Contoh: 10000',
                labelText: 'Utang',
                icon: Icons.attach_money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Utang tidak boleh kosong';
                  } else {
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'hanya boleh diisi angka';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              myTextFormField.textFormField(
                enabled: true,
                textEditingController: _deskripsiController,
                textInputType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                helperText: 'Ketikkan deskripsi utang (nama barang/transaksi)',
                hintText: 'Contoh: Rokok Gudang Gula',
                labelText: 'Deskripsi',
                icon: Icons.money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              myButton.primaryButton(
                context: context,
                onPressedEvent: () {
                  if (_formKey.currentState!.validate()) {
                    provider.addDebt(
                      args.idPelanggan,
                      _deskripsiController.text,
                      int.parse(_utangController.text),
                    );
                    if (context.mounted) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(CustomersListPage.routeName),
                      );
                    }
                  }
                },
                icon: Icons.add,
                label: 'Tambah Utang',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddDebtArguments {
  final int idPelanggan;
  final String nama;

  AddDebtArguments({required this.idPelanggan, required this.nama});
}