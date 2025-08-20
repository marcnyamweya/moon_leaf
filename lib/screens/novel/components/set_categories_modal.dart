import 'package:flutter/material.dart';
import 'package:moon_leaf/database/novel_info.dart';

// Assuming you have these models and services defined elsewhere
// class Category {
//   final int id;
//   final String name;
  
//   Category({required this.id, required this.name});
// }

class SetCategoryModal extends StatefulWidget {
  final dynamic novelId; // Can be int or List<int>
  final int? followed;
  final VoidCallback? handleFollowNovel;
  final List<int> currentCategoryIds;
  final VoidCallback? onEditCategories;
  final VoidCallback onSuccess;
  final VoidCallback? onSuccessAsync;

  const SetCategoryModal({
    Key? key,
    required this.novelId,
    this.followed,
    this.handleFollowNovel,
    required this.currentCategoryIds,
    this.onEditCategories,
    required this.onSuccess,
    this.onSuccessAsync,
  }) : super(key: key);

  @override
  State<SetCategoryModal> createState() => _SetCategoryModalState();
}

class _SetCategoryModalState extends State<SetCategoryModal> {
  List<int> selectedCategories = [];
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.currentCategoryIds);
    _getCategories();
  }

  @override
  void didUpdateWidget(SetCategoryModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentCategoryIds != widget.currentCategoryIds) {
      setState(() {
        selectedCategories = List.from(widget.currentCategoryIds);
      });
    }
  }

  Future<void> _getCategories() async {
    try {
      // Replace with your actual database query
      final res = await getCategoriesFromDb();
      if (res.isNotEmpty) {
        res.removeAt(0); // Equivalent to res.shift() in JS
      }
      
      setState(() {
        categories = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleCategory(int categoryId) {
    setState(() {
      if (selectedCategories.contains(categoryId)) {
        selectedCategories.remove(categoryId);
      } else {
        selectedCategories.add(categoryId);
      }
    });
  }

  void _onCancel() {
    setState(() {
      selectedCategories = List.from(widget.currentCategoryIds);
    });
    Navigator.of(context).pop();
  }

  void _onOk() async {
    if (widget.novelId is List<int>) {
      // Handle multiple novel IDs
      await updateNovelCategoryByIds(widget.novelId as List<int>, selectedCategories);
    } else {
      if (widget.followed == null || widget.followed == 0) {
        widget.handleFollowNovel?.call();
      }
      await updateNovelCategoryById(widget.novelId as int, selectedCategories);
    }
    
    Navigator.of(context).pop();
    
    if (widget.onSuccessAsync != null) {
       widget.onSuccessAsync!();
    } else {
      widget.onSuccess();
    }
  }

  void _onEdit() {
    Navigator.of(context).pop();
    // Navigate to categories screen - replace with your navigation logic
    Navigator.of(context).pushNamed('/categories');
    widget.onEditCategories?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.75,
          minWidth: 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                getString('categories.setCategories'), // Replace with your localization
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Categories List
            Flexible(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categories.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            getString('categories.setModalEmptyMsg'), // Replace with your localization
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedCategories.contains(category.id);
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: CheckboxListTile(
                                value: isSelected,
                                onChanged: (value) => _toggleCategory(category.id),
                                title: Text(category.name),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            );
                          },
                        ),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _onEdit,
                    child: Text(getString('common.edit')), // Replace with your localization
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _onCancel,
                    child: Text(getString('common.cancel')), // Replace with your localization
                  ),
                  if (categories.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _onOk,
                      child: Text(getString('common.ok')), // Replace with your localization
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the modal
void showSetCategoryModal({
  required BuildContext context,
  required dynamic novelId,
  int? followed,
  VoidCallback? handleFollowNovel,
  required List<int> currentCategoryIds,
  VoidCallback? onEditCategories,
  required VoidCallback onSuccess,
  VoidCallback? onSuccessAsync,
}) {
  showDialog(
    context: context,
    builder: (context) => SetCategoryModal(
      novelId: novelId,
      followed: followed,
      handleFollowNovel: handleFollowNovel,
      currentCategoryIds: currentCategoryIds,
      onEditCategories: onEditCategories,
      onSuccess: onSuccess,
      onSuccessAsync: onSuccessAsync,
    ),
  );
}

// Placeholder functions - replace with your actual implementations
Future<List<Category>> getCategoriesFromDb() async {
  // Replace with your actual database query
  throw UnimplementedError('Implement getCategoriesFromDb');
}

Future<void> updateNovelCategoryById(int novelId, List<int> categoryIds) async {
  // Replace with your actual database update
  throw UnimplementedError('Implement updateNovelCategoryById');
}

Future<void> updateNovelCategoryByIds(List<int> novelIds, List<int> categoryIds) async {
  // Replace with your actual database update
  throw UnimplementedError('Implement updateNovelCategoryByIds');
}

String getString(String key) {
  // Replace with your actual localization implementation
  switch (key) {
    case 'categories.setCategories':
      return 'Set Categories';
    case 'categories.setModalEmptyMsg':
      return 'No categories available';
    case 'common.edit':
      return 'Edit';
    case 'common.cancel':
      return 'Cancel';
    case 'common.ok':
      return 'OK';
    default:
      return key;
  }
}