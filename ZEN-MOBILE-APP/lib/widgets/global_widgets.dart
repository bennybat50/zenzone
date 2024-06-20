import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/PublicVar.dart';

class BackgroundText extends StatelessWidget {
  final text, fontSize;
  const BackgroundText({Key? key, this.text, this.fontSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 1.0,
            color: Colors.black45,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    );
  }
}

class FloatingTextButton extends StatelessWidget {
  final text, bgColor, textColor, onTap, icon, width;
  const FloatingTextButton(
      {Key? key,
      this.text,
      this.onTap,
      this.bgColor,
      this.textColor,
      this.icon,
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(100),
      shadowColor: Colors.grey[200],
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
              alignment: Alignment.center,
              color: bgColor ?? Color(PublicVar.primaryColor),
              height: 40,
              width: width ?? 120,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  text ?? "",
                  style: TextStyle(color: textColor ?? Colors.white),
                ),
                SizedBox(width: 8),
                Icon(
                  icon ?? Icons.add,
                  color: textColor ?? Colors.white,
                )
              ])),
        ),
      ),
    );
  }
}

class AppMenuBotton extends StatelessWidget {
  final onPressed;
  const AppMenuBotton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 40,
          width: 40,
          color: Colors.white,
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  final url;
  final size;
  const CircleImage({Key? key, this.size, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(size + 10.0),
        child: Container(
          height: double.parse("$size"),
          width: double.parse("$size"),
          child: GetImageProvider(
            url: url,
            placeHolder: PublicVar.defaultAppImage,
          ),
        ));
  }
}

class ShowFloatingLoader extends StatelessWidget {
  final text;
  const ShowFloatingLoader({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 28.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 160,
          color: Color(PublicVar.primaryColor),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: [
                ShowProcessingIndicator(
                  size: 20.0,
                ),
                Expanded(
                    child: Text(
                  text ?? "   Please wait...",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

FormDecorator({helper, hint, fillColor, labelText}) {
  return InputDecoration(
    border: InputBorder.none,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Color(PublicVar.primaryColor)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Colors.redAccent),
    ),
    fillColor: fillColor ?? Colors.grey[200],
    filled: true,
    helperText: helper,
    hintStyle: TextStyle(
      color: Colors.black54,
    ),
    hintText: hint,
    labelText: labelText ?? hint,
  );
}

class ButtonWidget extends StatelessWidget {
  final width,
      height,
      text,
      bgColor,
      txColor,
      radius,
      child,
      onPress,
      textIcon,
      border,
      fontSize,
      icon,
      iconColor,
      iconSize,
      loading;
  var addIconBG;
  ButtonWidget({
    Key? key,
    this.width,
    this.height,
    this.text,
    this.bgColor,
    this.txColor,
    this.radius,
    this.border,
    this.child,
    this.onPress,
    this.loading,
    this.textIcon,
    this.fontSize,
    this.addIconBG,
    this.icon,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (addIconBG == null) {
      addIconBG = true;
    }
    return Container(
      height: double.parse('${height ?? 0.0}'),
      width: double.parse('${width ?? 0.0}'),
      decoration: BoxDecoration(
          border: border ?? Border.all(width: 0, color: Colors.transparent),
          borderRadius: BorderRadius.circular(radius ?? 8)),
      child: child ??
          Material(
            color: bgColor,
            elevation: 0.5,
            shadowColor: Colors.grey[100],
            borderOnForeground: false,
            borderRadius: BorderRadius.circular(radius ?? 8),
            child: InkWell(
              onTap: onPress,
              splashColor: Colors.grey[200],
              borderRadius: BorderRadius.circular(radius ?? 8),
              child: icon == null
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Center(
                        child: loading ?? false
                            ? ShowProcessingIndicator()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        "$text",
                                        style: TextStyle(
                                            color: txColor,
                                            fontSize: fontSize ?? 16,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  textIcon != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              radius ?? 40),
                                          child: Container(
                                              height: 20,
                                              width: 20,
                                              color: addIconBG
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                textIcon,
                                                color: addIconBG
                                                    ? bgColor
                                                    : txColor,
                                                size: 16,
                                              )))
                                      : SizedBox()
                                ],
                              ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(radius ?? 40),
                      child: Container(
                          height: height,
                          width: width,
                          color: bgColor,
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: iconSize,
                          ))),
            ),
          ),
    );
  }
}

class DisplayMessage extends StatelessWidget {
  final asset, title, message, btnText, color;
  final onPress;
  final btnWidth;
  const DisplayMessage(
      {Key? key,
      this.asset,
      this.color,
      this.message,
      this.title,
      this.btnText,
      this.onPress,
      this.btnWidth})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceFont = deviceHeight * 0.01;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          asset == null
              ? SizedBox()
              : Image.asset(
                  asset,
                  height: 80,
                ),
          title == null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 14.0, right: 14.0, top: 14.0, bottom: 5),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        color: color ?? Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
          message == null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                      left: 14.0, right: 14.0, top: 5.0, bottom: 15),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 2.2 * deviceFont,
                        color: color ?? Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
          btnText == null
              ? SizedBox()
              : ButtonWidget(
                  onPress: onPress,
                  width: btnWidth ?? deviceWidth * 0.40,
                  height: 40.0,
                  fontSize: 16.0,
                  txColor: Colors.white,
                  bgColor: Color(PublicVar.primaryColor).withOpacity(0.7),
                  text: btnText,
                )
        ],
      ),
    );
  }
}

