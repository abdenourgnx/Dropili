import 'dart:developer';

import 'package:dropili/Presentation/Nfc/bloc/nfc_bloc.dart';
import 'package:dropili/Presentation/Nfc/widgets/nfc_not_found_widget.dart';
import 'package:dropili/Presentation/Nfc/widgets/nfc_searching_widget.dart';
import 'package:dropili/Presentation/Nfc/widgets/nfc_tag_error_widget.dart';
import 'package:dropili/Presentation/Nfc/widgets/nfc_tag_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NfcScanWidget extends StatefulWidget {
  final String dataToTag;
  const NfcScanWidget({super.key, required this.dataToTag});

  @override
  State<NfcScanWidget> createState() => _NfcScanWidgetState();
}

class _NfcScanWidgetState extends State<NfcScanWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NfcBloc(widget.dataToTag),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: EdgeInsets.only(
            top: 30,
            right: 30,
            left: 30,
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: BlocListener<NfcBloc, NfcState>(
            listener: (context, state) async {
              if (state is NfcSearchingState) {
              } else if (state is NfcTagWrittenState) {
                await Future.delayed(Duration(seconds: 3));
                Navigator.pop(context, null);
              } else if (state is NfcWriteErrorState) {
                await Future.delayed(Duration(seconds: 3));
                Navigator.pop(context, null);
              } else if (state is NfcNotFoundState) {
                await Future.delayed(Duration(seconds: 3));
                Navigator.pop(context, null);
              }
            },
            child: BlocBuilder<NfcBloc, NfcState>(
              builder: (context, state) {
                if (state is NfcNotFoundState) {
                  return NoNfcFoundWidget();
                } else if (state is NfcSearchingState) {
                  return NfcSearchingWidget();
                } else if (state is NfcTagWrittenState) {
                  return NfcTagFoundWidget();
                } else if (state is NfcWriteErrorState) {
                  return NfcTagErrorWidget();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}