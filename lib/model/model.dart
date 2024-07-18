import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableQrHistory = SqfEntityTable(
    tableName: 'qr_history',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField('data', DbType.text),
      SqfEntityField('createDate', DbType.datetime),
      SqfEntityField('type', DbType.bool), // true: scan / false: create
    ]
);

// Define the 'identity' constant as SqfEntitySequence.
const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);
// AES128 / SECRET KEY: QR_PIXEL_AES_SECRET_KEY / qrpixeldatabsepassword
const _password = 'xAW7ZcklbmkNLVIMHFdtEHiPoWPxENuvHKRnGLwd95E=';

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'QrPixelDB', // optional
  databaseName: 'qrPixel.db',
  password: _password, // You can set a password if you want to use crypted database
  // put defined tables into the tables list.
  databaseTables: [tableQrHistory],
  // put defined sequences into the sequences list.
  sequences: [seqIdentity],
  bundledDatabasePath:
  null // 'assets/sample.db' // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
);