class BackBtn extends StatelessWidget {
  final onTap, titleDark, icon, iconSize;
  const BackBtn(
      {Key? key, this.onTap, this.titleDark, this.icon, this.iconSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.all(14),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: titleDark ? Colors.white : Colors.black,
              child: Icon(
                icon,
                color: titleDark ? Colors.black : Colors.white,
                size: iconSize ?? 25,
              ),
            )));
  }
}

class loadingProcess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: 50.0,
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ShowProcessingIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class GetImageProvider extends StatelessWidget {
  final url, placeHolder, height;
  const GetImageProvider({Key? key, this.url, this.placeHolder, this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: double.infinity,
      height: height,
      imageUrl: url ?? "",
      placeholderFadeInDuration: Duration(milliseconds: 10),
      placeholder: (context, url) => Image.asset(
        placeHolder,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
      errorWidget: (context, url, error) => Image.asset(
        placeHolder,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
      fit: BoxFit.cover,
    );
  }
}

class ShowProcessingIndicator extends StatelessWidget {
  final size;
  const ShowProcessingIndicator({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 20,
      width: size ?? 20,
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey[100],
        strokeWidth: 2.0,
        valueColor:
            AlwaysStoppedAnimation<Color>(Color(PublicVar.primaryColor)),
      ),
    );
  }
}

class ShowPageLoading extends StatelessWidget {
  var color;
  ShowPageLoading({super.key, this.color});
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceFont = deviceHeight * 0.01;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ShowProcessingIndicator(
              size: deviceHeight * 0.04,
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          Text(
            'One moment please...',
            style: TextStyle(
                fontSize: 2.2 * deviceFont,
                color: color != null ? color : Colors.white),
          )
        ],
      ),
    );
  }
}

class SmallResource extends StatelessWidget {
  var imageUrl, title, duration, colorsTheme, height, width, fillTitle, liked;
  Widget user;
  final onTap, onBookMark, isFree;
  SmallResource(
      {Key? key,
      required this.user,
      required this.onTap,
      required this.onBookMark,
      required this.isFree,
      this.colorsTheme,
      this.duration,
      this.fillTitle,
      this.title,
      this.height,
      this.liked,
      this.width,
      this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    fillTitle ??= false;
    liked ??= false;
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                          width: width ?? 130,
                          height: height ?? 90,
                          child: GetImageProvider(
                            url: imageUrl,
                            placeHolder: PublicVar.defaultAppImage,
                          )),
                    ),
                    fillTitle
                        ? SizedBox()
                        : Container(
                            width: width ?? 130,
                            height: height ?? 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.4)),
                          ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(100)),
                        child: isFree
                            ? Icon(
                                Icons.lock,
                                color: Colors.orange,
                                size: 15,
                              )
                            : Icon(
                                liked == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: liked ? Colors.red : Colors.white,
                                size: 15,
                              ),
                      ),
                    ),
                    fillTitle
                        ? SizedBox()
                        : Positioned.fill(
                            child: Container(
                                // height: 70,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                )),
                          )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fillTitle
                          ? Text(
                              title,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            )
                          : user,
                      Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: Text(
                          duration,
                          style: TextStyle(
                              fontSize: 10,
                              color: colorsTheme != null
                                  ? colorsTheme
                                  : Colors.grey[300],
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HostCard extends StatelessWidget {
  var imageUrl, name, bio, subScribers, background, color, width;
  final onTap, onBookMark;
  HostCard(
      {Key? key,
      this.imageUrl,
      required this.onTap,
      required this.onBookMark,
      this.name,
      this.color,
      this.width,
      this.bio,
      this.subScribers,
      this.background})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? 300,
        decoration: BoxDecoration(
            color: background ?? Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(
              height: 110,
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: GetImageProvider(
                  url: imageUrl,
                  placeHolder: PublicVar.defaultAppImage,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      style: TextStyle(
                          color: color ?? Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color ?? Colors.grey.shade200,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      subScribers ?? "540 Subscribers",
                      style: TextStyle(
                          color: color ?? Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class ResourceItem extends StatelessWidget {
  var resourceImage, interest, title, descp, background, liked;
  Widget user;
  final onTap, onBookMark, isFree;
  ResourceItem(
      {Key? key,
      required this.user,
      required this.onTap,
      required this.onBookMark,
      required this.isFree,
      this.resourceImage,
      this.interest,
      this.liked,
      this.title,
      this.background,
      this.descp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    liked ??= false;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
              color: background != null
                  ? background
                  : Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12.5)),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GetImageProvider(
                    url: resourceImage,
                    placeHolder: PublicVar.defaultAppImage,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          Text(
                            descp,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        user,
                        Container(
                          alignment: Alignment.center,
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(100)),
                          child: isFree
                              ? Icon(
                                  Icons.lock,
                                  color: Colors.orange,
                                  size: 15,
                                )
                              : Icon(
                                  liked == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: liked ? Colors.red : Colors.white,
                                  size: 15,
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GradientOutlineButton extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback _callback;
  final double _radius;

  GradientOutlineButton({
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required VoidCallback onPressed,
  })  : this._painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this._callback = onPressed,
        this._radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: Container(
            constraints: BoxConstraints(minWidth: 88, minHeight: 48),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required double strokeWidth,
      required double radius,
      required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

//
