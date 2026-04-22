import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/ship.dart';
import '../theme/app_colors.dart';

class AddShipScreen extends StatefulWidget {
  const AddShipScreen({super.key});

  @override
  State<AddShipScreen> createState() => _AddShipScreenState();
}

class _AddShipScreenState extends State<AddShipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _classCtrl = TextEditingController();
  final _manufacturerCtrl = TextEditingController();
  final _crewCtrl = TextEditingController();
  final _hullCtrl = TextEditingController(text: '50');
  final _shieldsCtrl = TextEditingController(text: '50');
  final _speedCtrl = TextEditingController(text: '50');
  ShipRole _role = ShipRole.starfighter;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _classCtrl.dispose();
    _manufacturerCtrl.dispose();
    _crewCtrl.dispose();
    _hullCtrl.dispose();
    _shieldsCtrl.dispose();
    _speedCtrl.dispose();
    super.dispose();
  }

  // makes sure the field is not empty
  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  // checks that the number is between 0 and 100
  String? _statValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = int.tryParse(value.trim());
    if (n == null) return 'Enter a number';
    if (n < 0 || n > 100) return '0 - 100';
    return null;
  }

  String? _crewValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final n = int.tryParse(value.trim());
    if (n == null || n < 1) return 'At least 1';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // make a unique id from the current time
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final ship = Ship(
      id: id,
      name: _nameCtrl.text.trim(),
      shipClass: _classCtrl.text.trim(),
      manufacturer: _manufacturerCtrl.text.trim(),
      crew: int.parse(_crewCtrl.text.trim()),
      hull: int.parse(_hullCtrl.text.trim()),
      shields: int.parse(_shieldsCtrl.text.trim()),
      speed: int.parse(_speedCtrl.text.trim()),
      role: _role,
    );
    // send the new ship back to the hangar screen
    Navigator.pop(context, ship);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // smaller padding on phones, bigger on wide screens
    double horizontalPad = 40;
    if (width < 600) {
      horizontalPad = 20;
    }
    // on wide screens, two fields go side-by-side, otherwise stacked
    final isWide = width >= 700;

    // two fields: Class + Manufacturer
    final classField = TextFormField(
      controller: _classCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Class'),
      validator: _required,
    );
    final manufacturerField = TextFormField(
      controller: _manufacturerCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Manufacturer'),
      validator: _required,
    );

    // two fields: Hull + Shields
    final hullField = TextFormField(
      controller: _hullCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(labelText: 'Hull'),
      validator: _statValidator,
    );
    final shieldsField = TextFormField(
      controller: _shieldsCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(labelText: 'Shields'),
      validator: _statValidator,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('REGISTER SHIP')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPad, 8, horizontalPad, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionLabel('IDENTIFICATION'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Ship Name',
                    hintText: 'e.g. T-65 Starfighter',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 12),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: classField),
                      const SizedBox(width: 12),
                      Expanded(child: manufacturerField),
                    ],
                  )
                else
                  Column(
                    children: [
                      classField,
                      const SizedBox(height: 12),
                      manufacturerField,
                    ],
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ShipRole>(
                  initialValue: _role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  dropdownColor: AppColors.surface,
                  items: const [
                    DropdownMenuItem(
                      value: ShipRole.starfighter,
                      child: Text('Starfighter'),
                    ),
                    DropdownMenuItem(
                      value: ShipRole.freighter,
                      child: Text('Freighter'),
                    ),
                    DropdownMenuItem(
                      value: ShipRole.shuttle,
                      child: Text('Shuttle'),
                    ),
                    DropdownMenuItem(
                      value: ShipRole.capital,
                      child: Text('Capital'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _role = v);
                    }
                  },
                ),
                const SizedBox(height: 24),
                const _SectionLabel('SPECIFICATIONS'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _crewCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Crew Size'),
                  validator: _crewValidator,
                ),
                const SizedBox(height: 24),
                const _SectionLabel('COMBAT PROFILE (0 - 100)'),
                const SizedBox(height: 12),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: hullField),
                      const SizedBox(width: 12),
                      Expanded(child: shieldsField),
                    ],
                  )
                else
                  Column(
                    children: [
                      hullField,
                      const SizedBox(height: 12),
                      shieldsField,
                    ],
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _speedCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Speed'),
                  validator: _statValidator,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('REGISTER SHIP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
