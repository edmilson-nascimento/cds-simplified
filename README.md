# Core Data Services - Simplified #

[![N|Solid](https://wiki.scn.sap.com/wiki/download/attachments/1710/ABAP%20Development.png?version=1&modificationDate=1446673897000&api=v2)](https://www.sap.com/brazil/developer.html)

Baseado em um post de duas partes ([ABAP CDS VIEWS simplified – PART 1](https://blogs.sap.com/2020/02/17/abap-cds-views-simplified-part-1/) e [ABAP CDS VIEWS simplified – PART 2](https://blogs.sap.com/2020/02/27/abap-cds-views-simplified-part-2/)) do [Blog SCN](https://blogs.sap.com/) que aborda o termo de `CDS - Core Data Service`.

## Necessidade ##
Criar um `Data Definition` do tipo `Define View`. Reforço que essa utilização é feita para **ABAP CDS** que term algumas sintaxes diferentes de **Open SQL** como a propria SAP ja coloca diferente em sua [documentaçāo de algumas sintaxes](https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-us/abensql_functions_string.htm). Esse `ABAP CDS` ser consumido por um programa ABAP.

## Tecnologia adotada ##
Utilização de `ABAP CDS` com a tabela `SPFLI`. O desenvolvimento foi criado no [Eclipse 2019-12 (4.14)](https://www.eclipse.org/downloads/packages/release/2019-12/r) conforme recomendado para [ABAP Development Tools](https://tools.hana.ondemand.com/#abap).

## Solução ##

### Parte 01 ###
Na primeira parte, foi criado apenas um `ABAP CDS` mais simples, acessando a tabela `SPFLI`, conforme abaixo.

```abap
@AbapCatalog.sqlViewName: 'ZDBVW_SPFLI'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View test'
define view ZABAP_CDS_VIEW_001 as select from spfli {
    *
}
```
E o código acima traz como resultado os dados da imagem abaixo.

![alt text](https://i.imgur.com/T5Idgie.png "Resultados CDS Parte 01")

### Parte 02 ###
Na segunda parte, foram feitas mais implementações como paramentros de filtros e etc.


```sql

@AbapCatalog.sqlViewName: 'ZSQL_ZFLIGHT1'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'flights'
define view zflight_02 

/* parametro de filtro */
with parameters
  p_carrid : abap.char( 3 ),
  p_mandt  : abap.clnt(3)

/* campos que serao exibidos */
as select from spfli {
  mandt,
  carrid,
  cityfrom,
  cityto,
  fltime as duration_min,

/* nova campo (concatenado) */
  concat(cityfrom, cityto) as test1,

/* novo campo (concatenado com espaço) 
  concat_with_space(cityfrom, cityto, 3 ) as test2, */
  
/* novo campo (concatenado com line) */
  concat(cityfrom, concat( ' - ', cityto))  as test2,

/* novo campo (com valor condicional) */
case 
  when fltime < 100 then 'Short'
  when fltime < 300 then 'Medium'
  else 'Long'
end as flight_duration,
fltime*60 as duration_sec   

}


/* Condicoes para selecao (filtro)

where carrid = :p_carrid
  and mandt  = $parameters.p_mandt;
*/  
  
where carrid = :p_carrid
  and mandt  = :p_mandt;

```

Na Parte 02, uma das coisas interessante de se utulizar o parametro, é que pode ser executado direto do _Eclipse_ com o filtro que deseja informar, como mostra na imagem abaixo os paramentros e tambem o resultado.

![alt text](https://i.imgur.com/moQFFuf.png "Tela de parametros Parte 02")

![alt text](https://i.imgur.com/tWsudsi.png "Resultado Parte 02")
