import 'package:dona_do_santo/custom_code/widgets/components.dart'
    as components;
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class LayoutModel extends StatelessWidget {
  final List<Widget> children;
  final String label;

  const LayoutModel({
    super.key,
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    const List<String> assetList = [
      'assets/images/auth/bg_images/bg1.jpg',
      'assets/images/auth/bg_images/bg2.jpg',
      'assets/images/auth/bg_images/bg3.jpg',
      'assets/images/auth/bg_images/bg4.jpg',
    ];

    return Stack(
      children: [
        components.CustomCarrousel(
          imgList: assetList,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: components.AssetImage(
                      assetPath: 'assets/images/store_logo.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (label != "Resetar senha")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Icon(
                          Icons.person,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 40,
                        ),
                      ],
                    ),
                  ...children,
                ].divide(const SizedBox(height: 10)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
