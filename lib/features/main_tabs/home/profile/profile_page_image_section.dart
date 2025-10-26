import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitpill/generated/l10n/l10n.dart';
import 'package:fitpill/features/main_tabs/home/profile/widgets/profile_avatar_image.dart';
import 'package:fitpill/features/main_tabs/home/profile/avatar_selection_page.dart';
import 'package:fitpill/features/main_tabs/home/profile/profile_provider.dart';
import 'package:fitpill/features/main_tabs/home/profile/user_profile_model.dart';
import 'package:fitpill/core/system/config/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePageImageSection extends ConsumerStatefulWidget {
  final UserProfileModel profile;

  const ProfilePageImageSection({required this.profile, Key? key})
      : super(key: key);

  @override
  ConsumerState<ProfilePageImageSection> createState() =>
      _ProfilePageImageSectionState();
}

class _ProfilePageImageSectionState
    extends ConsumerState<ProfilePageImageSection>
    with SingleTickerProviderStateMixin {
  bool _isUploading = false;
  late final TransformationController _transformationController;
  late final AnimationController _resetAnimationController;
  Animation<Matrix4>? _resetAnimation;

  bool get _isPremium => _currentProfile.hasActivePremium;

  UserProfileModel get _currentProfile => ref.read(profileProvider).maybeWhen(
        data: (profile) => profile,
        orElse: () => widget.profile,
      );

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _resetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        final animation = _resetAnimation;
        if (animation != null) {
          _transformationController.value = animation.value;
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _resetAnimation = null;
        }
      });
  }

  @override
  void dispose() {
    _resetAnimationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _openAvatarSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AvatarSelectionScreen(
          onAvatarSelected: (avatarName) async {
            await ref.read(profileProvider.notifier).selectAvatar(avatarName);
          },
        ),
      ),
    );
  }

  Future<void> _removeCurrentPhoto() async {
    final profile = _currentProfile;
    if ((profile.profileImage ?? '').isEmpty) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await ref.read(profileProvider.notifier).removeProfileImage();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.profilePhotoUpdated)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.profilePhotoUpdateFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _handleImageSource(ImageSource source) async {
    if (!_isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.profilePhotoPremiumOnly)),
      );
      return;
    }

    final hasPermission = await _requestPermission(source);
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.profilePhotoPermissionDenied)),
      );
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );

    if (pickedFile == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await ref
          .read(profileProvider.notifier)
          .uploadProfileImage(File(pickedFile.path));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.profilePhotoUpdated)),
      );
    } catch (e) {
      if (!mounted) return;
      final String message;
      if (e is FirebaseException && e.code == 'permission-denied') {
        message = S.of(context)!.profilePhotoPremiumOnly;
      } else {
        message = S.of(context)!.profilePhotoUpdateFailed;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      if (Platform.isIOS) {
        permission = Permission.photos;
      } else {
        final photosStatus = await Permission.photos.request();
        if (photosStatus.isGranted) {
          return true;
        }
        permission = Permission.storage;
      }
    }

    final status = await permission.request();
    return status.isGranted;
  }

  void _showFullImage(ImageProvider<Object> imageProvider) {
    _resetAnimationController.stop();
    _transformationController.value = Matrix4.identity();

    showGeneralDialog(
      context: context,
      barrierLabel: S.of(context)!.profile,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1,
              maxScale: 4,
              clipBehavior: Clip.none,
              onInteractionEnd: (_) => _resetZoom(),
              child: Hero(
                tag: 'profile-photo-hero',
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _resetZoom() {
    _resetAnimationController.stop();
    _resetAnimation = Matrix4Tween(
      begin: _transformationController.value.clone(),
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _resetAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _resetAnimationController.forward(from: 0);
  }

  void _showImageOptions() {
    final hasProfileImage = (_currentProfile.profileImage ?? '').isNotEmpty;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: ThemeHelper.getCardColor(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isPremium) ...[
                ListTile(
                  leading: const Icon(Icons.camera_alt,
                      color: Colors.blue, size: 28),
                  title: Text(
                    S.of(context)!.captureFromCamera,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleImageSource(ImageSource.camera);
                  },
                ),
                Divider(thickness: 1.2, height: 10, color: Colors.grey[300]),
                ListTile(
                  leading: const Icon(Icons.photo_library,
                      color: Colors.green, size: 28),
                  title: Text(
                    S.of(context)!.chooseFromGallery,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleImageSource(ImageSource.gallery);
                  },
                ),
                Divider(thickness: 1.2, height: 10, color: Colors.grey[300]),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, color: Colors.amber, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          S.of(context)!.profilePhotoPremiumOnly,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1.2, height: 10, color: Colors.grey[300]),
              ],
              if (hasProfileImage) ...[
                ListTile(
                  leading: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 28),
                  title: Text(
                    S.of(context)!.deleteImage,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _removeCurrentPhoto();
                  },
                ),
                Divider(thickness: 1.2, height: 10, color: Colors.grey[300]),
              ],
              ListTile(
                leading: const Icon(Icons.face_retouching_natural,
                    color: Colors.purple, size: 28),
                title: Text(
                  S.of(context)!.selectAvatar,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _openAvatarSelection();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).maybeWhen(
          data: (value) => value,
          orElse: () => widget.profile,
        );
    final avatar = profile.avatar;
    final profileImagePath = profile.profileImage;
    final imageProvider = _resolveImage(profileImagePath, avatar);

    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap:
                imageProvider != null ? () => _showFullImage(imageProvider) : null,
            child: Hero(
              tag: 'profile-photo-hero',
              child: ProfileAvatarImage(
                imagePath: profileImagePath,
                avatarName: avatar,
                size: 140,
                backgroundColor: ThemeHelper.getCardColor(context),
              ),
            ),
          ),
          if (_isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(70),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              onPressed: _isUploading ? null : _showImageOptions,
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _resolveImage(
      String? profileImagePath, String? avatar) {
    if (profileImagePath != null && profileImagePath.isNotEmpty) {
      if (profileImagePath.startsWith('http')) {
        return CachedNetworkImageProvider(profileImagePath);
      }
      final file = File(profileImagePath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    if (avatar != null && avatar.isNotEmpty) {
      return AssetImage('assets/avatars/$avatar.png');
    }

    return null;
  }
}
