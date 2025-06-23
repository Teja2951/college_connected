import 'package:college_connectd/opputunities/oppurtunities_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_connectd/model/oppurtunities_model.dart';

class OpportunityFormScreen extends ConsumerStatefulWidget {
  final OpportunityModel? opportunity; // null for add, non-null for edit
  
  const OpportunityFormScreen({
    Key? key,
    this.opportunity,
  }) : super(key: key);

  @override
  ConsumerState<OpportunityFormScreen> createState() => _OpportunityFormScreenState();
}

class _OpportunityFormScreenState extends ConsumerState<OpportunityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _durationController;
  late final TextEditingController _applicationLinkController;
  late final TextEditingController _logoUrlController;
  late final TextEditingController _stipendController;
  late final TextEditingController _requirementsController;
  late final TextEditingController _skillsController;
  
  // Form state
  late OpportunityType _selectedType;
  late bool _isRemote;
  late bool _isActive;
  late DateTime _deadline;
  
  bool get _isEditing => widget.opportunity != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFormState();
  }

  void _initializeControllers() {
    final opp = widget.opportunity;
    
    _titleController = TextEditingController(text: opp?.title ?? '');
    _companyController = TextEditingController(text: opp?.company ?? '');
    _descriptionController = TextEditingController(text: opp?.description ?? '');
    _locationController = TextEditingController(text: opp?.location ?? '');
    _durationController = TextEditingController(text: opp?.duration ?? '');
    _applicationLinkController = TextEditingController(text: opp?.applicationLink ?? '');
    _logoUrlController = TextEditingController(text: opp?.logoUrl ?? '');
    _stipendController = TextEditingController(text: opp?.stipend ?? '');
    _requirementsController = TextEditingController(
      text: opp?.requirements.join(', ') ?? ''
    );
    _skillsController = TextEditingController(
      text: opp?.skills.join(', ') ?? ''
    );
  }

  void _initializeFormState() {
    final opp = widget.opportunity;
    
    _selectedType = opp?.type ?? OpportunityType.internship;
    _isRemote = opp?.isRemote ?? false;
    _isActive = opp?.isActive ?? true;
    _deadline = opp?.deadline ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _applicationLinkController.dispose();
    _logoUrlController.dispose();
    _stipendController.dispose();
    _requirementsController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  List<String> _parseCommaSeparatedString(String input) {
    return input
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(opportunityControllerProvider.notifier);
    
    final opportunityModel = OpportunityModel(
      id: widget.opportunity?.id ?? '',
      title: _titleController.text.trim(),
      company: _companyController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      duration: _durationController.text.trim(),
      requirements: _parseCommaSeparatedString(_requirementsController.text),
      skills: _parseCommaSeparatedString(_skillsController.text),
      applicationLink: _applicationLinkController.text.trim(),
      deadline: _deadline,
      postedDate: widget.opportunity?.postedDate ?? DateTime.now(),
      type: _selectedType,
      logoUrl: _logoUrlController.text.trim().isEmpty ? null : _logoUrlController.text.trim(),
      stipend: _stipendController.text.trim().isEmpty ? null : _stipendController.text.trim(),
      isRemote: _isRemote,
      isActive: _isActive,
    );

    bool success;
    if (_isEditing) {
      success = await controller.updateOpportunity(opportunityModel);
    } else {
      success = await controller.addOpportunity(opportunityModel);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing 
            ? 'Opportunity updated successfully!' 
            : 'Opportunity added successfully!'
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing 
            ? 'Failed to update opportunity' 
            : 'Failed to add opportunity'
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Opportunity' : 'Add Opportunity'),
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Company is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Type and Location Section
              _buildSectionHeader('Type & Location'),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<OpportunityType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Opportunity Type *',
                  border: OutlineInputBorder(),
                ),
                items: OpportunityType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Remote Work'),
                subtitle: const Text('Is this a remote opportunity?'),
                value: _isRemote,
                onChanged: (value) {
                  setState(() {
                    _isRemote = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Duration and Deadline Section
              _buildSectionHeader('Duration & Timeline'),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration *',
                  hintText: 'e.g., 3 months, 6 weeks',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Duration is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              InkWell(
                onTap: _selectDeadline,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Application Deadline *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Requirements and Skills Section
              _buildSectionHeader('Requirements & Skills'),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Requirements *',
                  hintText: 'Separate multiple requirements with commas',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Requirements are required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills *',
                  hintText: 'Separate multiple skills with commas',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Skills are required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Application and Additional Info Section
              _buildSectionHeader('Application & Additional Info'),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _applicationLinkController,
                decoration: const InputDecoration(
                  labelText: 'Application Link *',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Application link is required';
                  }
                  if (!Uri.tryParse(value)!.hasAbsolutePath == true) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _logoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Company Logo URL',
                  hintText: 'https://... (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && 
                      !Uri.tryParse(value)!.hasAbsolutePath == true) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _stipendController,
                decoration: const InputDecoration(
                  labelText: 'Stipend',
                  hintText: 'e.g., ₹15,000/month (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: const Text('Active'),
                subtitle: const Text('Is this opportunity currently active?'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              
              // Submit Button
              ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _isEditing ? 'Update Opportunity' : 'Add Opportunity',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}