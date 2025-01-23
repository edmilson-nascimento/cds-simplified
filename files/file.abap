@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.sqlViewName: '/YGA/TT_DA'

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Tipo de Tecnologia/Dominio Ambiental'

@Metadata.ignorePropagatedAnnotations: true

define view /yga/dd_tt_da
  as select from /yga/tipo_tecnol

    inner join   afko
      on /yga/tipo_tecnol.aufnr = afko.aufnr

    inner join   afvc
      on afvc.aufpl = afko.aufpl

    inner join   afvu
      on  afvu.aufpl = afvc.aufpl
      and afvu.aplzl = afvc.aplzl

{
//key /yga/tipo_tecnol.aufnr            as order,
  key /yga/tipo_tecnol.aufnr,

      /yga/tipo_tecnol.vornr            as operation,
      /yga/tipo_tecnol.tipo_tecnologia,
      /yga/tipo_tecnol.tplnr            as equipment,

      afvu.usr02                        as dom_ambiental,
      afvu.usr03                        as per_dom_ambiental,
      /yga/tipo_tecnol.vegetation,
      radius,

      afko.aufpl,
      min(afvc.aplzl)                   as aplzl,
      afvu.usr01
}

group by /yga/tipo_tecnol.aufnr,
         /yga/tipo_tecnol.vornr,
         /yga/tipo_tecnol.tipo_tecnologia,
         /yga/tipo_tecnol.tplnr,
         afvu.usr02,
         afvu.usr03,
         /yga/tipo_tecnol.vegetation,
         radius,
         afko.aufpl,
         afvu.usr01