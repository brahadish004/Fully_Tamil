import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

/// Model class to hold PDF formatting options
class PdfFormatOptions {
  final double fontSize;
  final String textAlign;
  final double marginTop;
  final double sideMargin;
  final String fontColor;

  PdfFormatOptions({
    required this.fontSize,
    required this.textAlign,
    required this.marginTop,
    required this.sideMargin,
    required this.fontColor,
  });
}

/// PDF saver utility with formatting support
class PdfSaver {
  static Future<void> generateAndOpenPdf(
    BuildContext context,
    String content,
    PdfFormatOptions formatOptions,
  ) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath = tempDir.path;
      final String targetFileName = "temp_document";

      final String htmlContent =
          """
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <style>
            @font-face {
              font-family: 'NotoTamil';
              src: url('file:///android_asset/flutter_assets/assets/fonts/NotoSansTamil-Regular.ttf');
            }
            body {
              font-family: 'NotoTamil';
              font-size: ${formatOptions.fontSize}px;
              text-align: ${formatOptions.textAlign};
              margin-top: ${formatOptions.marginTop}px;
              margin-left: ${formatOptions.sideMargin}px;
              margin-right: ${formatOptions.sideMargin}px;
              color: ${formatOptions.fontColor};
            }
          </style>
        </head>
        <body>
          ${content.replaceAll('\n', '<br>')}
        </body>
      </html>
      """;

      final converter = FlutterNativeHtmlToPdf();
      final file = await converter.convertHtmlToPdf(
        html: htmlContent,
        targetDirectory: targetPath,
        targetName: targetFileName,
      );

      if (file != null) {
        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open PDF: ${result.message}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF. File is null.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating or opening PDF: $e')),
      );
    }
  }
}

/// Dialog to get PDF formatting options from user
Future<PdfFormatOptions?> showPdfOptionsDialog(BuildContext context) {
  double fontSize = 20;
  String align = 'left';
  double marginTop = 100;
  double sideMargin = 20;
  String fontColor = '#000000';

  final TextEditingController colorController = TextEditingController(
    text: fontColor,
  );

  return showDialog<PdfFormatOptions>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Set PDF Formatting Options'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Font Size: ${fontSize.toStringAsFixed(0)}'),
                  Slider(
                    value: fontSize,
                    min: 10,
                    max: 40,
                    divisions: 30,
                    label: fontSize.toStringAsFixed(0),
                    onChanged: (val) => setState(() => fontSize = val),
                  ),
                  SizedBox(height: 10),

                  Text('Text Align'),
                  DropdownButton<String>(
                    value: align,
                    items: ['left', 'center', 'right']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => align = val!),
                  ),
                  SizedBox(height: 10),

                  Text('Top Margin: ${marginTop.toStringAsFixed(0)} px'),
                  Slider(
                    value: marginTop,
                    min: 0,
                    max: 200,
                    divisions: 20,
                    label: marginTop.toStringAsFixed(0),
                    onChanged: (val) => setState(() => marginTop = val),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Side Margin (Left/Right): ${sideMargin.toStringAsFixed(0)} px',
                  ),
                  Slider(
                    value: sideMargin,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: sideMargin.toStringAsFixed(0),
                    onChanged: (val) => setState(() => sideMargin = val),
                  ),
                  SizedBox(height: 10),

                  Text('Font Color (Hex)'),
                  TextField(
                    controller: colorController,
                    decoration: InputDecoration(hintText: '#000000'),
                    maxLength: 7,
                    onChanged: (val) {
                      if (val.startsWith('#') && val.length == 7) {
                        fontColor = val;
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final isValidColor = RegExp(
                    r'^#([A-Fa-f0-9]{6})$',
                  ).hasMatch(fontColor);
                  if (!isValidColor) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid hex color')),
                    );
                    return;
                  }
                  Navigator.pop(
                    context,
                    PdfFormatOptions(
                      fontSize: fontSize,
                      textAlign: align,
                      marginTop: marginTop,
                      sideMargin: sideMargin,
                      fontColor: fontColor,
                    ),
                  );
                },
                child: Text('Generate PDF'),
              ),
            ],
          );
        },
      );
    },
  );
}
