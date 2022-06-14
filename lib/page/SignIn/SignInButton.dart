import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// The scale based on the height of the button
///
const _appleIconSizeScale = 28 / 44;

class SignInButton extends StatelessWidget {
  /// 출처: SignInWithAppleButton class
  const SignInButton({
    Key? key,
    required this.onPressed,
    this.height = 44,
    this.style = SignInButtonStyle.google,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.iconAlignment = IconAlignment.left,
  }) : super(key: key);

  final VoidCallback onPressed;
  final double height;
  final SignInButtonStyle style;
  final BorderRadius borderRadius;
  final IconAlignment iconAlignment;

  String get _text {
    switch (style) {
      case SignInButtonStyle.google:
        return "Sign in with Google";
        return "구글 로그인";

      case SignInButtonStyle.apple:
        return "Sign in with Apple";
        return "애플 로그인";

      case SignInButtonStyle.kakao:
        return "Sign in with Kakao";
        return "카카오 로그인";
    }
  }

  Color get _backgroundColor {
    switch (style) {
      case SignInButtonStyle.google:
        return Colors.white;
      case SignInButtonStyle.apple:
        return Colors.black;
      case SignInButtonStyle.kakao:
        return const Color(0xfffee500);
    }
  }

  Color get _contrastColor {
    switch (style) {
      case SignInButtonStyle.apple:
        return Colors.white;
      case SignInButtonStyle.google:
      case SignInButtonStyle.kakao:
        return Color(0xff191919);
    }
  }

  Widget get getIcon {
    final fontSize = height * 0.43;
    switch (style) {
      case SignInButtonStyle.google:
        return Container(
          // color: Colors.redAccent,
          width: _appleIconSizeScale * height + 2,
          height: _appleIconSizeScale * height + 2,
          padding: const EdgeInsets.only(
            bottom: 0,
          ),
          child: Center(
            child: SizedBox(
              width: fontSize,
              height: fontSize,
              child:
                  const Image(image: AssetImage("assets/icon/google_icon.png")),
            ),
          ),
        );

      case SignInButtonStyle.apple:
        return Container(
          // color: Colors.redAccent,
          width: _appleIconSizeScale * height,
          height: _appleIconSizeScale * height + 2,
          padding: EdgeInsets.only(
            bottom: (4 / 44) * height,
          ),
          child: Center(
            child: SizedBox(
              width: fontSize * (25 / 31),
              height: fontSize,
              child: CustomPaint(
                painter: AppleLogoPainter(
                  color: _contrastColor,
                ),
              ),
            ),
          ),
        );

      case SignInButtonStyle.kakao:
        return Container(
          // color: Colors.redAccent,
          width: _appleIconSizeScale * height + 2,
          height: _appleIconSizeScale * height + 2,
          padding: const EdgeInsets.only(
            bottom: 0,
          ),
          child: Center(
            child: SizedBox(
              width: fontSize,
              height: fontSize,
              child:
                  const Image(image: AssetImage("assets/icon/kakao_icon.png")),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = height * 0.43;

    final textWidget = Container(
      //color: Colors.greenAccent,
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: TextStyle(
          inherit: false,
          fontSize: fontSize,
          color: _contrastColor,
          // defaults styles aligned with https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/cupertino/text_theme.dart#L16
          fontFamily: '.SF Pro Text',
          letterSpacing: -0.41,
        ),
      ),
    );

    var children = <Widget>[];

    switch (iconAlignment) {
      case IconAlignment.center:
        children = [
          getIcon,
          Flexible(
            child: textWidget,
          ),
        ];
        break;
      case IconAlignment.left:
        children = [
          getIcon,
          Expanded(
            child: textWidget,
          ),
          // SizedBox(
          //   width: _appleIconSizeScale * height,
          // ),
        ];
        break;
    }

    return SizedBox(
      height: height,
      child: SizedBox.expand(
        child: CupertinoButton(
          borderRadius: borderRadius,
          padding: EdgeInsets.zero,
          color: _backgroundColor,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            height: height,
            child: Row(
              children: children,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

enum SignInButtonStyle {
  /// A black button with white text and white icon
  ///
  /// ![Black Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/black_button.png)
  google,

  /// A white button with black text and black icon
  ///
  /// ![White Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_button.png)
  apple,

  /// A white button which has a black outline
  ///
  /// ![White Outline Button](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/white_outlined_button.png)
  kakao,
}

/// This controls the alignment of the Apple Logo on the [SignInButton]
enum IconAlignment {
  /// The icon will be centered together with the text
  ///
  /// ![Center Icon Alignment](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/center_aligned_icon.png)
  center,

  /// The icon will be on the left side, while the text will be centered accordingly
  ///
  /// ![Left Icon Alignment](https://raw.githubusercontent.com/aboutyou/dart_packages/master/packages/sign_in_with_apple/test/sign_in_with_apple_button/goldens/left_aligned_icon.png)
  left,
}
