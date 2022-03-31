import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import '../tools/helper.dart';
import 'view.list.dart';

part 'model.g.dart';
part 'model.g.view.dart';


// **************************************************************************
//                          TABLA OBRA
// **************************************************************************

const tableObra = SqfEntityTable(
    tableName: 'obra',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: false,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('nombreRepresentanteOSC', DbType.text, isNotNull: false)
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA VIVIENDA
// **************************************************************************

const tableVivienda = SqfEntityTable(
    tableName: 'vivienda',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('aliasRenabap', DbType.text, isNotNull: false),
      SqfEntityField('viviendaId', DbType.text, isNotNull: false),
      SqfEntityField('metrosCuadrados', DbType.integer, isNotNull: false),
      SqfEntityField('ambientes', DbType.integer, isNotNull: false),
      SqfEntityField('directoACalle', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('servicioCloacas', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('servicioLuz', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('servicioAgua', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('servicioGas', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('servicioInternet', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('reubicados', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('titular', DbType.text, isNotNull: false),
      SqfEntityField('contactoJefeHogar', DbType.text, isNotNull: false),
      SqfEntityField('contactoReferencia', DbType.text, isNotNull: false),
      SqfEntityField('jefeHogarNombre', DbType.text, isNotNull: false),
      SqfEntityField('cantHabitantes', DbType.integer, isNotNull: false),
      SqfEntityField('habitantesAdultos', DbType.integer, isNotNull: false),
      SqfEntityField('habitantesMenores', DbType.integer, isNotNull: false),
      SqfEntityField('habitantesMayores', DbType.integer, isNotNull: false),
      SqfEntityField('duenosVivienda', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('preguntasPgas', DbType.bool, isNotNull: true, defaultValue: false),
      SqfEntityField('cuestionarioHabitabilidad', DbType.bool, isNotNull: true, defaultValue: false)
    ],
    formListSubTitleField: '');

const tableDocumentacionTecnica = SqfEntityTable(
    tableName: 'documentacionTecnica',
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('datos', DbType.blob, isNotNull: false),
      SqfEntityField('computo', DbType.blob, isNotNull: false),
      SqfEntityField('planosDeObra', DbType.blob, isNotNull: false),
      SqfEntityField('cuadrillaDeTrabajadores', DbType.blob, isNotNull: false),
      SqfEntityField('sintesisDiagnosticoDeViviendas', DbType.blob, isNotNull: false),
      SqfEntityField('certificadoAvanceObra', DbType.blob, isNotNull: false),
      SqfEntityField('planDeObra', DbType.blob, isNotNull: false),
      SqfEntityField('diagramaGantt', DbType.blob, isNotNull: false),
      SqfEntityFieldRelationship(
        parentTable: tableObra,
        fieldName: 'obraId',
        isNotNull: true,
        deleteRule: DeleteRule.SET_NULL,
      ),
      SqfEntityFieldRelationship(
          parentTable: tableVivienda,
          isPrimaryKeyField: true,
          fieldName: 'id',
          deleteRule: DeleteRule.CASCADE,
          relationType: RelationType.ONE_TO_ONE
      ),
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA UBICACION
// **************************************************************************

const tableUbicacion = SqfEntityTable(
    tableName: 'ubicacion',
    // declare fields
    fields: [
      SqfEntityField('region', DbType.text, isNotNull: false),
      SqfEntityField('provincia', DbType.text, isNotNull: false),
      SqfEntityField('localidad', DbType.text, isNotNull: false),
      SqfEntityField('barrio', DbType.text, isNotNull: false),
      SqfEntityField('direccion', DbType.text, isNotNull: false),
      SqfEntityField('planta', DbType.text, isNotNull: false),
      SqfEntityField('latitud', DbType.real, isNotNull: false),
      SqfEntityField('longitud', DbType.real, isNotNull: false),
      SqfEntityFieldRelationship(
          parentTable: tableVivienda,
          isPrimaryKeyField: true,
          fieldName: 'id',
          deleteRule: DeleteRule.CASCADE,
          relationType: RelationType.ONE_TO_ONE
      ),
    ],
    formListSubTitleField: '');
// **************************************************************************
//                          TABLA CERTIFICADO
// **************************************************************************

const tableCertificado = SqfEntityTable(
    tableName: 'certificado',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('monto', DbType.real, isNotNull: false),
      SqfEntityField('fecha', DbType.date, isNotNull: true),
      SqfEntityField('pdf', DbType.blob, isNotNull: false),
      SqfEntityField('cargadoServidor', DbType.bool, defaultValue: false),
      SqfEntityFieldRelationship(
          parentTable: tableObra,
          fieldName: 'obraId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: true
      )
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA VISITA
// **************************************************************************

const tableVisita = SqfEntityTable(
    tableName: 'visita',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('numVisita', DbType.integer, isNotNull: true),
      SqfEntityField('informeId', DbType.integer, isNotNull: false),
      SqfEntityField('fecha', DbType.date, defaultValue: 'DateTime.now()', minValue: '2021-01-01', maxValue: 'DateTime.now().add(Duration(days: 30))'),
      SqfEntityField('nombreRelevador', DbType.text, isNotNull: true),
      SqfEntityField('observaciones', DbType.text, isNotNull: false),
      SqfEntityField('visitaFinal', DbType.bool, defaultValue: false),
      SqfEntityField('cargadoServidor', DbType.bool, defaultValue: false),
      SqfEntityFieldRelationship(
          parentTable: tableObra,
          fieldName: 'obraId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: true
      ),
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA PREGUNTA VISITA
// **************************************************************************

const tablePreguntaVisita = SqfEntityTable(
    tableName: 'preguntaVisita',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: false,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('tipoRespuestaA', DbType.text, isNotNull: false),
      SqfEntityField('tipoRespuestaB', DbType.text, isNotNull: false),
      SqfEntityField('tipoRespuestaC', DbType.text, isNotNull: false),
      SqfEntityField('esTexto', DbType.bool, isNotNull: false, defaultValue: false),
      SqfEntityField('pregunta', DbType.text, isNotNull: true),
      SqfEntityField('cuestionarioHabitabilidad', DbType.bool, defaultValue: false),
      // En caso que la pregunta sea de las intervenciones
      SqfEntityField('etapaDeAvance', DbType.integer, defaultValue: 0),
      SqfEntityFieldRelationship(
          parentTable: tableIntervencion,
          fieldName: 'intervencionId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: false
      )
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA INTERVENCION
// **************************************************************************

const tableIntervencion = SqfEntityTable(
    tableName: 'intervencion',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('nombre', DbType.text, isNotNull: true),
      SqfEntityField('esPgas', DbType.bool, isNotNull: false, defaultValue: false),
      // SqfEntityFieldRelationship(
      //   parentTable: tableObra,
      //   deleteRule: DeleteRule.NO_ACTION,
      //   relationType: RelationType.MANY_TO_MANY,
      //   manyToManyTableName: 'obra_intervencion',
      // ),
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA OBRA_INTERVENCION
// **************************************************************************

const tableObraIntervencion = SqfEntityTable(
    tableName: 'obra_intervencion',
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('nroComponente', DbType.integer, isNotNull: true, isPrimaryKeyField: true),
      SqfEntityFieldRelationship(
          parentTable: tableIntervencion,
          fieldName: 'intervencionId',
          deleteRule: DeleteRule.CASCADE,
          isPrimaryKeyField: true,
          isNotNull: true
      ),
      SqfEntityFieldRelationship(
          parentTable: tableObra,
          fieldName: 'obraId',
          deleteRule: DeleteRule.CASCADE,
          isPrimaryKeyField: true,
          isNotNull: true
      ),
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA RESPUESTA VISITA
// **************************************************************************

const tableRespuestaVisita = SqfEntityTable(
    tableName: 'respuestaVisita',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('respuesta', DbType.text, isNotNull: true),
      SqfEntityField('puntaje', DbType.real, defaultValue: -1),
      SqfEntityField('pgas', DbType.bool, defaultValue: false),
      SqfEntityFieldRelationship(
          parentTable: tablePreguntaVisita,
          fieldName: 'preguntaVisitaId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: true
      ),
      SqfEntityField('nroComponente', DbType.integer),
      // Esta relacion es para poder almacenar las rtas del
      // cuestionario de condiciones de habitabilidad
      SqfEntityFieldRelationship(
          parentTable: tableVivienda,
          fieldName: 'viviendaId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: false
      ),
      SqfEntityFieldRelationship(
          parentTable: tableVisita,
          fieldName: 'visitaId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: false
      )
    ],
    formListSubTitleField: '');


// **************************************************************************
//                          TABLA FOTO VISITA
// **************************************************************************

const tableFotoVisita = SqfEntityTable(
    tableName: 'fotoVisita',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('imagen', DbType.blob, isNotNull: true),
      SqfEntityFieldRelationship(
          parentTable: tableVisita,
          fieldName: 'visitaId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: true
      ),
      SqfEntityFieldRelationship(
          parentTable: tableIntervencion,
          fieldName: 'intervencionId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: false
      ),
      SqfEntityField('nroComponente', DbType.integer),
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          TABLA FOTO VIVIENDA
// **************************************************************************

const tableFotoVivienda = SqfEntityTable(
    tableName: 'fotoVivienda',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    modelName: null,
    // declare fields
    fields: [
      SqfEntityField('imagen', DbType.blob, isNotNull: true),
      SqfEntityField('fotoPrincipal', DbType.bool, isNotNull: true),
      SqfEntityFieldRelationship(
          parentTable: tableVivienda,
          fieldName: 'viviendaId',
          deleteRule: DeleteRule.CASCADE,
          isNotNull: true
      )
    ],
    formListSubTitleField: '');

// **************************************************************************
//                          DEFINICION IDENTIDAD
// **************************************************************************

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

// **************************************************************************
//                          DEFINICION MODELO
// **************************************************************************


@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'MyDbModel',
    databaseName: 'proyecto-viviendas2021',
    password: null,
    databaseTables: [tableObra, tableVivienda, tableUbicacion, tableCertificado,
      tableVisita, tablePreguntaVisita, tableRespuestaVisita, tableIntervencion, tableFotoVisita, tableFotoVivienda, tableDocumentacionTecnica, tableObraIntervencion],
    formTables: [tableObra, tableVivienda, tableCertificado, tableVisita,
      tablePreguntaVisita, tableRespuestaVisita, tableIntervencion, tableFotoVisita, tableFotoVivienda],
    sequences: [seqIdentity],
    dbVersion: 1,
    bundledDatabasePath: null, //         'assets/sample.db'

    defaultColumns: [
      SqfEntityField('dateCreated', DbType.datetime,
          defaultValue: 'DateTime.now()'),
    ]);
