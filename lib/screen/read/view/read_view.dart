import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_make_read/config/config.dart';

import 'package:qr_make_read/screen/screen.dart';
import 'package:qr_make_read/widget/custom_alert_dialog/custom_alert_dialog.dart';
import 'package:qr_make_read/widget/custom_list_element/custom_list_element.dart';

class ReadView extends StatefulWidget {
  const ReadView({super.key});

  @override
  State<ReadView> createState() => _ReadViewState();
}

class _ReadViewState extends State<ReadView> with WidgetsBindingObserver {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      controller?.stopCamera();
    } else {
      controller?.resumeCamera();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadCubit, ReadState>(
      builder: (context, state) {
        switch(state.status) {
          case ReadStatus.init:
            controller?.resumeCamera();
            context.read<ReadCubit>().init();
            break;
          case ReadStatus.readyToScan:
            break;
          case ReadStatus.error:
            // 에러 처리
            break;
          case ReadStatus.scanSuccess:
            controller?.stopCamera();
            break;
          case ReadStatus.loading:
            break;
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Text('Scan QR Code', style: TextStyle(color: Colors.greenAccent),),
                  const SizedBox(width: 10.0,),
                  Container(color: const Color(0x5269F0AE), width: MediaQuery.of(context).size.width / 2, height: 1.0,)
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 90,),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: QRView(
                    key: qrKey,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.greenAccent,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: MediaQuery.of(context).size.height / 3
                    ),
                    onQRViewCreated: (QRViewController controller) {
                      this.controller = controller;
                      controller.scannedDataStream.listen((scanData) async {
                        await context.read<ReadCubit>().onQRViewCreated(scanData, context);
                      });
                    }
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 90,),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.history, color: Colors.greenAccent,),
                        Text(' scanned qr code', style: TextStyle(color: Colors.greenAccent))
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.historyList?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: CustomListElement(
                                data: state.historyList?[index].data ?? "Invalid Data",
                                date: state.historyList?[index].createDate ?? DateTime.now(),
                                icon: const Icon(Icons.qr_code, color: Colors.greenAccent,),
                                onTap: () {
                                  CustomAlertDialog().showAlertDialog(
                                      context: context,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: PrettyQrView.data(
                                                    data: state.historyList?[index].data ?? "",
                                                    decoration: const PrettyQrDecoration(
                                                        background: Colors.white,
                                                        shape: PrettyQrRoundedSymbol(borderRadius: BorderRadius.all(Radius.circular(0.0)))
                                                    )
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              await context.read<ReadCubit>().exportQrImage();
                                            },
                                          ),
                                          const SizedBox(height: 10.0,),
                                          Text(state.historyList?[index].data ?? "", style: const TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () async {
                                                    context.read<ReadCubit>().copyText(state.historyList?[index].data ?? "");
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Copy', style: TextStyle(color: Colors.blueAccent),)
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Close', style: TextStyle(color: Colors.red),)
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.background,
                                  );
                                },
                                onDelete: () async {
                                  await context.read<ReadCubit>().delete(index);
                                }
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}