import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitpill/core/ui/widgets/app_schimmer.dart';
import 'package:flutter/material.dart';

class ProfileAvatarImage extends StatelessWidget {
  const ProfileAvatarImage({
    super.key,
    this.imagePath,
    this.avatarName,
    required this.size,
    required this.backgroundColor,
    this.iconColor,
  });

  final String? imagePath;
  final String? avatarName;
  final double size;
  final Color backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final path = imagePath ?? '';
    final avatar = avatarName ?? '';

    final isNetworkImage = path.startsWith('http');
    final hasLocalImage = !isNetworkImage && path.isNotEmpty;
    final file = hasLocalImage ? File(path) : null;
    final hasFileImage = file?.existsSync() ?? false;
    final hasAvatar = avatar.isNotEmpty;

    Widget child;
    if (isNetworkImage) {
      child = CachedNetworkImage(
        imageUrl: path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => _ProfileAvatarPlaceholder(size: size),
        errorWidget: (_, __, ___) =>
            _ProfileAvatarFallbackIcon(size: size, color: iconColor),
      );
    } else if (hasFileImage) {
      child = Image.file(
        file!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else if (hasAvatar) {
      child = Image.asset(
        'assets/avatars/$avatar.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else {
      child = _ProfileAvatarFallbackIcon(size: size, color: iconColor);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(child: child),
    );
  }
}

class _ProfileAvatarPlaceholder extends StatelessWidget {
  const _ProfileAvatarPlaceholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

class _ProfileAvatarFallbackIcon extends StatelessWidget {
  const _ProfileAvatarFallbackIcon({
    required this.size,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
