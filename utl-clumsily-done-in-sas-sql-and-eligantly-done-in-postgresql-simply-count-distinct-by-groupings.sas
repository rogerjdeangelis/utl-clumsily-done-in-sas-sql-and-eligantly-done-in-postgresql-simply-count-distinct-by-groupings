%let pgm=utl-clumsily-done-in-sas-sql-and-eligantly-done-in-postgresql-simply-count-distinct-by-groupings;

%stop_submission;

Clumsily done in sas sql and eligantly done in postgresql simply count distinct by groupings

Simple problem count distinct values by seveal groupings


SOAPBOX ON

  SQL'grouping set's would be a nice addition to proc sql.
  Also 'Group_concat'
  and all those widows extensions

SOAPBOX OFF

TWO SOLUTIONS

    1 r group settings (single pass)
    2 sas 8 unions and a transpose

github
https://tinyurl.com/482ww74r
https://github.com/rogerjdeangelis/utl-clumsily-done-in-sas-sql-and-eligantly-done-in-postgresql-simply-count-distinct-by-groupings

Related to
https://tinyurl.com/4d2tn7tz
https://communities.sas.com/t5/SAS-Programming/Adding-Distinct-Totals-to-Proc-Tabulate/m-p/967731

PROBLEM postgresql (note sas and sqlite do not support by 'grouping sets' )

 select
     typ
     ,yr
     ,month
     ,group_id
     ,count(distinct ida) as a
     ,count(distinct idb) as b
     ,count(distinct idc) as c
 from have
 group by grouping sets (
     (typ, yr, month, group_id)
    ,(typ, yr, month)
    ,(typ, yr, group_id)
    ,(typ, yr)

LETS MANUALLY COUNT DISTINCT IDA FOR  type=A and years 2020 & 2021

                  IDA COUNT
 TYPE   YR   IDA  DISTINCT

   A   2020  179   1
   A   2020  183   2
   A   2020  184
   A   2020  184
   A   2020  184
   A   2020  184   3
   A   2020  185
   A   2020  185   4
   A   2020  186
   A   2020  186   5
   A   2020  187
   A   2020  187   6
   A   2020  190   7
   A   2020  191   8
   A   2020  193   9
   A   2020  196  10
   A   2020  421  11
   A   2020  428  12
   A   2020  535  13 13

   A   2021  187
   A   2021  187   1
   A   2021  189   2
   A   2021  191   3
   A   2021  196   4
   A   2021  197
   A   2021  197   5
   A   2021  425   6
   A   2021  536   7
   A   2021  676   8  8

/**************************************************************************************************************************/
/* INPUT                                  | PROCESS                                       |  OUTPUT                       */
/* =====                                  | =======                                       |                               */
/* sd1.have                               | 1 R GROUP SETTIMGS (SINGLE PASS)              |  > print(df)      group       */
/*               group                    | ================================              | typ   yr month  id  a   b  c  */
/* typ  yr month id ida idb idc           |                                               |  A 2020   Apr    1  2   2  2  */
/*                                        | %utl_rbeginx;                                 |  A 2020   Apr <NA>  2   2  2  */
/*  A  2020 Mar   2 428 408 2 1           | parmcards4;                                   |  A 2020   Aug    1  1   1  1  */
/*  A  2021 Feb   2 196 176 2 2           | library(RPostgres)                            |  A 2020   Aug <NA>  1   1  1  */
/*  A  2023 Oct   2 423 403 2 3           | library(DBI)                                  |  A 2020   Dec    1  1   1  1  */
/*  A  2021 Nov   2 191 171 2 4           | library(haven)                                |  A 2020   Dec <NA>  1   1  1  */
/*  A  2020 Sep   1 186 166 1 5           | source("c:/oto/fn_tosas9x.R");                |  A 2020   Feb    1  3   3  3  */
/*  A  2020 Feb   1 186 166 1 6           | have<-read_sas("d:/sd1/have.sas7bdat")        |  A 2020   Feb <NA>  3   3  3  */
/*  A  2020 Jan   1 421 401 1 6           | have                                          |  A 2020   Jan    1  2   2  2  */
/*  A  2021 Nov   1 536 516 1 6           |                                               |  A 2020   Jan <NA>  2   2  2  */
/*  A  2021 Jan   1 197 177 1 6           | con <- dbConnect(RPostgres::Postgres(),       |  A 2020  July    1  1   1  1  */
/*  A  2020 May   2 184 164 2 6           |    dbname = "postgres",                       |  A 2020  July <NA>  1   1  1  */
/*  A  2020 July  1 190 170 1 11          |    host = "localhost",                        |  A 2020  June    2  1   1  1  */
/*  A  2020 Aug   1 183 163 1 12          |    port = 5432,                               |  A 2020  June <NA>  1   1  1  */
/*  A  2020 Feb   1 185 165 1 13          |    user = "postgres")                         |  A 2020   Mar    1  2   2  2  */
/*  A  2020 Apr   1 193 173 1 14          |                                               |  A 2020   Mar    2  1   1  1  */
/*  A  2020 Nov   1 187 167 1 15          | dbWriteTable(                                 |  A 2020   Mar <NA>  3   3  3  */
/*  A  2021 Aug   1 189 169 1 16          |   con                                         |  A 2020   May    2  2   2  3  */
/*  A  2020 Dec   1 184 164 1 17          |  ,"have"                                      |  A 2020   May <NA>  2   2  3  */
/*  A  2020 May   2 184 164 2 18          |  ,have                                        |  A 2020   Nov    1  1   1  1  */
/*  A  2020 June  2 184 164 2 18          |  ,row.names = FALSE                           |  A 2020   Nov <NA>  1   1  1  */
/*  A  2021 Nov   1 187 167 1 18          |  ,overwrite = TRUE)                           |  A 2020   Sep    1  1   1  1  */
/*  A  2020 Mar   1 191 171 1 18          | have                                          |  A 2020   Sep <NA>  1   1  1  */
/*  A  2020 Apr   1 535 515 1 18          | query <- "                                    |                               */
/*  A  2020 Feb   1 179 159 1 23          |     select                                    |  A 2020  <NA> <NA> 13* 13 14 **/
/*  A  2020 May   2 187 167 2 24          |         typ                                   |                               */
/*  A  2021 July  1 676 656 1 25          |         ,yr                                   |  A 2021   Aug    1  1   1  1  */
/*  A  2021 Feb   1 187 167 1 26          |         ,month                                |  A 2021   Aug <NA>  1   1  1  */
/*  A  2020 Mar   1 196 176 1 27          |         ,group_id                             |  A 2021   Dec    1  1   1  1  */
/*  A  2021 July  1 197 177 1 30          |         ,1.0*count(distinct ida) as a         |  A 2021   Dec <NA>  1   1  1  */
/*  A  2021 Dec   1 425 405 1 30          |         ,1.0*count(distinct idb) as b         |  A 2021   Feb    1  1   1  1  */
/*  A  2020 Jan   1 185 165 1 30          |         ,1.0*count(distinct idc) as c         |  A 2021   Feb    2  1   1  1  */
/*                                        |     from have                                 |  A 2021   Feb <NA>  2   2  2  */
/* options validvarname=v7;               |     group by grouping sets (                  |  A 2021   Jan    1  1   1  1  */
/* libname sd1 "d:/sd1";                  |         (typ, yr, month, group_id)            |  A 2021   Jan <NA>  1   1  1  */
/* data sd1.have;                         |        ,(typ, yr, month)                      |  A 2021  July    1  2   2  2  */
/* input ida$ idb$ month$                 |        ,(typ, yr, group_id)                   |  A 2021  July <NA>  2   2  2  */
/*       group_id$ cost                   |        ,(typ, yr)                             |  A 2021   Nov    1  2   2  2  */
/*       yr$ idc$ typ$;                   |        )                                      |  A 2021   Nov    2  1   1  1  */
/* cards4;                                |    "                                          |  A 2021   Nov <NA>  3   3  3  */
/* 428 408 Mar 2 67 2020 1 A              | want <- dbGetQuery(con, query)                |                               */
/* 196 176 Feb 2 27 2021 2 A              | print(want)                                   |  A 2021  <NA> <NA>  8*  8  8 **/
/* 423 403 Oct 2 160 2023 3 A             | dbDisconnect(con)                             |                               */
/* 191 171 Nov 2 53 2021 4 A              | fn_tosas9x(                                   |  A 2023   Oct    2  1   1  1  */
/* 186 166 Sep 1 186 2020 5 A             |       inp    = want                           |  A 2023   Oct <NA>  1   1  1  */
/* 186 166 Feb 1 226 2020 6 A             |      ,outlib ="d:/sd1/"                       |  A 2023  <NA> <NA>  1   1  1  */
/* 421 401 Jan 1 160 2020 6 A             |      ,outdsn ="want"                          |  A 2020  <NA>    1 12  12 12  */
/* 536 516 Nov 1 53 2021 6 A              |      )                                        |  A 2020  <NA>    2  3   3  4  */
/* 197 177 Jan 1 80 2021 6 A              | ;;;;                                          |  A 2021  <NA>    1  6   6  6  */
/* 184 164 May 2 173 2020 6 A             | %utl_rendx;                                   |  A 2021  <NA>    2  2   2  2  */
/* 190 170 July 1 160 2020 11 A           |                                               |  A 2023  <NA>    2  1   1  1  */
/* 183 163 Aug 1 293 2020 12 A            | proc print data=sd1.want;                     |                               */
/* 185 165 Feb 1 306 2020 13 A            | run;quit;                                     |  SAS                          */
/* 193 173 Apr 1 280 2020 14 A            |                                               |                 group         */
/* 187 167 Nov 1 160 2020 15 A            |                                               | typ  yr  month id    a  b  c  */
/* 189 169 Aug 1 147 2021 16 A            |                                               |                               */
/* 184 164 Dec 1 320 2020 17 A            |                                               |  A  2020 Apr    1    2  2  2  */
/* 184 164 May 2 133 2020 18 A            |                                               |  A  2020 Apr         2  2  2  */
/* 184 164 June 2 293 2020 18 A           |                                               |  A  2020 Aug    1    1  1  1  */
/* 187 167 Nov 1 80 2021 18 A             |                                               |  A  2020 Aug         1  1  1  */
/* 191 171 Mar 1 160 2020 18 A            |                                               |  A  2020 Dec    1    1  1  1  */
/* 535 515 Apr 1 160 2020 18 A            |                                               |  A  2020 Dec         1  1  1  */
/* 179 159 Feb 1 80 2020 23 A             |                                               |  A  2020 Feb    1    3  3  3  */
/* 187 167 May 2 173 2020 24 A            |                                               |  A  2020 Feb         3  3  3  */
/* 676 656 July 1 67 2021 25 A            |                                               |  A  2020 Jan    1    2  2  2  */
/* 187 167 Feb 1 160 2021 26 A            |                                               |  A  2020 Jan         2  2  2  */
/* 196 176 Mar 1 133 2020 27 A            |                                               |  A  2020 July   1    1  1  1  */
/* 197 177 July 1 160 2021 30 A           |                                               |  A  2020 July        1  1  1  */
/* 425 405 Dec 1 173 2021 30 A            |                                               |  A  2020 June   2    1  1  1  */
/* 185 165 Jan 1 120 2020 30 A            |                                               |  A  2020 June        1  1  1  */
/* ;;;;                                   |                                               |  A  2020 Mar    1    2  2  2  */
/* run;quit;                              |                                               |  A  2020 Mar    2    1  1  1  */
/*                                        |                                               |  A  2020 Mar         3  3  3  */
/*                                        |                                               |  A  2020 May    2    2  2  3  */
/*                                        |                                               |  A  2020 May         2  2  3  */
/*                                        |                                               |  A  2020 Nov    1    1  1  1  */
/*                                        |                                               |  A  2020 Nov         1  1  1  */
/*                                        |                                               |  A  2020 Sep    1    1  1  1  */
/*                                        |                                               |  A  2020 Sep         1  1  1  */
/*                                        |                                               |  A  2020            13 13 14  */
/*                                        |                                               |  A  2021 Aug    1    1  1  1  */
/*                                        |                                               |  A  2021 Aug         1  1  1  */
/*                                        |                                               |  A  2021 Dec    1    1  1  1  */
/*                                        |                                               |  A  2021 Dec         1  1  1  */
/*                                        |                                               |  A  2021 Feb    1    1  1  1  */
/*                                        |                                               |  A  2021 Feb    2    1  1  1  */
/*                                        |                                               |  A  2021 Feb         2  2  2  */
/*                                        |                                               |  A  2021 Jan    1    1  1  1  */
/*                                        |                                               |  A  2021 Jan         1  1  1  */
/*                                        |                                               |  A  2021 July   1    2  2  2  */
/*                                        |                                               |  A  2021 July        2  2  2  */
/*                                        |                                               |  A  2021 Nov    1    2  2  2  */
/*                                        |                                               |  A  2021 Nov    2    1  1  1  */
/*                                        |                                               |  A  2021 Nov         3  3  3  */
/*                                        |                                               |  A  2021             8  8  8  */
/*                                        |                                               |  A  2023 Oct    2    1  1  1  */
/*                                        |                                               |  A  2023 Oct         1  1  1  */
/*                                        |                                               |  A  2023             1  1  1  */
/*                                        |                                               |  A  2020        1   12 12 12  */
/*                                        |                                               |  A  2020        2    3  3  4  */
/*                                        |                                               |  A  2021        1    6  6  6  */
/*                                        |                                               |  A  2021        2    2  2  2  */
/*                                        |                                               |  A  2023        2    1  1  1  */
/*                                        |                                               |                               */
/*                                        |-------------------------------------------------------------------------------*/
/*                                        |                                               |                               */
/*                                        |  2 SAS 8 UNIONS AND A TRANSPOSE               | AS                            */
/*                                        |  ===============================              |               group           */
/*                                        |  /*Distinct Counts*/                          | yp  yr  month id    a  b  c   */
/*                                        |  Proc sql;                                    |                               */
/*                                        |  create table report as                       | A  2020 Apr    1    2  2  2   */
/*                                        |  select Type,Yr,Month,Group_ID                | A  2020 Apr         2  2  2   */
/*                                        |   ,' B' as name                               | A  2020 Aug    1    1  1  1   */
/*                                        |   ,count(distinct IDB) as value               | A  2020 Aug         1  1  1   */
/*                                        |  from Sample                                  | A  2020 Dec    1    1  1  1   */
/*                                        |  Group by Type,Yr,Month,Group_ID              | A  2020 Dec         1  1  1   */
/*                                        |  union                                        | A  2020 Feb    1    3  3  3   */
/*                                        |  select Type,Yr,Month,Group_ID,' A'           | A  2020 Feb         3  3  3   */
/*                                        |  ,count(distinct IDA)                         | A  2020 Jan    1    2  2  2   */
/*                                        |  from Sample                                  | A  2020 Jan         2  2  2   */
/*                                        |  Group by Type,Yr,Month,Group_ID              | A  2020 July   1    1  1  1   */
/*                                        |  union                                        | A  2020 July        1  1  1   */
/*                                        |  select Type,Yr,Month,Group_ID,' C'           | A  2020 June   2    1  1  1   */
/*                                        |  ,count(distinct IDC)                         | A  2020 June        1  1  1   */
/*                                        |  from Sample                                  | A  2020 Mar    1    2  2  2   */
/*                                        |  Group by Type,Yr,Month,Group_ID              | A  2020 Mar    2    1  1  1   */
/*                                        |                                               | A  2020 Mar         3  3  3   */
/*                                        |  /*total*/                                    | A  2020 May    2    2  2  3   */
/*                                        |  union                                        | A  2020 May         2  2  3   */
/*                                        |  select Type,Yr,Month,'total',' B' as name    | A  2020 Nov    1    1  1  1   */
/*                                        |  ,count(distinct IDB)                         | A  2020 Nov         1  1  1   */
/*                                        |  from Sample                                  | A  2020 Sep    1    1  1  1   */
/*                                        |  Group by Type,Yr,Month                       | A  2020 Sep         1  1  1   */
/*                                        |  union                                        | A  2020            13 13 14   */
/*                                        |  select Type,Yr,Month,'total',' A'            | A  2021 Aug    1    1  1  1   */
/*                                        |  ,count(distinct IDA)                         | A  2021 Aug         1  1  1   */
/*                                        |  from Sample                                  | A  2021 Dec    1    1  1  1   */
/*                                        |  Group by Type,Yr,Month                       | A  2021 Dec         1  1  1   */
/*                                        |  union                                        | A  2021 Feb    1    1  1  1   */
/*                                        |  select Type,Yr,Month,'total',' C'            | A  2021 Feb    2    1  1  1   */
/*                                        |  ,count(distinct IDC)                         | A  2021 Feb         2  2  2   */
/*                                        |  from Sample                                  | A  2021 Jan    1    1  1  1   */
/*                                        |  Group by Type,Yr,Month                       | A  2021 Jan         1  1  1   */
/*                                        |                                               | A  2021 July   1    2  2  2   */
/*                                        |  union                                        | A  2021 July        2  2  2   */
/*                                        |  select Type,Yr,'total',Group_ID,' B' as name | A  2021 Nov    1    2  2  2   */
/*                                        |  ,count(distinct IDB)                         | A  2021 Nov    2    1  1  1   */
/*                                        |  from Sample                                  | A  2021 Nov         3  3  3   */
/*                                        |  Group by Type,Yr,Group_ID                    | A  2021             8  8  8   */
/*                                        |  union                                        | A  2023 Oct    2    1  1  1   */
/*                                        |  select Type,Yr,'total',Group_ID,' A'         | A  2023 Oct         1  1  1   */
/*                                        |  ,count(distinct IDA)                         | A  2023             1  1  1   */
/*                                        |  from Sample                                  | A  2020        1   12 12 12   */
/*                                        |  Group by Type,Yr,Group_ID                    | A  2020        2    3  3  4   */
/*                                        |  union                                        | A  2021        1    6  6  6   */
/*                                        |  select Type,Yr,'total',Group_ID,' C'         | A  2021        2    2  2  2   */
/*                                        |  ,count(distinct IDC)                         | A  2023        2    1  1  1   */
/*                                        |  from Sample                                  |                               */
/*                                        |  Group by Type,Yr,Group_ID                    |                               */
/*                                        |                                               |                               */
/*                                        |  union                                        |                               */
/*                                        |  select Type,Yr,'total','total',' B' as name  |                               */
/*                                        |  ,count(distinct IDB)                         |                               */
/*                                        |  from Sample                                  |                               */
/*                                        |  Group by Type,Yr                             |                               */
/*                                        |  union                                        |                               */
/*                                        |  select Type,Yr,'total','total',' A'          |                               */
/*                                        |  ,count(distinct IDA)                         |                               */
/*                                        |  from Sample                                  |                               */
/*                                        |  Group by Type,Yr                             |                               */
/*                                        |  union                                        |                               */
/*                                        |  select Type,Yr,'total','total',' C'          |                               */
/*                                        |  ,count(distinct IDC)                         |                               */
/*                                        |  from Sample                                  |                               */
/*                                        |  Group by Type,Yr                             |                               */
/*                                        |  ;                                            |                               */
/*                                        |  quit;                                        |                               */
/*                                        |                                               |                               */
/*                                        |  proc transpose data=report out=want;         |                               */
/*                                        |    by type yr month group_id;                 |                               */
/*                                        |    id name;                                   |                               */
/*                                        |    var value;                                 |                               */
/*                                        |  run;quit;                                    |                               */
/**************************************************************************************************|***********************/

/*                 _
 _ __  _ __  _   _| |_
| `_ \| `_ \| | | | __|
| | | | |_) | |_| | |_
|_| |_| .__/ \__,_|\__|
      |_|
*/

options validvarname=v7;
libname sd1 "d:/sd1";
data sd1.have;
input ida$ idb$ month$
      group_id$ cost
      yr$ idc$ typ$;
cards4;
428 408 Mar 2 67 2020 1 A
196 176 Feb 2 27 2021 2 A
423 403 Oct 2 160 2023 3 A
191 171 Nov 2 53 2021 4 A
186 166 Sep 1 186 2020 5 A
186 166 Feb 1 226 2020 6 A
421 401 Jan 1 160 2020 6 A
536 516 Nov 1 53 2021 6 A
197 177 Jan 1 80 2021 6 A
184 164 May 2 173 2020 6 A
190 170 July 1 160 2020 11 A
183 163 Aug 1 293 2020 12 A
185 165 Feb 1 306 2020 13 A
193 173 Apr 1 280 2020 14 A
187 167 Nov 1 160 2020 15 A
189 169 Aug 1 147 2021 16 A
184 164 Dec 1 320 2020 17 A
184 164 May 2 133 2020 18 A
184 164 June 2 293 2020 18 A
187 167 Nov 1 80 2021 18 A
191 171 Mar 1 160 2020 18 A
535 515 Apr 1 160 2020 18 A
179 159 Feb 1 80 2020 23 A
187 167 May 2 173 2020 24 A
676 656 July 1 67 2021 25 A
187 167 Feb 1 160 2021 26 A
196 176 Mar 1 133 2020 27 A
197 177 July 1 160 2021 30 A
425 405 Dec 1 173 2021 30 A
185 165 Jan 1 120 2020 30 A
;;;;
run;quit;

/**************************************************************************************************************************/
/*  Obs    ida    idb    month    group_id    cost     yr     idc    typ                                                  */
/*                                                                                                                        */
/*   1    428    408    Mar         2          67    2020    1       A                                                    */
/*   2    196    176    Feb         2          27    2021    2       A                                                    */
/*   3    423    403    Oct         2         160    2023    3       A                                                    */
/*   4    191    171    Nov         2          53    2021    4       A                                                    */
/*   5    186    166    Sep         1         186    2020    5       A                                                    */
/*   6    186    166    Feb         1         226    2020    6       A                                                    */
/*   7    421    401    Jan         1         160    2020    6       A                                                    */
/*   8    536    516    Nov         1          53    2021    6       A                                                    */
/*   9    197    177    Jan         1          80    2021    6       A                                                    */
/*  10    184    164    May         2         173    2020    6       A                                                    */
/*  11    190    170    July        1         160    2020    11      A                                                    */
/*  12    183    163    Aug         1         293    2020    12      A                                                    */
/*  13    185    165    Feb         1         306    2020    13      A                                                    */
/*  14    193    173    Apr         1         280    2020    14      A                                                    */
/*  15    187    167    Nov         1         160    2020    15      A                                                    */
/*  16    189    169    Aug         1         147    2021    16      A                                                    */
/*  17    184    164    Dec         1         320    2020    17      A                                                    */
/*  18    184    164    May         2         133    2020    18      A                                                    */
/*  19    184    164    June        2         293    2020    18      A                                                    */
/*  20    187    167    Nov         1          80    2021    18      A                                                    */
/*  21    191    171    Mar         1         160    2020    18      A                                                    */
/*  22    535    515    Apr         1         160    2020    18      A                                                    */
/*  23    179    159    Feb         1          80    2020    23      A                                                    */
/*  24    187    167    May         2         173    2020    24      A                                                    */
/*  25    676    656    July        1          67    2021    25      A                                                    */
/*  26    187    167    Feb         1         160    2021    26      A                                                    */
/*  27    196    176    Mar         1         133    2020    27      A                                                    */
/*  28    197    177    July        1         160    2021    30      A                                                    */
/*  29    425    405    Dec         1         173    2021    30      A                                                    */
/*  30    185    165    Jan         1         120    2020    30      A                                                    */
/**************************************************************************************************************************/*/

/*                                      _                       _   _   _
/ |  _ __    __ _ _ __ ___  _   _ _ __ (_)_ __   __ _  ___  ___| |_| |_(_)_ __   __ _ ___
| | | `__|  / _` | `__/ _ \| | | | `_ \| | `_ \ / _` |/ __|/ _ \ __| __| | `_ \ / _` / __|
| | | |    | (_| | | | (_) | |_| | |_) | | | | | (_| |\__ \  __/ |_| |_| | | | | (_| \__ \
|_| |_|     \__, |_|  \___/ \__,_| .__/|_|_| |_|\__, ||___/\___|\__|\__|_|_| |_|\__, |___/
            |___/                |_|            |___/                           |___/
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(RPostgres)
library(DBI)
library(haven)
source("c:/oto/fn_tosas9x.R");
have<-read_sas("d:/sd1/have.sas7bdat")
have

con <- dbConnect(RPostgres::Postgres(),
   dbname = "postgres",
   host = "localhost",
   port = 5432,
   user = "postgres")

dbWriteTable(
  con
 ,"have"
 ,have
 ,row.names = FALSE
 ,overwrite = TRUE)
have
query <- "
    select
        typ
        ,yr
        ,month
        ,group_id
        ,1.0*count(distinct ida) as a
        ,1.0*count(distinct idb) as b
        ,1.0*count(distinct idc) as c
    from have
    group by grouping sets (
        (typ, yr, month, group_id)
       ,(typ, yr, month)
       ,(typ, yr, group_id)
       ,(typ, yr)
       )
   "
want <- dbGetQuery(con, query)
print(want)
dbDisconnect(con)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* > want <- dbGetQuery(con, query)     |                                                                                 */
/* > print(want)                        |  SAS                                                                            */
/*    typ   yr month group_id  a  b  c  |  typ     yr     month    group_id     a     b     c                             */
/*                                      |                                                                                 */
/* 1    A 2020   Apr        1  2  2  2  |   A     2020    Apr         1         2     2     2                             */
/* 2    A 2020   Apr     <NA>  2  2  2  |   A     2020    Apr                   2     2     2                             */
/* 3    A 2020   Aug        1  1  1  1  |   A     2020    Aug         1         1     1     1                             */
/* 4    A 2020   Aug     <NA>  1  1  1  |   A     2020    Aug                   1     1     1                             */
/* 5    A 2020   Dec        1  1  1  1  |   A     2020    Dec         1         1     1     1                             */
/* 6    A 2020   Dec     <NA>  1  1  1  |   A     2020    Dec                   1     1     1                             */
/* 7    A 2020   Feb        1  3  3  3  |   A     2020    Feb         1         3     3     3                             */
/* 8    A 2020   Feb     <NA>  3  3  3  |   A     2020    Feb                   3     3     3                             */
/* 9    A 2020   Jan        1  2  2  2  |   A     2020    Jan         1         2     2     2                             */
/* 10   A 2020   Jan     <NA>  2  2  2  |   A     2020    Jan                   2     2     2                             */
/* 11   A 2020  July        1  1  1  1  |   A     2020    July        1         1     1     1                             */
/* 12   A 2020  July     <NA>  1  1  1  |   A     2020    July                  1     1     1                             */
/* 13   A 2020  June        2  1  1  1  |   A     2020    June        2         1     1     1                             */
/* 14   A 2020  June     <NA>  1  1  1  |   A     2020    June                  1     1     1                             */
/* 15   A 2020   Mar        1  2  2  2  |   A     2020    Mar         1         2     2     2                             */
/* 16   A 2020   Mar        2  1  1  1  |   A     2020    Mar         2         1     1     1                             */
/* 17   A 2020   Mar     <NA>  3  3  3  |   A     2020    Mar                   3     3     3                             */
/* 18   A 2020   May        2  2  2  3  |   A     2020    May         2         2     2     3                             */
/* 19   A 2020   May     <NA>  2  2  3  |   A     2020    May                   2     2     3                             */
/* 20   A 2020   Nov        1  1  1  1  |   A     2020    Nov         1         1     1     1                             */
/* 21   A 2020   Nov     <NA>  1  1  1  |   A     2020    Nov                   1     1     1                             */
/* 22   A 2020   Sep        1  1  1  1  |   A     2020    Sep         1         1     1     1                             */
/* 23   A 2020   Sep     <NA>  1  1  1  |   A     2020    Sep                   1     1     1                             */
/* 24   A 2020  <NA>     <NA> 13 13 14  |   A     2020                         13    13    14                             */
/* 25   A 2021   Aug        1  1  1  1  |   A     2021    Aug         1         1     1     1                             */
/* 26   A 2021   Aug     <NA>  1  1  1  |   A     2021    Aug                   1     1     1                             */
/* 27   A 2021   Dec        1  1  1  1  |   A     2021    Dec         1         1     1     1                             */
/* 28   A 2021   Dec     <NA>  1  1  1  |   A     2021    Dec                   1     1     1                             */
/* 29   A 2021   Feb        1  1  1  1  |   A     2021    Feb         1         1     1     1                             */
/* 30   A 2021   Feb        2  1  1  1  |   A     2021    Feb         2         1     1     1                             */
/* 31   A 2021   Feb     <NA>  2  2  2  |   A     2021    Feb                   2     2     2                             */
/* 32   A 2021   Jan        1  1  1  1  |   A     2021    Jan         1         1     1     1                             */
/* 33   A 2021   Jan     <NA>  1  1  1  |   A     2021    Jan                   1     1     1                             */
/* 34   A 2021  July        1  2  2  2  |   A     2021    July        1         2     2     2                             */
/* 35   A 2021  July     <NA>  2  2  2  |   A     2021    July                  2     2     2                             */
/* 36   A 2021   Nov        1  2  2  2  |   A     2021    Nov         1         2     2     2                             */
/* 37   A 2021   Nov        2  1  1  1  |   A     2021    Nov         2         1     1     1                             */
/* 38   A 2021   Nov     <NA>  3  3  3  |   A     2021    Nov                   3     3     3                             */
/* 39   A 2021  <NA>     <NA>  8  8  8  |   A     2021                          8     8     8                             */
/* 40   A 2023   Oct        2  1  1  1  |   A     2023    Oct         2         1     1     1                             */
/* 41   A 2023   Oct     <NA>  1  1  1  |   A     2023    Oct                   1     1     1                             */
/* 42   A 2023  <NA>     <NA>  1  1  1  |   A     2023                          1     1     1                             */
/* 43   A 2020  <NA>        1 12 12 12  |   A     2020                1        12    12    12                             */
/* 44   A 2020  <NA>        2  3  3  4  |   A     2020                2         3     3     4                             */
/* 45   A 2021  <NA>        1  6  6  6  |   A     2021                1         6     6     6                             */
/* 46   A 2021  <NA>        2  2  2  2  |   A     2021                2         2     2     2                             */
/* 47   A 2023  <NA>        2  1  1  1  |   A     2023                2         1     1     1                             */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
