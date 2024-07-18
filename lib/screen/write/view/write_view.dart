import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_make_read/screen/screen.dart';
import 'package:qr_make_read/widget/widget.dart';

class WriteView extends StatefulWidget {
  const WriteView({super.key});

  @override
  State<WriteView> createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WriteCubit, WriteState>(
        builder: (context, state) {
          switch(state.status) {
            case WriteStatus.init:
              context.read<WriteCubit>().init();
              break;
            case WriteStatus.loading:
              break;
            case WriteStatus.success:
              break;
            case WriteStatus.error:
              break;
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text('Create QR Code', style: TextStyle(color: Colors.greenAccent),),
                    const SizedBox(width: 10.0,),
                    Container(color: const Color(0x5269F0AE), width: MediaQuery.of(context).size.width / 2, height: 1.0,)
                  ],
                ),
                Column(
                  children: [
                    TextFormField(
                      // onChanged: context.read<WriteCubit>().onChangeKeyboard,
                      controller: _textEditingController,
                      onSaved: (value) async {
                        await context.read<WriteCubit>().onMakeQRCode(_textEditingController.text);
                      },
                      decoration: InputDecoration(
                        hintText: 'enter your data',
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.8)
                        ),
                        suffixIcon: InkWell(
                            onTap: () async {
                              await context.read<WriteCubit>().onMakeQRCode(_textEditingController.text);
                            },
                            child: const Icon(Icons.arrow_forward_ios, color: Colors.greenAccent,)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent,
                                width: 2.0
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Colors.greenAccent,
                                width: 2.0
                            )
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.white
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: InkWell(
                        onTap: () async {
                          // QR 코드 복사 또는 저장
                          await context.read<WriteCubit>().exportQrImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.greenAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PrettyQrView.data(
                                  data: state.qrData,
                                  decoration: const PrettyQrDecoration(
                                      background: Colors.white,
                                      shape: PrettyQrRoundedSymbol(borderRadius: BorderRadius.all(Radius.circular(0.0)))
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50,),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.history, color: Colors.greenAccent,),
                              Text(' created qr code', style: TextStyle(color: Colors.greenAccent))
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
                                        await context.read<WriteCubit>().delete(index);
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
                )
              ],
            ),
          );
        }
    );
  }
}