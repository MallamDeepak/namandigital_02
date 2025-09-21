import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 50.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).primaryColor;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWanderingCubes(
            color: indicatorColor,
            size: size,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class SmallLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const SmallLoadingIndicator({
    super.key,
    this.color,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Theme.of(context).primaryColor,
      size: size,
    );
  }
}

class CircularLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  final double strokeWidth;

  const CircularLoadingIndicator({
    super.key,
    this.message,
    this.size = 40.0,
    this.color,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class PulseLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const PulseLoadingIndicator({
    super.key,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulse(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}

class DotsLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const DotsLoadingIndicator({
    super.key,
    this.color,
    this.size = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}

class WaveLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const WaveLoadingIndicator({
    super.key,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}

class RotatingLinesLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const RotatingLinesLoadingIndicator({
    super.key,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRotatingCircle(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}

class FadingCircleLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const FadingCircleLoadingIndicator({
    super.key,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}

class LoadMoreIndicator extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final String? loadingText;
  final String? loadMoreText;

  const LoadMoreIndicator({
    super.key,
    required this.isLoading,
    this.onLoadMore,
    this.loadingText = 'Loading more...',
    this.loadMoreText = 'Load More',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SmallLoadingIndicator(),
            const SizedBox(height: 8),
            Text(
              loadingText!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onLoadMore,
        child: Text(loadMoreText!),
      ),
    );
  }
}

class RefreshLoadingIndicator extends StatelessWidget {
  final bool isRefreshing;
  final String? message;

  const RefreshLoadingIndicator({
    super.key,
    required this.isRefreshing,
    this.message = 'Refreshing...',
  });

  @override
  Widget build(BuildContext context) {
    if (!isRefreshing) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SmallLoadingIndicator(),
          const SizedBox(width: 12),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final bool showOverlay;

  const FullScreenLoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.backgroundColor,
    this.showOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = LoadingIndicator(
      message: message,
      size: 60,
    );

    if (showOverlay) {
      return Container(
        color: backgroundColor ?? Colors.black.withOpacity(0.3),
        child: content,
      );
    }

    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: content,
    );
  }
}

class ImageLoadingPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ImageLoadingPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: SmallLoadingIndicator(),
      ),
    );
  }
}