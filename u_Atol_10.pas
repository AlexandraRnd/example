unit u_Atol_10;

interface
   uses Dialogs,u_dm,db,Math,U_const,ComObj,Forms,SysUtils,windows,Variants,DateUtils,u_Pos_Terminal;

{==Печать НДС на чеке}
  function Atol_v10_SetTaxMode(const cdtax_val:variant): Double;
  {=Пишем ошибки в лог и возвращаем текст ошибки}
  function Atol_v10_SetErrorInLog(const err :integer;const nm: string):string;
  

     {=Полное состояние ккт}
   function Atol_v10_LongStatus(var Info: string):boolean;

  ///    Регистрация кассира  пароль не нужен
  procedure  Atol_v10_SetKassir_Inn;
   {=Создаем соединение с драйвером-СОМ объект}
  function   Atol_v10_CreateConnect(var fptr:OleVariant): integer;
   {=Окно настройки драйвера}
  function   Atol_v10_OpenDriverWindow(const nmFormParent:string) :integer;
    {=Проверка открытости смены Атол10}
  function   Atol_v10_CheckStatus(var Info: string):boolean;
   {= Короткий запрос статуса ККТ }
  function   Atol_v10_ShotStatusKKT : string;
    {=Закрытие документа_ошибки_обработки}
  procedure  Atol_v10_CheckDocumentClose;
  {= X-отчет}
  Procedure  Atol_v10_Xotchet;
    {= Z-отчет}
  Procedure  Atol_v10_Zotchet;
  
    {=  Открытие смены  atol_10}
  procedure Atol_v10_OpenSmena;
  {=Отменить чек}
  procedure  Atol_v10_CancelCheck;
  
  {=Печать банковского слипа}
  function   Atol_v10_PrintBankSlip(const slip_check : string):boolean;
  {=Печать последнего документа}
  procedure  Atol_v10_PrintLastDoc;
  
  
    {=Внесение}
  procedure  Atol_v10_cashIncome(const sum:double);

  {=Вынесение}
  procedure  Atol_v10_cashOutcome(const sum:double);
    {=Печать чеков по новому формату драйвер v10 }
  function   PrintCheck_Atol_v10_105_old( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 приход}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                     ;pPay_packed: TPay_packed ) : Boolean;

  {=Печать чеков по новому формату драйвер v10 }
  function   PrintCheck_Atol_v10_1_051_new( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 приход}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                    ;pPay_packed: TPay_packed ) : Boolean;

                                     
       {== Тест 
            только для оплаты через новую форму  Тест}                                           
  function PrintCheck_Atol_v1_05_smesh_test(const slip_check: string;
                                         DataSet: TDataSet;
                                         var nomcheck:Integer; var FNDoc: integer; 
                                         pPay_packed: TPay_packed ) : Boolean; 
                                            
           {=Печать чеков по новому формату  ===    СмешОплата}
  function PrintCheck_Atol_v1_05_smesh( const slip_check: string;
                                         DataSet: TDataSet;
                                         var nomcheck:Integer; var FNDoc: integer; 
                                         pPay_packed: TPay_packed ) : Boolean;                              


  function   PrintCheck_Atol_v10_1_051_new_test( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 приход}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                    ;pPay_packed: TPay_packed ) : Boolean;
                                    

  function Atol_v10_SetErrorInLog_test(const err :integer;const nm: string):string;

  //Запрос срока действия ФН
  function  Atol_v10_End_TimeFN : TDateTime;
  {= Количество дней до окончания срока действия}
  Function Atol_v10_CountDayOfEndFN: string;

  
{==Печать НДС на чеке}
  function Atol_v10_SetTaxMode_test(const cdtax_val:variant): Double;
 {=чек коррекции 10}
   procedure Atol_v10_CorrectionCheck_1_05(const SummCash      : Double;
                              const SummNonCash   : Double;
                              const SummAvans     : Double;
                              const TaxCode       : integer;
                              const isPrihod      : boolean;
                              const CorrTypeSamost: boolean;
                              const nameCorre :string;//почему причина
                                const NDoc:string;
                               dt:TDatetime;const nmusl: string;const kol :integer
                              ;var numcheck : integer;var FNDoc:integer);

   
implementation

  (*Формирование чека коррекции (ФФД 1.0, 1.05) состоит из следующих операций:

    открытие чека и передача реквизитов чека
    регистрация итога
    регистрация налогов на чек (необязательный пункт)
    регистрация оплат (необязательный пункт)
    закрытие чека
    проверка состояния чека
*)





function  Atol_v10_End_TimeFN : TDateTime;

//Запрос срока действия ФН
 var
    registrationsRemain:    Longint;
    registrationsCount:     Longint;
    r_dateTime:             TDateTime;
begin
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_FN_DATA_TYPE, dm.fptr.LIBFPTR_FNDT_VALIDITY);
  dm.fptr.fnQueryData;

  registrationsRemain := dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_REGISTRATIONS_REMAIN);
  registrationsCount  := dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_REGISTRATIONS_COUNT);
  r_dateTime          := dm.fptr.getParamDateTime(dm.fptr.LIBFPTR_PARAM_DATE_TIME);
  result:=r_dateTime
end; 

Function Atol_v10_CountDayOfEndFN: string;
var dt : TDateTime;
    st : String;
begin
  dt:=Atol_v10_End_TimeFN;
  st:=' !!! Осталось дней '+IntTostr(DaysBetween(date,dt))+' до окончания ФН '+#13#10+
      ' Дата окончания ФН: '+FormatDateTime('dd.mm.yyyy',dt);
result:=st;     
end;


 {=чек коррекции 10}
procedure Atol_v10_CorrectionCheck_1_05(const SummCash      : Double;
                              const SummNonCash   : Double;
                              const SummAvans     : Double;
                              const TaxCode       : integer;
                              const isPrihod      : boolean;
                              const CorrTypeSamost: boolean;
                              const nameCorre :string;//почему причина
                                const NDoc:string;
                               dt:TDatetime ;const nmusl: string;const kol :integer
                              ;var numcheck : integer;var FNDoc:integer);
 var
  sum_p,tax:double;
  stype:string;
  sprich,str:string; // Тип коррекции
 // NCheck:integer;
  systnal,typecor,r : integer;      // СНО
  summ: double;
  date: TDateTime;
  correctionInfo: Variant;
begin
      //Открытие соединения с ккт
  dm.fptr.open; 
          //Запрос параметров
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   numcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   numcheck:=numcheck+1;
   SaveLogPlut('Номер чека= '+IntToStr(numcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('Номер Фиск.Док= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

  
    sum_p:=0;
             {= Применяемая система налогооблажения в чеке:  в форме настройка ККТ}
 //  dm.fptr.AttrNumber:=1055;
    systnal:=Atol.TaxSystemNalog+1;
    case systnal of
    -1:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_DEFAULT);
           str:='LIBFPTR_TT_DEFAULT';
         end;
      1:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_OSN);
            str:='LIBFPTR_TT_OSN';
          end;  
      2:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME);
           str:='LIBFPTR_TT_USN_INCOME'
          end;
      3:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME_OUTCOME);
            str:='LIBFPTR_TT_USN_INCOME_OUTCOME'
          end;  
      4:  begin
           r:= dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_ENVD);
           str:= 'LIBFPTR_TT_ENVD';
          end; 
    end;
    SaveLogPlut('Система налогооблажения CНО :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 161 Send Система налогооблажения: ');

      // Тип коррекции

    if CorrTypeSamost=true
      then
           begin typecor:=0; sprich:='Самост' end  // Самостоятельно
      else begin typecor:=1; sprich:='Предп' end; // по предписанию
   
     SaveLogPlut('BeginComplexAttribute 1173 CorrType ='+sprich+ ' ;1177 nameCorre= ' +nameCorre+
                  ';1178 дата= '+DateToStr(dt)+ ';1179 Номер документа NDoc=' +NDoc );   
    
    //nameCorre:= 'Документ основания коррекции';
  //  nameCorre;//почему причина; // Наименование документа основания для коррекции
    dm.fptr.setParam(1177,nameCorre);
    dm.fptr.setParam(1178,dt);
    dm.fptr.setParam(1179,NDoc);
    r:=dm.fptr.utilFormTlv;
     Atol_v10_SetErrorInLog(r,' dm.fptr.utilFormTlv(178  ');
    correctionInfo := dm.fptr.getParamByteArray(dm.fptr.LIBFPTR_PARAM_TAG_VALUE);

    r:=  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE, dm.fptr.LIBFPTR_RT_SELL_CORRECTION);
         Atol_v10_SetErrorInLog(r,' dm.fptr.LIBFPTR_RT_SELL_CORRECTION ');
    r:=dm.fptr.setParam(1173, typecor);
             Atol_v10_SetErrorInLog(r,' 184 dm.fptr.setParam(1173, typecor)');
    r:=dm.fptr.openReceipt;
      Atol_v10_SetErrorInLog(r,' dm.fptr.openReceipt(178  ');
               //1212          	Признак предмета расчета
    ///    dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
       //1212          	Признак предмета расчета
     dm.fptr.setParam(1212, 4);   //Признак предмета расчёта	4 - услуга
     if SummAvans>0 then
       begin
         dm.fptr.setParam(1214, 3);
         sum_p:= SummAvans;
       end
      else  dm.fptr.setParam(1214, 4);  

     if SummNonCash>0 then
               sum_p:=SummNonCash;
     if SummCash>0 then
                sum_p:=SummCash;  

       dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, nmusl);
       dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, sum_p);
       dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);

        SaveLogPlut('nmusl= '+nmusl+ ' sum_p= ' +floattostr(sum_p)+
              ' kol= '+ intTostr(kol));               
     (* tax:=0;
     tax:=Atol_v10_SetTaxMode(TaxCode);
      sum_p:= sum_p*tax;   *)
   //  SaveLogPlut('summa= '+FloatToStr(sum_p)+ ' налог= ' +floattostr(sum_p*tax));    
      r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_NO);
           Atol_v10_SetErrorInLog(r,'LIBFPTR_TAX_NO');
      r:=dm.fptr.registration;
        Atol_v10_SetErrorInLog(r,'registration');      
     	if SummNonCash>0 then 
       begin 
         SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 

         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,1);
                  SaveLogPlut(' 225');  

       end
    else
    if SummCash>0 then
     
       begin
        SaveLogPlut('! BezNal=False наличка LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // наличка
     
                dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
              SaveLogPlut(' 236'); 

       end;

     dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_SUM, sum_p);
     SaveLogPlut('233= (dm.fptr.LIBFPTR_PARAM_SUM'+FloatToStr(sum_p));
      r:=dm.fptr.receiptTotal;
      if r>0 then
      begin  
            SaveLogPlut(' 238');  
           Atol_v10_SetErrorInLog(r,'receiptTotal');
             r:=dm.fptr.cancelReceipt;
              Atol_v10_SetErrorInLog(r,'receiptTotal cancelReceipt');
          dm.fptr.close;
      end;
                      
    // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, sum_p); 
   (* dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sum_p);
      

      r:= dm.fptr.payment;
      if r>0 then
      begin
         Atol_v10_SetErrorInLog(r,'payment correct');
          r:=dm.fptr.cancelReceipt;
                 Atol_v10_SetErrorInLog(r,'payment correct cancelReceipt');
          dm.fptr.close;
      end;    *)
           
       


      r:=dm.fptr.closeReceipt;     
          sleep(5);
             Atol_v10_CheckDocumentClose;
    dm.fptr.close;  
          
      SaveLogPlut('BeginComplexAttribute 1173 CorrType ='+sprich+ ' ;1177 nameCorre= ' +nameCorre+
                  ';1178 дата= '+DateToStr(dt)+ ';1179 Номер документа NDoc=' +NDoc 
                     +' numch='+intTostr(numcheck)+' ;Fndoc='+IntToStr(FNDoc));    
end;




{=Создаем соединение с драйвером-СОМ объект}
function Atol_v10_CreateConnect(var fptr:OleVariant): integer;
var version : string;
 begin
 result:=1;
 try
  {=  10.х }
     // CoInitialize(nil);
    dm.fptr := CreateOleObject('AddIn.Fptr10');
           SaveLogPlut('CreateOleObject Atol_10 успешно  ');
    //fptr.ApplicationHandle := Application.Handle;
    
   // fptr.erroecode;
     
        
    except   on e: exception do
     begin
       ShowMessage('Не удалось создать объект драйвера "Атол_10"!');
       SaveLogPlut('CreateOleObject Atol_10 '+ e.Message);
       isSmenaOpen:=pError;
       Result:=-1;
     end;
    
  end;
     dm.fptr.open;
     version := fptr.version;
              SaveLogPlut('version ' + version);
     dm.fptr.close;
end;




 {=Окно настройки драйвера}
function Atol_v10_OpenDriverWindow(const nmFormParent:string) :integer;
 var tp :Integer;
      str : string;
begin
//FindWindow(nil, 'Карточки сотрудников') <> 0 
 SaveLogPlut('=Окно настройки драйвера');
 dm.fptr.open;
// tp:=dm.fptr.showProperties(dm.fptr.LIBFPTR_GUI_PARENT_NATIVE, FindWindow(nil,@nmFormParent));
 tp:=dm.fptr.showProperties(dm.fptr.LIBFPTR_GUI_PARENT_NATIVE, FindWindow('Form1',nil));
 Result:=tp;
   case tp of
   -1: str:=' Ошибка';
    0: str:=' Кнопка OK';
    1: str:=' Просто вышли из формы '
   end;
 dm.fptr.close;
  SaveLogPlut('=Окно настройки драйвера ')
end;



///    Регистрация кассира пароль не нужен
procedure Atol_v10_SetKassir_Inn;
var r: integer;
begin
 //dm.fptr.open;

  r:=dm.fptr.setParam(1021, 'Кассир '+TRIM(USERNM));
    if r<>0  then
      begin
        ShowMessage(' Ошибка передачи логина Кассира '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
        SaveLogPlut(' Ошибка передачи логина Кассира '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
      end;
  SaveLogPlut('Кассир '+TRIM(USERNM));
  if USER_INN<>'' then
    begin
       SaveLogPlut('USER_INN '+TRIM(USER_INN));
      dm.fptr.setParam(1203,USER_INN );
    end;
    r:=dm.fptr.operatorLogin;
  if r<0 then
   begin
     SaveLogPlut(' Ошибка регистрации Кассира '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
   end else
     SaveLogPlut('Atol_v10_SetKassir_Inn operatorLogin  прошло');
// dm.fptr.close;  
end;


 {=Проверка открытости смены Атол10}
function Atol_v10_CheckStatus(var Info: string):boolean;
var    s: string;
   shiftState,mode,submode: Longint;
   strM,strZag :string;
              isOpened:boolean;
 // number: Longint;
 //dateTime: TDateTime;
begin
s:='';
strM :='';
  Result:=false;
  SaveLogPlut(' 180 CheckStatusAtol_10  ');
 
  dm.fptr.open;
  
  isOpened := dm.fptr.isOpened;
  Atol_v10_SetKassir_Inn;
     {=  Запрос состояния смены  }
SaveLogPlut(' 188 Запрос состояния смены ');
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DATA_TYPE,dm.Fptr.LIBFPTR_DT_SHIFT_STATE);
  if dm.fptr.queryData<0 then
    begin
      SaveLogPlut('Ошибка проверки смены  '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
      Result:=False;
     end
  else    
   begin
     shiftState:= dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_SHIFT_STATE);
     SaveLogPlut('LIBFPTR_PARAM_SHIFT_shiftState shiftState= '+ IntToStr(shiftState));
     if shiftState= dm.fptr.LIBFPTR_SS_CLOSED then
        begin
          isSmenaOpen:=pClose;
         // SaveLogPlut(' смена= закрыта' );
           strM:=strM+';'+#13#10+' смена Открыта = Нет';
                SaveLogPlut(' смена Открыта = Нет');
          result:=false;
        end;
     if shiftState= dm.fptr.LIBFPTR_SS_OPENED then
        begin
          isSmenaOpen:=pOpen;
          //SaveLogPlut(' смена  =  открыта' );
            strM:=strM+';'+#13#10+' смена Открыта = Да';
                   SaveLogPlut(' смена Открыта = Да');
          result:=true;
        end; 
     if shiftState= dm.fptr.LIBFPTR_SS_EXPIRED then
        begin
                 SaveLogPlut(' Кончилась открытая  смена 24 часа = Да');
         isSmenaOpen:=pOldOpen;
       //  SaveLogPlut(' Кончилась открытая  смена 24 часа' );
            strM:=strM+';'+#13#10+'  Кончилась открытая  смена 24 часа = Да'; 
         result:=true;
        end; 
end;
  SaveLogPlut(strM);    
  Info:=   strM;
  dm.fptr.close;
  // SetStatusForKassa(stbMenue);
end;


{=Полное состояние ккт}
function Atol_v10_LongStatus(var Info: string):boolean;
var    s: string;
   shiftState,mode,submode: Longint;
   isPaperPresent,isPaperNearEnd :LongBool;
    isPrinterConnectionLost: LongBool;
    isPrinterError:          LongBool;
    isCutError:              LongBool;
    isPrinterOverheat:       LongBool;
    isDeviceBlocked:         LongBool;

   versionKKt,serialNumber,
   modelName,firmwareVersion :string;
   strM,strZag :string;
              isOpened:boolean;
 // number: Longint;
 //dateTime: TDateTime;
begin
s:='';
strM :='';
  Result:=True;
  SaveLogPlut(' 247 CheckStatusAtol_10  ');
 
  dm.fptr.open;
  
  isOpened := dm.fptr.isOpened;
  Atol_v10_SetKassir_Inn;
     {=  Запрос состояния  }
SaveLogPlut(' 254 Запрос состояния ккт');
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DATA_TYPE, dm.fptr.LIBFPTR_DT_STATUS);
  if dm.fptr.queryData<0 then
    begin
      SaveLogPlut('Ошибка проверки смены  '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
      Result:=False;
     end
  else    
   begin

     Atol_v10_SetErrorInLog(1,'CheckStatusAtol_10');

      mode        := dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_MODE);
            strM:=strm+';'+#13#10+' Режим mode='+IntToStr(mode); 
     submode         := dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_SUBMODE);
             strM:=strm+';'+#13#10+' ПодРежим submode='+IntToStr(submode); 
     
     isPaperPresent     := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_RECEIPT_PAPER_PRESENT);
     if isPaperPresent=True then
                strM:=strM+';'+#13#10+' Есть бумага = да' 
      else
         begin
          strM:=strM+';'+#13#10+' Есть бумага = Нет';
          result:=false;
         end;
     //  SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
  

    isPaperNearEnd:=dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PAPER_NEAR_END);
    if isPaperNearEnd =True then
     begin
       strM:=strM+';'+#13#10+' Бумага скоро закончится = Да ';
       result:=false;
     end
    else       
       strM:=strM+';'+#13#10+' Бумага скоро закончится = Нет ';

     versionKKT:=dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_UNIT_VERSION);  
     strM:=strm+';'+#13#10+versionKKT; 

     serialNumber    := dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_SERIAL_NUMBER);
     strM:=strM+';'+#13#10+' Заводской номер ККТ: '+serialNumber;
     modelName       := dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_MODEL_NAME);
     strM:=strM+';'+#13#10+'Название ККТ: '+modelName;  
     firmwareVersion := dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_UNIT_VERSION);
     strM:=strM+';'+#13#10+'Версия ПО ККТ: '+firmwareVersion; 

     
     isPrinterConnectionLost := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PRINTER_CONNECTION_LOST);
     if isPrinterConnectionLost=True then
       begin
         strM:=strM+';'+#13#10+' Потеряно соединение с печатным механизмом = Да';
         result:=false;
       end
     else  
        strM:=strM+';'+#13#10+' Потеряно соединение с печатным механизмом = Нет';  
     
     
     isPrinterError           := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PRINTER_ERROR);
     if isPrinterError=True then
       begin
         strM:=strM+';'+#13#10+' Невосстановимая ошибка печатного механизма = Да';
         result:=false;
       end
     else  
        strM:=strM+';'+#13#10+'  Невосстановимая ошибка печатного механизма = Нет';  
     isCutError               := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_CUT_ERROR);
     if isCutError=True then
        begin
         strM:=strM+';'+#13#10+' Ошибка отрезчика= Да';
         result:=false;
        end
     else  
        strM:=strM+';'+#13#10+' Ошибка отрезчика = Нет'; 
     
     isPrinterOverheat        := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PRINTER_OVERHEAT);
     if isPrinterOverheat=True then
       begin
         strM:=strM+';'+#13#10+' Перегрев печатного механизма = Да';
         result:=false;
       end
     else  
        strM:=strM+';'+#13#10+' Перегрев печатного механизма = Нет'; 
     
     isDeviceBlocked          := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_BLOCKED);
     if isDeviceBlocked=True then
      begin
        strM:=strM+';'+#13#10+' ККТ заблокирована из-за ошибок = Да';
        result:=false;
      end
     else  
        strM:=strM+';'+#13#10+' ККТ заблокирована из-за ошибок = Нет';
   end;
     SaveLogPlut(strM);    
  Info:=   strM;
  dm.fptr.close;
end;

{=Закрытие документа_ошибки_обработки}
procedure Atol_v10_CheckDocumentClose;
 var str :string;
begin
SaveLogPlut('289   сheck doc');
  If dm.fptr.checkDocumentClosed <0 then
    begin
        // Не удалось проверить состояние документа. Вывести пользователю текст ошибки, попросить устранить неполадку и повторить запрос
      str:= Atol_v10_SetErrorInLog(-1,'293 Atol_v10_SetErrorInLog');
     showmessage(' Ошибка закрытия документа checkDocumentClosed '+#13#10+str);
     //SaveLogPlut(' Ошибка закрытия документа checkDocumentClosed'+#13#10 +IntToStr(dm.fptr.errorCode)+'  ' + dm.fptr.errorDescription);
     exit;
    end;

    if not dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_DOCUMENT_CLOSED) then
    begin
        SaveLogPlut('  395  cancelReceipt');
        // Документ не закрылся. Требуется его отменить (если это чек) и сформировать заново
      dm.fptr.cancelReceipt;
      str:= Atol_v10_SetErrorInLog(-1,'303 Atol_v10_SetErrorInLog');
      showmessage('Ошибка закрытия документа checkDocumentClosed '+#13#10+str);
      exit;
    end;

    if not dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_DOCUMENT_PRINTED) then
    begin
        // Можно сразу вызвать метод допечатывания документа, он завершится с ошибкой, если это невозможно
        SaveLogPlut('  405 continuePrint');
      if dm.fptr.continuePrint < 0 then
        begin
           str:= Atol_v10_SetErrorInLog(-1,'313 Atol_v10_SetErrorInLog');
           showmessage('Ошибка закрытия документа continuePrint '+#13#10+str);
        end;
    end;
    
end;





  {=  Открытие смены  atol10}
procedure Atol_v10_OpenSmena;
var r :integer;
 str : string;
begin
  SaveLogPlut(' Открываем смену Атол_10');
  dm.fptr.open;
  Atol_v10_SetKassir_Inn;
  r:=dm.fptr.openShift;
  Atol_v10_SetErrorInLog(r,'openShift'); 
    If dm.fptr.checkDocumentClosed <0 then
    begin
        // Не удалось проверить состояние документа. Вывести пользователю текст ошибки, попросить устранить неполадку и повторить запрос
      str:= Atol_v10_SetErrorInLog(-1,'Atol_v10_SetErrorInLog');
     showmessage('Ошибка закрытия документа checkDocumentClosed '+#13#10+str);
     //SaveLogPlut(' Ошибка закрытия документа checkDocumentClosed'+#13#10 +IntToStr(dm.fptr.errorCode)+'  ' + dm.fptr.errorDescription);
     exit;
    end;
  //Atol_v10_CheckDocumentClose;
  dm.fptr.close;  //разрыв соединения
  //dm.fptr.checkDocumentClosed;

end;


procedure Atol_v10_cancelCheck;
var r:integer;
begin
  SaveLogPlut('Atol10_cancelCheck');
  dm.fptr.open;
  r:=dm.fptr.cancelReceipt;
  Atol_v10_SetErrorInLog(r,' Отмена чека ');
  dm.fptr.close;
end;   

function Atol_v10_SetErrorInLog(const err :integer;const nm: string):string;
var res :string;
begin
res:='';
if err<0 then
  begin
   res:=IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription;
    SaveLogPlut('Ошибка '+nm+' '+res);
  end
  else SaveLogPlut(nm+' выполнилось без ошибок');
 result:=res; 
end;


function Atol_v10_SetErrorInLog_test(const err :integer;const nm: string):string;
var res :string;
begin
res:='';
   SaveLogPlut(nm);
 result:=res; 
end;

{= X-отчет}
Procedure  Atol_v10_Xotchet;
var r:integer;
sl, check_pos:string;
begin
r:=0;
 SaveLogPlut('Печать X-отчета');
 
   if (nastrlist.Values['PinPad_pilot_nt']='1')  then  
   begin
   //  if TypePinpad=pPinpad then 
     sl:=XSmena_posTerminal(check_pos);
     SaveLogPlut('Atol_v10_PrintBankSlip  '+check_pos );
     if check_pos<>'' then 
       Atol_v10_PrintBankSlip(check_pos)
     else  SaveLogPlut('Нет слип чека');
  end;
  SaveLogPlut('===Atol_v10_Xotchet;===');
   dm.fptr.open;
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_REPORT_TYPE, dm.fptr.LIBFPTR_RT_X);
   r:=dm.fptr.report;
   dm.fptr.close; 
  Atol_v10_SetErrorInLog(r,'Печать X-отчета');
end;

    {= Z-отчет}
Procedure  Atol_v10_Zotchet;
var r:integer;
 check_pos,str,slip: string;

begin
 check_pos:='';

r:=0;
  SaveLogPlut('Печать Z-отчета');
  if (nastrlist.Values['PinPad_pilot_nt']='1') then  
   begin
     //if TypePinpad=pPinpad then 
         check_pos:=CloseSmena_posTerminal(slip);
     if slip<>'' then 
       Atol_v10_PrintBankSlip(slip)
     else  SaveLogPlut('Нет слип чека');
  end;
  dm.fptr.open; 
  Atol_v10_SetKassir_Inn;
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_REPORT_TYPE, dm.fptr.LIBFPTR_RT_CLOSE_SHIFT);
  r:=dm.fptr.report;
   Atol_v10_SetErrorInLog(r,'Печать Z-отчета');
      If dm.fptr.checkDocumentClosed <0 then
    begin
        // Не удалось проверить состояние документа. Вывести пользователю текст ошибки, попросить устранить неполадку и повторить запрос
      str:= Atol_v10_SetErrorInLog(-1,'Atol_v10_SetErrorInLog');
     showmessage('Ошибка закрытия документа checkDocumentClosed '+#13#10+str);
     //SaveLogPlut(' Ошибка закрытия документа checkDocumentClosed'+#13#10 +IntToStr(dm.fptr.errorCode)+'  ' + dm.fptr.errorDescription);
   //  exit;
    end;
  dm.fptr.close; 
end;




{= Короткий запрос статуса ККТ }

function  Atol_v10_ShotStatusKKT : string;
var
// isCashDrawerOpened:      LongBool;
 isPaperPresent:          LongBool;
 isPaperNearEnd:          LongBool;
 isCoverOpened:           LongBool;
 strM, strZag : string;
begin
strZag:='';
strM:='';
strZag:='Короткий запроc состояния драйвера Атол v10 ';
SaveLogPlut(strZag);
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DATA_TYPE, dm.fptr.LIBFPTR_DT_SHORT_STATUS);
   if dm.fptr.queryData<0 then
    begin
      Atol_v10_SetErrorInLog(-1,'ShotStatusKKT');
      strM:= strM+';'+#13#10+IntToStr(dm.fptr.errorCode)+' ' +dm.fptr.errorDescription; 
      showmessage_good('Ошибка'+ strZag+ #13#10+strM);
      SaveLogPlut('Ошибка'+ strZag+ #13#10+strM);
      Result:=strM;
      exit;
    end;
  Atol_v10_SetErrorInLog(1,'ShotStatusKKT');
 // isCashDrawerOpened := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_CASHDRAWER_OPENED);
  isPaperPresent     := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_RECEIPT_PAPER_PRESENT);
  if isPaperPresent=False then
   begin
    strM:=strM+';'+#13#10+' Нет бумаги '; 
    SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
    Result:=strM;
   end;

  isPaperNearEnd:=dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PAPER_NEAR_END);
  if isPaperNearEnd =True then
   begin
    strM:=strM+';'+#13#10+' Бумага скоро закончится'; 
    SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
    Result:=strM;
   end;

  isCoverOpened      := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_COVER_OPENED);
  if isCoverOpened =True then
   begin
     strM:=strM+';'+#13#10+' Открыта крышка ККТ'; 
    SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
    Result:=strM;
   end;
end;


function Atol_v10_PrintBankSlip(const slip_check : string):boolean;
var r:integer;
 str : string;
begin
result:=False;
  SaveLogPlut('==  печать слипа отдельно начало ===');
    dm.fptr.open;///соединение с ккт
     // Формирование слипа чек-постерминала
    dm.fptr.beginNonfiscalDocument;
        //перенос по 
    r:= dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP,dm.fptr.LIBFPTR_TW_CHARS);
     str:=Atol_v10_SetErrorInLog(r,'slip_check');
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT,slip_check);
    dm.fptr.printText;  
    r:=dm.fptr.endNonfiscalDocument;
      str:=Atol_v10_SetErrorInLog(r,'endNonfiscalDocument');
      
 result:=True;   
  SaveLogPlut('== печать слипа конец===');  
end;  


  {=Печать последнего документа}
procedure  Atol_v10_PrintLastDoc;
var r : integer;
begin
 dm.fptr.open;
 dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_REPORT_TYPE, dm.fptr.LIBFPTR_RT_LAST_DOCUMENT);
 r:=dm.fptr.report;
  Atol_v10_SetErrorInLog(r,'printLastDoc');
 dm.fptr.close;
  
end;


  {=Внесение}
procedure Atol_v10_cashIncome(const sum:double);
var r:integer;
begin
 SaveLogPlut('Внесение sum='+FloatTostr(sum));
 dm.fptr.open;
 dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_SUM, sum);
 r:=dm.fptr.cashIncome;
 dm.fptr.close;
 Atol_v10_SetErrorInLog(r,'Atol10_cashIncome ');
end;


  {=Вынесение}
procedure Atol_v10_cashOutcome(const sum:double);
var r:integer;
begin
 SaveLogPlut('Вынесение sum='+FloatTostr(sum));
  dm.fptr.open;
 dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_SUM, 100.00);
 r:=dm.fptr.cashOutcome;
  dm.fptr.close;
 Atol_v10_SetErrorInLog(r,'Atol10_cashOutcome ');
end;


   (* Маркировка  if ExistsMark then
  begin
    DataModuleUser.ATOL.setParam(1085, 'mdlp');
    s:= 'sid'+Markirovka_subject_id+'&';
    DataModuleUser.ATOL.setParam(1086, s);
  //          Showmessage(s);
    DataModuleUser.ATOL.utilFormTlv;
    userAttribute := DataModuleUser.ATOL.getParamByteArray(DataModuleUser.ATOL.LIBFPTR_PARAM_TAG_VALUE);
  //???  DataModuleUser.ATOL.setNonPrintableParam(1084, userAttribute);
    r := DataModuleUser.ATOL.setParam(1084, userAttribute);
    if r<>0 then
    begin
      ShowMessage ('Ошибка '+IntToStr(DataModuleUser.Atol.errorCode)+'  ' +DataModuleUser.Atol.errorDescription);
      Result := False;
      Exit;
    end;*)

{==Печать НДС на чеке}
function Atol_v10_SetTaxMode(const cdtax_val:variant):double;
var nmTax, str :string;
  res: double;
  r,cd : integer;
begin
str:='';
nmTax:='без налога';
res:=0;
cd:=0;
if cdtax_val <> null then
   begin
     try
      nmTax := dm.qsltax_cd.Lookup('cdtax',cdtax_val,'nmtax');
      cd    :=cdtax_val;
     except on e:exception do
      begin
        SaveLogPlut('652 Atol_v10_SetTaxMode  '+e.Message +#13+cdtax_val);

      end;

     end;
   end;
//  else  cd:=0; 
SaveLogPlut('=== 658  Atol_v10_SetTaxMode  ====== '+ FloatToStr(cdtax_val));
   //   nmTax := dm.qsltax_cd.Lookup('cdtax',cdtax_val,'nmtax');
          
   if (AnsiLowerCase(nmTax)='без налога') or (AnsiLowerCase(nmTax)='без ндс') then
      begin
       r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_NO);
       str:='LIBFPTR_TAX_NO';
      end;
   if AnsiLowerCase(nmTax)='ндс 0%' then
      begin
        r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT0);  
        str:='LIBFPTR_TAX_VAT0';
      end; 
   if AnsiLowerCase(nmTax)='ндс 10%' then
      begin
       r:= dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT10);  
        str:='LIBFPTR_TAX_VAT10';
        res:=0.1;
      end; 
  if AnsiLowerCase(nmTax)='ндс 20%' then
      begin
        r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT20 );  
        str:='LIBFPTR_TAX_VAT20';
        res:=0.2;
      end;  
  if AnsiLowerCase(nmTax)='ндс с рассчитаной ставкой 10% ' then
      begin
        r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
        str:='LIBFPTR_TAX_VAT110';
        res:=0.1;
      end;    
   if AnsiLowerCase(nmTax)='ндс с рассчитаной ставкой 20%  ' then
     begin
       r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
       str:='LIBFPTR_TAX_VAT120';
       res:=0.2;
    end;     
     Atol_v10_SetErrorInLog(r,'Atol_v10_SetTaxMode');       
      SaveLogPlut('Налог cdTax= '+IntToStr(cd)+' - '+nmTax+' par= '+str+' нал= '+ FloatTostr(res) );
 Result:=res;                                                    
end;    




{==Печать НДС на чеке}
function Atol_v10_SetTaxMode_test(const cdtax_val:variant):double;
var nmTax, str :string;
  res: double;
  cd:integer;
begin
str:='';
nmTax:='без налога';
res:=0;
if cdtax_val <> null then
   begin
      nmTax := dm.qsltax_cd.Lookup('cdtax',cdtax_val,'nmtax');
      cd    :=cdtax_val;
   end
  else cd:=0;    
      
          
   if (AnsiLowerCase(nmTax)='без налога') or (AnsiLowerCase(nmTax)='без ндс') then
      begin
    //   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_NO);
       str:='LIBFPTR_TAX_NO';
      end;
   if AnsiLowerCase(nmTax)='ндс 0%' then
      begin
       // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT0);  
        str:='LIBFPTR_TAX_VAT0';
      end; 
   if AnsiLowerCase(nmTax)='ндс 10%' then
      begin
       // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT10);  
        str:='LIBFPTR_TAX_VAT10';
        res:=0.1;
      end; 
  if AnsiLowerCase(nmTax)='ндс 20%' then
      begin
      //  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT20 );  
        str:='LIBFPTR_TAX_VAT20';
        res:=0.2;
      end;  
  if AnsiLowerCase(nmTax)='ндс с рассчитаной ставкой 10% ' then
      begin
      //  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
        str:='LIBFPTR_TAX_VAT110';
        res:=0.1;
      end;    
   if AnsiLowerCase(nmTax)='ндс с рассчитаной ставкой 20%  ' then
     begin
    //   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
       str:='LIBFPTR_TAX_VAT120';
       res:=0.2;
    end;            
      SaveLogPlut('Налог cdTax= '+ intTostr(cd)+' - '+nmTax+' par= '+str+' нал= '+ FloatTostr(res) );
 Result:=res;                                                    
end;    




{=Печать чеков по новому формату }
function PrintCheck_Atol_v10_105_old( const check: string;
                                    const CustomerEmail: string;
                                    OperType: integer;{>0 приход}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer;pPay_packed: TPay_packed ) : Boolean;
var
  r, length_, NumberError, ncheck
  ,ncheckLog,kol,inx,systnal : integer;
  prom,str,strPay,nmtax: string;
  sumch,cenaproc: double;
  cena,sum_p, tax :double;
begin

if check<>'' then Atol_v10_PrintBankSlip(check);/// для кассира чек с отрезкой
 try
  Result := False;
  SaveLogPlut('================ 659 v10 формат 1.051=================================== ');  
    //Открытие соединения с ккт
  dm.fptr.open;


        //Запрос параметров
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   nomcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   nomcheck:=nomcheck+1;
   SaveLogPlut('Номер чека= '+IntToStr(nomcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('Номер Фиск.Док= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

 //Регистрация кассира
    Atol_v10_SetKassir_Inn;
    SaveLogPlut('660');  
//тип чека
   case OperType of
     1: begin
         if (Doplata=1 ) then strPay:=' _Доплата_ ' 
           else  strPay:=' _Оплата_ ';
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL);
          SaveLogPlut(' 671 OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL  продажа'); 
        end;
     2: begin
         strPay:=' _Возврат_';
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL_RETURN); 
         SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  возврат');                     
        end;
   end;

   sumch := 0;
   kol:=0;     
  if check<>'' then
         begin
         {== для пин падов}
          // SaveLogPlut('==== печатаем чек оплаты на ккт ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END печатаем чек оплаты на ккт ===============');
         end;      
 
  {=  отправка электронного чека}
  if CustomerEmail<>'' then
     begin
       SaveLogPlut('692 Почта ');
       r:=dm.fptr.setParam(1008, CustomerEmail);
   	    // передача почты или абонентского номера
       SaveLogPlut('698 Почта AttrNumber := 1008  AttrValue:='+CustomerEmail);
     if r<>0 then
        begin
          Atol_v10_SetErrorInLog(r,'CustomerEmail');
          ShowMessage('702 Ошибка CustomerEmail  смотри лог ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= Применяемая система налогооблажения в чеке:  в форме настройка ККТ}
 //  dm.fptr.AttrNumber:=1055;
    systnal:=Atol.TaxSystemNalog+1;
    case systnal of
    -1:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_DEFAULT);
           str:='LIBFPTR_TT_DEFAULT';
         end;
      1:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_OSN);
            str:='LIBFPTR_TT_OSN';
          end;  
      2:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME);
           str:='LIBFPTR_TT_USN_INCOME'
          end;
      3:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME_OUTCOME);
            str:='LIBFPTR_TT_USN_INCOME_OUTCOME'
          end;  
      4:  begin
           r:= dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_ENVD);
           str:= 'LIBFPTR_TT_ENVD';
          end; 
    end;
    SaveLogPlut('Система налогооблажения CНО :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 739 Send Система налогооблажения: ');

    r :=  dm.fptr.openReceipt;
       SaveLogPlut('==== dm.fptr.openReceipt ');
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= dm.fptr.cancelReceipt;
      Result:=False;
      exit;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('Ошибка cancelReceipt смотри лог ');
       end; 
    end;    
   
  SaveLogPlut('===========Регистрация продажи  ==============================');
  SaveLogPlut(' dataset.RecordCount= ' + IntToStr(dataset.RecordCount) +#13+
                ' Summa= ' + FloatTostr(Summa) +' SumAll= ' + FloatTostr(SumAll) +#13+
                ' Doplata ' +IntToStr(Doplata)   );
                    SaveLogPlut(dataset.Name +' dataset.RecordCount='+IntTostr(dataset.RecordCount));
 if (dataset.RecordCount>0) and (Doplata=0)      then
    begin
       DataSet.First;
       While not DataSet.Eof do
        begin
         ////////старый формат     в платных
         if nastrList.Values['NewFormat']='0' then
          begin
           SaveLogPlut(' nastrList.Values[NewFormat]=0'); 
           if (dataset.fieldbyname('cddocvoz_dopl').Value= cddoc) and
                (sl.Find(dataset.fieldbyname('cd').Value,inx) ) then
               begin
                 sumch := sumch +  Math.RoundTo(dataset.fieldbyname('uslugVozvrSum').Value,-2); 
                 kol:=  dataset.fieldbyname('kolvoVozv_Dopl').Value;
                end 
             else
               if sl.Count=0 then
                begin
                 sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
                 kol:=  dataset.fieldbyname('KOLVO').Value;
                end;
             end;      ///////// старый формат платежей в платных  
              ///////// НОВЫЙ формат платежей в платных 
             // if sl.Count=0 then
            if nastrList.Values['NewFormat']='1' then
               begin
                 sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
                 kol:=  dataset.fieldbyname('KOLVO').Value;
               end;
          
         // kol:=dataset.FieldByName('kolvo').AsInteger;
            // Регистрация товара или услуги
     
          prom :=  '';
         if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
             prom := dataset.fieldbyname('nmusl').Value;
         // prom := dataset.fieldbyname('nmusl').Value;
                     //отдел
                      //1212          	Признак предмета расчета
              dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
              //1214  	Признак способа расчета
            //  dm.fptr.setParam(1214, 4);     //16.06.2021
            if pPay_packed.cdpayment>0 then
               begin
                case pPay_packed.cdpayment of
                 0,4: begin
                      dm.fptr.setParam(1214,4);   // Только для ФФД 1.05. 4-Полный расчет
                      SaveLogPlut('--- 4 Признак способа расчета (Полный расчет');
                     end;
                  3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //Авансовый
                       else     dm.fptr.setParam(1214,4);         
                        SaveLogPlut('--- 3 Признак способа расчета (Авансовый платеж');
                       end;   
                  1: begin
                      
                      dm.fptr.setParam(1214,1);    
                      SaveLogPlut('--- 1 Признак способа расчета (ПРЕДОПЛАТА 100 ');
                   end;
                end;   
      

          
              // cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
               cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
               cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);
              if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
                sum_p:= cena*kol;
                 SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) ); 
           //  dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, sum_p);
               tax:=0;
              tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
              // sumch := sumch +  Math.RoundTo(fieldbyname('uslugVozvrSum').Value,-2); 
           
                  SaveLogPlut('усл. '+prom+'  cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                          +'sum_p= '+FloatToStr(sum_p) + ' налог= ' +floatTostr(summa*tax)); 
                                                 
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 941 registration');
            if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration str='+str);
              //ShowMessage ('Ошибка '+str);  07/07/2021
              Result := False;
              Exit;
            end;
          
   
            Dataset.NEXT;
        end; //while
      //end; // with
    end;
         // для доплаты или если выбрано без разбивки по услугам
       if (ATOL.Collapse = 1)or(Doplata=1) then
         begin
           SaveLogPlut('==Doplata   == V_10  '); 
           // Регистрация товара или услуги
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	Признак предмета расчета
           dm.fptr.setParam(1212, 4);   //Признак предмета расчёта	4 - услуга
           //1214  	Признак способа расчета
                
         //  dm.fptr.setParam(1214, 4);  16/06/2021
            if pPay_packed.cdpayment>0 then
               begin
                case pPay_packed.cdpayment of
                 0,4: begin
                    dm.fptr.setParam(1214,4);   // Только для ФФД 1.05. 4-Полный расчет
                     SaveLogPlut('--- 4 Признак способа расчета (Полный расчет');
                  end;
                 3: begin
                  if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //Авансовый
                   else     dm.fptr.setParam(1214,4);         
                     SaveLogPlut('--- 3 Признак способа расчета (Авансовый платеж');
                    end;   
               (* 1: begin
                      
                      dm.fptr.setParam(1214,1);    
                  SaveLogPlut('--- 1 Признак способа расчета (ПРЕДОПЛАТА 100 ');
                 end; *)  
                end;
               end;

               
              
            end;
           cena:=summa;
           kol:=1;
      
                
            // dm.fptr.Quantity := kol; //fieldbyname('KOLVO').Value;
             //dm.fptr.Price    := cena;
            // dm.fptr.summ     := cena*kol;  ///????? окруление 
            sum_p:= cena*kol;
           //  dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
          
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );  //перенос по словам
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
            tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            sumch := sum_p;
                SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                     +'summa= '+FloatToStr(summa)+ ' налог= ' +floattostr(summa*tax));                                       
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 990 registration');
            if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
                  Atol_v10_SetErrorInLog(r,' 990 registration  str='+str);
             // ShowMessage ('Ошибка '+str);
              Result := False;
              Exit;
            end; 
               SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(summa));    
         end; 
   //   end; // with
  //  end;    06/08/2020
//закрыть чек
	if BezNal=true then 
       begin 
         SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 
        // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,1);
         //  SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE =1 ');

       end
    else  
       begin
        SaveLogPlut('! BezNal=False наличка LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // наличка
         // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
                dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
         //  SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE =0 ');

       end;
   
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
   SaveLogPlut('  end == oplata   ==  ;sumch= '+floatTostr(sumch));   
    
   r:= dm.fptr.payment;
      Atol_v10_SetErrorInLog(r,'payment');
   {== слип -чек для клиента }
          {= чек из постерминала}
    if check<>'' then
      begin
         SaveLogPlut(' = чек из постерминала для клиента'); 
        dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
         r:= dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog(r,'setFooterLines');
        SaveLogPlut(check); 
      end;
    // Закрытие чека
     r:=dm.fptr.closeReceipt;
     //showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog(r,'closeReceipt');
    if r<> 0 then 
      begin 
        showmessage('ошибка closeReceipt rjl:'+IntTostr(r));
         result:=false;
         exit;
      end
      else result:=true;
 		//Sleep(1500);
    Atol_v10_CheckDocumentClose;
        //закрытие соединения с ккт
    sleep(5);
    dm.fptr.close;  //???
    SaveLogPlut(' CloseCheck ' );
    SaveLogPlut(' Конец чека'+strPay );
       {= чек из постерминала}
    (*if check<>'' then
      begin
        dm.fptr.Caption:=check;
        dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)


   SaveLogPlut('================формат old_105 end=================================== ');        

  SaveLogPlut('PrintCheck_atol_ end конец cddoc= ' +  IntToStr(cddoc));
 


  except on e: exception do
    begin
     // showmessage('Ошибка: '+ e.Message);
      SaveLogPlut('Ошибка: '+ e.Message);
       r:=dm.fptr.cancelReceipt;
       dm.fptr.close;
       Atol_v10_SetErrorInLog(r,' 935 dm.fptr.cancelReceipt');
      Result:=False;
    end;
  end;
end;



{=Печать чеков по новому формату }
function PrintCheck_Atol_v10_1_051_new( const check: string;
                                    const CustomerEmail: string;
                                    OperType: integer;{>0 приход}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer;pPay_packed: TPay_packed ) : Boolean;
var
  r, length_, NumberError, ncheck
  ,ncheckLog,kol,inx,systnal : integer;
  prom,str,strPay,nmtax: string;
  sumch,cenaproc: double;
  cena,sum_p, tax :double;
begin

if check<>'' then Atol_v10_PrintBankSlip(check);/// для кассира чек с отрезкой
 try
  Result := False;
  SaveLogPlut('================ 659 v10 формат 1.051=================================== ');  
    //Открытие соединения с ккт
  dm.fptr.open;

    //Запрос параметров
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   nomcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   nomcheck:=nomcheck+1;
   SaveLogPlut('Номер чека= '+IntToStr(nomcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('Номер Фиск.Док= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

 //Регистрация кассира
    Atol_v10_SetKassir_Inn;
    SaveLogPlut('660');  
//тип чека
   case OperType of
     1: begin
         if (Doplata=1 ) then strPay:=' _Доплата_ ' 
           else  strPay:=' _Оплата_ ';
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL);
          SaveLogPlut(' 671 OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL  продажа'); 
        end;
     2: begin
         strPay:=' _Возврат_';
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL_RETURN); 
         SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  возврат');                     
        end;
   end;

   sumch := 0;
   kol:=0;     
 // if check<>'' then
       //  begin
         {== для пин падов}
          // SaveLogPlut('==== печатаем чек оплаты на ккт ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END печатаем чек оплаты на ккт ===============');
       //  end;      
 
  {=  отправка электронного чека}
  if CustomerEmail<>'' then
     begin
       SaveLogPlut('692 Почта ');
       r:=dm.fptr.setParam(1008, CustomerEmail);
   	    // передача почты или абонентского номера
       SaveLogPlut('698 Почта AttrNumber := 1008  AttrValue:='+CustomerEmail);
       if r<>0 then
        begin
          Atol_v10_SetErrorInLog(r,'CustomerEmail');
          ShowMessage('702 Ошибка CustomerEmail  смотри лог ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= Применяемая система налогооблажения в чеке:  в форме настройка ККТ}
 //  dm.fptr.AttrNumber:=1055;
    systnal:=Atol.TaxSystemNalog+1;
    case systnal of
    -1:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_DEFAULT);
           str:='LIBFPTR_TT_DEFAULT';
         end;
      1:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_OSN);
            str:='LIBFPTR_TT_OSN';
          end;  
      2:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME);
           str:='LIBFPTR_TT_USN_INCOME'
          end;
      3:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME_OUTCOME);
            str:='LIBFPTR_TT_USN_INCOME_OUTCOME'
          end;  
      4:  begin
           r:= dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_ENVD);
           str:= 'LIBFPTR_TT_ENVD';
          end; 
    end;
    SaveLogPlut('Система налогооблажения CНО :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 739 Send Система налогооблажения: ');

     {=Печатать\не печать чек на ккт}
   if pPay_packed.isPrintCheck=False then
    begin
       SaveLogPlut('==== 1496 Чек печатать Нет isPrintCheck=Fflse ');
      dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY, pPay_packed.isPrintCheck);
    end;

    r :=  dm.fptr.openReceipt;
       SaveLogPlut('==== dm.fptr.openReceipt ');
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= dm.fptr.cancelReceipt;
      Result:=False;
      exit;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('Ошибка cancelReceipt смотри лог ');
       end; 
    end;    
   
  SaveLogPlut('===========Регистрация продажи  ==============================');
  SaveLogPlut(' dataset.RecordCount= ' + IntToStr(dataset.RecordCount) +#13+
                ' Summa= ' + FloatTostr(Summa) +' SumAll= ' + FloatTostr(SumAll) +#13+
                ' Doplata ' +IntToStr(Doplata)   );
                    SaveLogPlut(dataset.Name +' dataset.RecordCount='+IntTostr(dataset.RecordCount));
 if (dataset.RecordCount>0) and (Doplata=0)      then
    begin
       DataSet.First;
       While not DataSet.Eof do
        begin
          sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
          kol:=  dataset.fieldbyname('KOLVO').Value;

         if (dataset.fieldbyname('cddocvoz_dopl').Value= cddoc) and
                (sl.Find(dataset.fieldbyname('cd').Value,inx) ) then
               begin
                 sumch := sumch +  Math.RoundTo(dataset.fieldbyname('uslugVozvrSum').Value,-2); 
                 kol:=  dataset.fieldbyname('kolvoVozv_Dopl').Value;
                end 
             else
               if sl.Count=0 then
                begin
                 sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
                 kol:=  dataset.fieldbyname('KOLVO').Value;
                end;

          
          // Регистрация товара или услуги
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
             prom := dataset.fieldbyname('nmusl').Value;
            //отдел 1212          	Признак предмета расчета
            
          dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
              //1214  	Признак способа расчета
            //  dm.fptr.setParam(1214, 4);     //16.06.2021
            //if pPay_packed.cdpayment>0 then
               //begin
            case pPay_packed.cdpayment of
                 0,4: begin
                      dm.fptr.setParam(1214,4);   // Только для ФФД 1.05. 4-Полный расчет
                      SaveLogPlut('--- 4 Признак способа расчета (Полный расчет');
                     end;
                  3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //Авансовый
                       else     dm.fptr.setParam(1214,4);         
                        SaveLogPlut('--- 3 Признак способа расчета (Авансовый платеж');
                     end;   
                  1: begin
                      dm.fptr.setParam(1214,1);    
                      SaveLogPlut('--- 1 Признак способа расчета (ПРЕДОПЛАТА 100 ');
                   end;
              end;
             
              // cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
              cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
              cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);
              if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
              sum_p:= cena*kol;
              SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) ); 
        
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, sum_p);
               tax:=0;
              tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
              // sumch := sumch +  Math.RoundTo(fieldbyname('uslugVozvrSum').Value,-2); 
           
              SaveLogPlut('усл. '+prom+'  cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                          +'sum_p= '+FloatToStr(sum_p) + ' налог= ' +floatTostr(summa*tax)); 
                                                 
              r  :=  dm.fptr.registration;
              Atol_v10_SetErrorInLog(r,' 941 registration');
              if r<>0 then
               begin
                 str:= Atol_v10_SetErrorInLog(r,'registration str='+str);
                //ShowMessage ('Ошибка '+str);  07/07/2021
                 Result := False;
                 Exit;
               end;
          
   
            Dataset.NEXT;
        end; //while
    end;//if
    
         // для доплаты или если выбрано без разбивки по услугам
   if (ATOL.Collapse = 1)or(Doplata=1) then
      begin
           SaveLogPlut('==Doplata   == V_10  '); 
           // Регистрация товара или услуги
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	Признак предмета расчета
           dm.fptr.setParam(1212, 4);   //Признак предмета расчёта	4 - услуга
           //1214  	Признак способа расчета
                
         //  dm.fptr.setParam(1214, 4);  16/06/2021
           // if pPay_packed.cdpayment>0 then
           //    begin
                case pPay_packed.cdpayment of
                 0,4:
                  begin
                     dm.fptr.setParam(1214,4);   // Только для ФФД 1.05. 4-Полный расчет
                     SaveLogPlut('--- 4 Признак способа расчета (Полный расчет');
                  end;
                 3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                                       dm.fptr.setParam(1214,3)    //Авансовый
                      else     dm.fptr.setParam(1214,4);         
                      SaveLogPlut('--- 3 Признак способа расчета (Авансовый платеж');
                   end;   
                     (* 1: begin
                          dm.fptr.setParam(1214,1);    
                         SaveLogPlut('--- 1 Признак способа расчета (ПРЕДОПЛАТА 100 ');
                       end; *)  
                 end;
 
           cena:=summa;
           kol:=1;
            sum_p:= cena*kol;
           //  dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
          
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );  //перенос по словам
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
            tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            sumch := sum_p;
                SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                     +'summa= '+FloatToStr(summa)+ ' налог= ' +floattostr(summa*tax));                                       
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 990 registration');
            if r<>0 then
             begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
                  Atol_v10_SetErrorInLog(r,' 990 registration  str='+str);
             // ShowMessage ('Ошибка '+str);
               Result := False;
               Exit;
             end; 
               SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(summa));    
      end; 
//закрыть чек
	if BezNal=true then 
       begin 
         SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 
        // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         //  SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE =1 ');

       end
    else  
       begin
        SaveLogPlut('! BezNal=False наличка LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // наличка
         // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
                dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
         //  SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE =0 ');

       end;
   
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
   SaveLogPlut('  end == oplata   ==  ;sumch= '+floatTostr(sumch));   
    
   r:= dm.fptr.payment;
      Atol_v10_SetErrorInLog(r,'payment');
   {== слип -чек для клиента }
          {= чек из постерминала}
    if check<>'' then
      begin
         SaveLogPlut(' = чек из постерминала для клиента'); 
        dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
         r:= dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog(r,'setFooterLines');
        SaveLogPlut(check); 
      end;
    // Закрытие чека
     r:=dm.fptr.closeReceipt;
     //showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog(r,'closeReceipt');
    if r<> 0 then 
      begin 
        showmessage('ошибка closeReceipt rjl:'+IntTostr(r));
         result:=false;
         exit;
      end
      else result:=true;
 		//Sleep(1500);
    Atol_v10_CheckDocumentClose;
        //закрытие соединения с ккт
    sleep(5);
    dm.fptr.close;  //???
    SaveLogPlut(' CloseCheck ' );
    SaveLogPlut(' Конец чека'+strPay );
       {= чек из постерминала}
    (*if check<>'' then
      begin
        dm.fptr.Caption:=check;
        dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)


   SaveLogPlut('================формат new_1.051 end=================================== ');        

  SaveLogPlut('PrintCheck_atol_ end конец cddoc= ' +  IntToStr(cddoc));
 


  except on e: exception do
    begin
     // showmessage('Ошибка: '+ e.Message);
      SaveLogPlut('Ошибка: '+ e.Message);
       r:=dm.fptr.cancelReceipt;
       dm.fptr.close;
       Atol_v10_SetErrorInLog(r,' 935 dm.fptr.cancelReceipt');
      Result:=False;
    end;
  end;
end;



{===================тест======================}


{=Печать чеков по новому формату }

function PrintCheck_Atol_v10_1_051_new_test( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 приход}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                      ;pPay_packed: TPay_packed ) : Boolean;
var
  r, length_, NumberError, ncheck
  ,ncheckLog,kol,inx,systnal : integer;
  prom,str,strPay,nmtax: string;
  sumch,cenaproc: double;
  cena,sum_p, tax :double;
begin

if check<>'' then Atol_v10_PrintBankSlip(check);/// для кассира чек с отрезкой

  Result := False;
  SaveLogPlut('================v10 формат 1.051 test=================================== ');  
    //Открытие соединения с ккт
  //dm.fptr.open;
  //Регистрация кассира
  //  Atol_v10_SetKassir_Inn;
  // SaveLogPlut('==='+CustomerEmail);
//тип чека
   case OperType of
     1: begin
         if (Doplata=1 ) then strPay:=' _Доплата_ ' 
           else  strPay:=' _Оплата_ ';
         
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL           );
          SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL  продажа'); 
        end;
     2: begin
         strPay:=' _Возврат_';
      
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL_RETURN                   ); 
         SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  возврат');                     
        end;
   end;
   
   sumch := 0;
   kol:=0;     
  if check<>'' then
         begin
         {== для пин падов}
          // SaveLogPlut('==== печатаем чек оплаты на ккт ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END печатаем чек оплаты на ккт ===============');
         end;      
 
  {=  отправка электронного чека}
  if CustomerEmail<>'' then
     begin
  //    r:=dm.fptr.setParam(1008, CustomerEmail);
   	 // передача почты или абонентского номера
      SaveLogPlut('Почта AttrNumber := 1008  AttrValue:='+CustomerEmail);
   	
      if r<>0 then
        begin
          Atol_v10_SetErrorInLog_test(r,'CustomerEmail');
          ShowMessage('Ошибка CustomerEmail  смотри лог ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= Применяемая система налогооблажения в чеке:  в форме настройка ККТ}
 
   //dm.fptr.AttrNumber:=1055;
     systnal:=Atol.TaxSystemNalog+1;
    case systnal of
    -1:  begin
           //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_DEFAULT);
           str:='LIBFPTR_TT_DEFAULT';
         end;
      1:  begin
            //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_OSN);
            str:='LIBFPTR_TT_OSN';
          end;  
      2:  begin
           //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_USN_INCOME);
           str:='LIBFPTR_TT_USN_INCOME'
          end;
      3:  begin
            //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_USN_INCOME_OUTCOME);
            str:='LIBFPTR_TT_USN_INCOME_OUTCOME'
          end;  
      4:  begin
           //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_ENVD);
           str:= 'LIBFPTR_TT_ENVD';
          end; 
    end;
    SaveLogPlut('Система налогооблажения CНО :'+str+' '+ IntToStr(systnal));
  //  SaveLogPlut('==== Send Система налогооблажения: ('+IntToStr( //dm.fptr.ErrorCode)+'): '+dm.fptr.ResultCodeDescription);

     Atol_v10_SetErrorInLog_test(1,'openReceipt');
   
  (*//r :=  dm.fptr.openReceipt;
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= //dm.fptr.cancelReceipt;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('Ошибка cancelReceipt смотри лог ');
       end; 
    end; *)   
   //Запрос параметров
 //dm.fptr.setParam( //dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  //dm.fptr.LIBFPTR_DT_STATUS);
 //dm.fptr.queryData;


  SaveLogPlut('===========Регистрация продажи   ==============================');
  SaveLogPlut(' dataset.RecordCount= ' + IntToStr(dataset.RecordCount) +#13+
                ' Summa= ' + FloatTostr(Summa) +' SumAll= ' + FloatTostr(SumAll) +#13+
                ' Doplata ' +IntToStr(Doplata)   );
                  SaveLogPlut(dataset.Name);
 if (dataset.RecordCount>0) and (Doplata=0)    then
    begin
    // with DataSet do
    //  begin
       DataSet.First;
       While not DataSet.Eof do
        begin
         // kol:=dataset.FieldByName('kolvo').AsInteger;
            // Регистрация товара или услуги
                     ////////старый формат     в платных
 
              SaveLogPlut( 'nastrList.Values[NewFormat]=0');
              (* if (dataset.fieldbyname('cddocvoz_dopl').Value= cddoc) and
                (sl.Find(dataset.fieldbyname('cd').Value,inx) ) then
               begin
                 sumch := sumch +  Math.RoundTo(dataset.fieldbyname('uslugVozvrSum').Value,-2); 
                 kol:=  dataset.fieldbyname('kolvoVozv_Dopl').Value;
                end 
             else
              if sl.Count=0 then
               begin
                 sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
                 kol:=  dataset.fieldbyname('KOLVO').Value;
               end; *)
  
       
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
          
             prom := dataset.fieldbyname('nmusl').Value;
                     //отдел
        //  cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
          cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
          cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);

           
          if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
                         
             sum_p:= cena*kol;
             
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) );          
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                          +' sum_p= '+FloatToStr(sum_p) + ' налог= ' +floatTostr(summa*tax)); 
                                                 
            //r  :=  //dm.fptr.registration;

            (*if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
              ShowMessage ('Ошибка '+str);
              Result := False;
              Exit;
            end;  *)
             
            /// //dm.fptr.Taxtypenumber :=ATOL.cdTax;  //  Без НДС - из настройки
        
           // Наименование услуги для каждой строки UslNameForCheck
           // В ЧЕК 
            //  //dm.fptr.TextWrap:=2;
           // Перенос по строке-в каждой строке печатается максимально возможное количество символов
            //   //dm.fptr.Name:=prom; 
            SaveLogPlut(' 1118'+prom);
             //  SaveLogPlut(' EndItem ');
             //  //dm.fptr.EndItem;        
            Dataset.NEXT;
        end; //while
      //end; // with
    end;
         // для доплаты или если выбрано без разбивки по услугам
        if (ATOL.Collapse = 1)or(Doplata=1) then
         begin
           SaveLogPlut('1128 ==Doplata   == V_10  '); 
           // Регистрация товара или услуги
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	Признак предмета расчета
           //dm.fptr.setParam(1212, 4);   //Признак предмета расчёта	4 - услуга
           //1214  	Признак способа расчета
           //dm.fptr.setParam(1214, 4);
           cena:=summa;
           kol:=1;
      
 
            // //dm.fptr.Quantity := kol; //fieldbyname('KOLVO').Value;
             //dm.fptr.Price    := cena;
            // //dm.fptr.summ     := cena*kol;  ///????? окруление 
            sum_p:= cena*kol;
            sumch:=sum_p;   
           //  //dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,atol.Section);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, //dm.fptr.LIBFPTR_TW_WORDS );  //перенос по словам
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('1153 '+prom); 
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
               +' summa= '+FloatToStr(summa)+ ' налог= ' +floattostr(summa*tax));                                       
            r  := 0; //dm.fptr.registration;
           SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(summa));    
         end; 
   //   end; // with
  //  end;    06/08/2020
//закрыть чек
	if BezNal=true then 
       begin 
         SaveLogPlut(' 1164 BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '); 
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, //dm.fptr.LIBFPTR_PT_ELECTRONICALLY)

       end
    else  
       begin
        SaveLogPlut('BezNal=False наличка LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // наличка
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, //dm.fptr.LIBFPTR_PT_CASH)

       end;
   
    //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
    //dm.fptr.payment;
            SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(sumch)); 
   {== слип -чек для клиента }
          {= чек из постерминала}
    if check<>'' then
      begin
        //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
     //  r:= //dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog_test(r,'setFooterLines');
         SaveLogPlut(check); 
      end;
    // Закрытие чека
    //r:=dm.fptr.closeReceipt;
    // showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog_test(r,'closeReceipt');
     result:=true;

		//Sleep(1500);
    //Atol_v10_CheckDocumentClose;
        //закрытие соединения с ккт
      //  sleep(10);
    //dm.fptr.close;  //???
       
     SaveLogPlut(' CloseCheck ' );

    SaveLogPlut(' Конец чека'+strPay );
       {= чек из постерминала}
    (*if check<>'' then
      begin
        //dm.fptr.Caption:=check;
        //dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)

//!!!!
   SaveLogPlut('================формат new_1.051_test end=================================== ');        
   nomcheck:=cddoc;
   
  SaveLogPlut('PrintCheck_atol_ end ' +  IntToStr(cddoc));
end;


{}
{=Печать чеков по новому формату  ===    СмешОплата}
function PrintCheck_Atol_v1_05_smesh( const slip_check: string;
                                         DataSet: TDataSet;
                                         var nomcheck:Integer; var FNDoc: integer; 
                                         pPay_packed: TPay_packed ) : Boolean;
var
  r, ncheck  ,kol ,systnal: integer;
  prom,strPay,str: string;
  sumch,cenaproc: double;
  cena,sum_p, tax :double;
begin
  SaveLogPlut(' ****** PrintCheck_Atol_v1_05_smesh **** ');
if slip_check<>'' then Atol_v10_PrintBankSlip(slip_check);/// для кассира чек с отрезкой
 try
  Result := False;
  SaveLogPlut('================ 659 v10 формат 1.051=================================== ');  
    //Открытие соединения с ккт
  dm.fptr.open;

    //Запрос параметров
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   nomcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   nomcheck:=nomcheck+1;
   SaveLogPlut('Номер чека= '+IntToStr(nomcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('Номер Фиск.Док= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

 //Регистрация кассира
    Atol_v10_SetKassir_Inn;
    SaveLogPlut('660');  
//тип чека
   case pPay_packed.opertype of
     1: begin
         if (pPay_packed.Doplata=1 ) then strPay:=' _Доплата_ ' 
           else  strPay:=' _Оплата_ ';
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL);
          SaveLogPlut(' 671 OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL  продажа'); 
        end;
     2: begin
         strPay:=' _Возврат_';
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL_RETURN); 
         SaveLogPlut('OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  возврат');                     
        end;
   end;

 //  sumch := 0;
   kol:=0;     
 // if slip_check<>'' then
 //        begin
         {== для пин падов}
          // SaveLogPlut('==== печатаем чек оплаты на ккт ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END печатаем чек оплаты на ккт ===============');
     //    end;      
 
  {=  отправка электронного чека}
  if pPay_packed.CustomerEmail<>'' then
     begin
       SaveLogPlut('692 Почта ');
       r:=dm.fptr.setParam(1008, pPay_packed.CustomerEmail);
   	    // передача почты или абонентского номера
       SaveLogPlut('698 Почта AttrNumber := 1008  AttrValue:='+pPay_packed.CustomerEmail);
       if r<>0 then
        begin
          Atol_v10_SetErrorInLog(r,'CustomerEmail');
          ShowMessage('702 Ошибка CustomerEmail  смотри лог ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= Применяемая система налогооблажения в чеке:  в форме настройка ККТ}
 //  dm.fptr.AttrNumber:=1055;
    systnal:=Atol.TaxSystemNalog+1;
    case systnal of
    -1:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_DEFAULT);
           str:='LIBFPTR_TT_DEFAULT';
         end;
      1:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_OSN);
            str:='LIBFPTR_TT_OSN';
          end;  
      2:  begin
           r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME);
           str:='LIBFPTR_TT_USN_INCOME'
          end;
      3:  begin
            r:=dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_USN_INCOME_OUTCOME);
            str:='LIBFPTR_TT_USN_INCOME_OUTCOME'
          end;  
      4:  begin
           r:= dm.fptr.setParam(1055, dm.fptr.LIBFPTR_TT_ENVD);
           str:= 'LIBFPTR_TT_ENVD';
          end; 
    end;
    SaveLogPlut('Система налогооблажения CНО :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 739 Send Система налогооблажения: ');
    {=Печатать\не печать чек на ккт}
   if pPay_packed.isPrintCheck=False then
     begin
       SaveLogPlut('==== 2173 Чек печатать Нет isPrintCheck=Fflse ');
       dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_ELECTRONICALLY, pPay_packed.isPrintCheck);
     end;
    
    r :=  dm.fptr.openReceipt;
       SaveLogPlut('==== dm.fptr.openReceipt ');
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= dm.fptr.cancelReceipt;
      Result:=False;
      exit;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('Ошибка cancelReceipt смотри лог ');
       end; 
    end;    
   
  SaveLogPlut('===========Регистрация продажи  ==============================');
  SaveLogPlut(' dataset.RecordCount= ' + IntToStr(dataset.RecordCount) +#13+
                ' Summa= ' + FloatTostr(pPay_packed.Summa) +' SumAll= ' + FloatTostr(pPay_packed.SumAll) +#13+
                ' Doplata ' +IntToStr(pPay_packed.Doplata)   );
                    SaveLogPlut(dataset.Name +' dataset.RecordCount='+IntTostr(dataset.RecordCount));
 if (dataset.RecordCount>0) and (pPay_packed.Doplata=0)      then
    begin
       DataSet.First;
       While not DataSet.Eof do
        begin
                  
         sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
         kol:=  dataset.fieldbyname('KOLVO').AsInteger;
   
         // kol:=dataset.FieldByName('kolvo').AsInteger;
            // Регистрация товара или услуги
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
           else   
             prom := dataset.fieldbyname('nmusl').Value;
         // prom := dataset.fieldbyname('nmusl').Value;
                     //отдел
                      //1212          	Признак предмета расчета
            dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
              //1214  	Признак способа расчета
            //  dm.fptr.setParam(1214, 4);     //16.06.2021
      
                case pPay_packed.cdpayment of
                 0,4: begin
                      dm.fptr.setParam(1214,4);   // Только для ФФД 1.05. 4-Полный расчет
                      SaveLogPlut('--- 4 Признак способа расчета (Полный расчет');
                     end;
                  3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //Авансовый
                       else     dm.fptr.setParam(1214,4);         
                        SaveLogPlut('--- 3 Признак способа расчета (Авансовый платеж');
                       end;   
                  1: begin
                      
                      dm.fptr.setParam(1214,1);    
                      SaveLogPlut('--- 1 Признак способа расчета (ПРЕДОПЛАТА 100 ');
                  end;
                end;   
      
     
              // cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
           cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
           cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);
           if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
             sum_p:= cena*kol;
             SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) ); 
     
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, sum_p);
           tax:=0;
           tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
              // sumch := sumch +  Math.RoundTo(fieldbyname('uslugVozvrSum').Value,-2); 
           
            SaveLogPlut('усл. '+prom+'  cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                          +'sum_p= '+FloatToStr(sum_p) + ' налог= ' +floatTostr(pPay_packed.summa*tax)); 
                                                 
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 941 registration');
            if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration str='+str);
              //ShowMessage ('Ошибка '+str);  07/07/2021
              Result := False;
              Exit;
            end;
          Dataset.NEXT;
        end; //while

    end;
    
         // для доплаты или если выбрано без разбивки по услугам
if (ATOL.Collapse = 1)or(pPay_packed.Doplata=1) then
  begin
   SaveLogPlut('==Doplata   == V_10  '); 
   // Регистрация товара или услуги
   prom :=  '';
   prom := ATOL.CheckText;
   //1212          	Признак предмета расчета
   dm.fptr.setParam(1212, 4);   //Признак предмета расчёта	4 - услуга
   //1214  	Признак способа расчета
                
 //  dm.fptr.setParam(1214, 4);  16/06/2021
   
        case pPay_packed.cdpayment of
         0,4: begin
            dm.fptr.setParam(1214,4);   // Только для ФФД 1.05. 4-Полный расчет
             SaveLogPlut('--- 4 Признак способа расчета (Полный расчет');
          end;
         3: begin
             if nastrList.Values['Real_Avans_InPay']='1' then
                  dm.fptr.setParam(1214,3)    //Авансовый
                else     dm.fptr.setParam(1214,4);         
             SaveLogPlut('--- 3 Признак способа расчета (Авансовый платеж');
           end;   
           (* 1: begin
                      
              dm.fptr.setParam(1214,1);    
             SaveLogPlut('--- 1 Признак способа расчета (ПРЕДОПЛАТА 100 ');
              end; *)  
        end;
    cena:=pPay_packed.summa;
   kol:=1;

    sum_p:= cena*kol;
            
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );  //перенос по словам
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, pPay_packed.summa);
    tax:=0;
    tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
    sumch := sum_p;
      SaveLogPlut('2357  sumch='+FloatTostr(sumch));
 
        SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
             +'summa= '+FloatToStr(pPay_packed.summa)+ ' налог= ' +floattostr(pPay_packed.summa*tax));                                       
    r  :=  dm.fptr.registration;
    Atol_v10_SetErrorInLog(r,' 990 registration');
    if r<>0 then
    begin
      str:= Atol_v10_SetErrorInLog(r,'registration');
          Atol_v10_SetErrorInLog(r,' 990 registration  str='+str);
     // ShowMessage ('Ошибка '+str);
      Result := False;
      Exit;
    end; 
       SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(pPay_packed.summa));    
  end; 



//закрыть чек

   SaveLogPlut('2357 !!!!! printCheckOn_Atol_new sumAvans='+FloatTostr(pPay_packed.summaAvans)
      +'  sum_beznal='+FloatTostr(pPay_packed.summCard)+
       ' sum_nal= '+FloatTostr(pPay_packed.summCash)+#13+'pPay_packed.BezNal='+BoolToStr(pPay_packed.BezNal) );

  if pPay_packed.summCard>0 then
        begin
          SaveLogPlut(' 1164 BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '); 
          SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCard)); 
     
                  SaveLogPlut(' !BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,1);
       
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCard);
          r:= dm.fptr.payment;   
          Atol_v10_SetErrorInLog(r,'payment_summCard>'); 
        
         end;
  if pPay_packed.summCash>0 then
       begin   
         SaveLogPlut('BezNal=False наличка LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCash)); 
         // наличка
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
             
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCash);
          r:= dm.fptr.payment;   
          Atol_v10_SetErrorInLog(r,'payment_summCash>');
   
       end;     
        {=зачет аванса}
  if pPay_packed.summaAvans>0 then
       begin   
         SaveLogPlut('Авансом LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_PREPAID'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summaAvans)); 
         // наличка
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_PREPAID);
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summaAvans);
          r:= dm.fptr.payment;   
          Atol_v10_SetErrorInLog(r,'payment_summaAvans>');
       end;     
     
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
   SaveLogPlut('  end == oplata   ==  ;sumch= '+floatTostr(sumch));   
    
   r:= dm.fptr.payment;   //один раз!!!
   Atol_v10_SetErrorInLog(r,'payment_sumch');
  
   (*       {= чек из постерминала}   {== слип -чек для клиента }
    if slip_check<>'' then
      begin
         SaveLogPlut(' = чек из постерминала для клиента'); 
        dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, slip_check);
         r:= dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog(r,'setFooterLines');
        SaveLogPlut(slip_check); 
      end;  *)
    // Закрытие чека
     r:=dm.fptr.closeReceipt;
     //showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog(r,'closeReceipt');
    if r<> 0 then 
      begin 
        showmessage('ошибка closeReceipt :'+IntTostr(r));
         result:=false;
         r:=dm.fptr.cancelReceipt;
         Atol_v10_SetErrorInLog(r,'cancelReceipt');
         dm.fptr.close;
         exit;
      end
      else result:=true;
 		//Sleep(1500);
    Atol_v10_CheckDocumentClose;
        //закрытие соединения с ккт
    sleep(5);
    dm.fptr.close;  //???
    SaveLogPlut(' CloseCheck ' );
    SaveLogPlut(' Конец чека'+strPay );
       {= чек из постерминала}
    (*if check<>'' then
      begin
        dm.fptr.Caption:=check;
        dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)


   SaveLogPlut('================формат smesh_1.05 end=================================== ');        

  SaveLogPlut('PrintCheck_atol_ end конец cddoc= ' +  IntToStr(pPay_packed.pcddoc));
 
 except on e: exception do
    begin
     // showmessage('Ошибка: '+ e.Message);
      SaveLogPlut('Ошибка: '+ e.Message);
       r:=dm.fptr.cancelReceipt;
       dm.fptr.close;
       Atol_v10_SetErrorInLog(r,' 2416 dm.fptr.cancelReceipt');
      Result:=False;
    end;
  end;
end;




    {== Тест  
       только для оплаты через новую форму  смешанная оплата труда}                                           
function PrintCheck_Atol_v1_05_smesh_test(const slip_check: string;
                                         DataSet: TDataSet;
                                         var nomcheck:Integer; var FNDoc: integer; 
                                         pPay_packed: TPay_packed ) : Boolean;  
 var
  r  ,kol,inx,systnal : integer;
  prom,str,strPay: string;
  sumch,cenaproc: double;
  cena,sum_p, tax :double;
begin
    SaveLogPlut(' ****** PrintCheck_Atol_v1_05__smesh_test **** ');
if slip_check<>'' then Atol_v10_PrintBankSlip(slip_check);/// для кассира чек с отрезкой

  Result := False;
  SaveLogPlut('================v1 формат 1.05 новый формат платежей test=================================== ');  
    //Открытие соединения с ккт
  //dm.fptr.open;
  //Регистрация кассира
  //  Atol_v10_SetKassir_Inn;
  // SaveLogPlut('==='+CustomerEmail);
//тип чека

   case pPay_packed.OperType of
     1: begin
        // if (pPay_packed.Doplata=1 ) then strPay:=' продажа '              else  
           strPay:=' _Оплата_ ';
         
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL           );
          SaveLogPlut('OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL  продажа'); 
        end;
     2: begin
         strPay:=' _Возврат_';
      
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL_RETURN                   ); 
         SaveLogPlut('OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  возврат');                     
        end;
   end;
   
   sumch := 0;
   kol:=0;     
  if slip_check<>'' then
         begin
         {== для пин падов}
          // SaveLogPlut('==== печатаем чек оплаты на ккт ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END печатаем чек оплаты на ккт ===============');
         end;      
 
  {=  отправка электронного чека}
  if pPay_packed.CustomerEmail<>'' then
     begin
  //    r:=dm.fptr.setParam(1008, CustomerEmail);
   	 // передача почты или абонентского номера
      SaveLogPlut('Почта AttrNumber := 1008  AttrValue:='+pPay_packed.CustomerEmail);
   	
      if r<>0 then
        begin
          Atol_v10_SetErrorInLog_test(r,'CustomerEmail');
          ShowMessage('Ошибка CustomerEmail  смотри лог ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= Применяемая система налогооблажения в чеке:  в форме настройка ККТ}
 
   //dm.fptr.AttrNumber:=1055;
     systnal:=Atol.TaxSystemNalog+1;
    case systnal of
    -1:  begin
           //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_DEFAULT);
           str:='LIBFPTR_TT_DEFAULT';
         end;
      1:  begin
            //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_OSN);
            str:='LIBFPTR_TT_OSN';
          end;  
      2:  begin
           //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_USN_INCOME);
           str:='LIBFPTR_TT_USN_INCOME'
          end;
      3:  begin
            //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_USN_INCOME_OUTCOME);
            str:='LIBFPTR_TT_USN_INCOME_OUTCOME'
          end;  
      4:  begin
           //dm.fptr.setParam(1055, //dm.fptr.LIBFPTR_TT_ENVD);
           str:= 'LIBFPTR_TT_ENVD';
          end; 
    end;
    SaveLogPlut('Система налогооблажения CНО :'+str+' '+ IntToStr(systnal));
  //  SaveLogPlut('==== Send Система налогооблажения: ('+IntToStr( //dm.fptr.ErrorCode)+'): '+dm.fptr.ResultCodeDescription);

     Atol_v10_SetErrorInLog_test(1,'openReceipt');
   
  (*//r :=  dm.fptr.openReceipt;
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= //dm.fptr.cancelReceipt;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('Ошибка cancelReceipt смотри лог ');
       end; 
    end; *)   
   //Запрос параметров
 //dm.fptr.setParam( //dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  //dm.fptr.LIBFPTR_DT_STATUS);
 //dm.fptr.queryData;


  SaveLogPlut('===========Регистрация продажи   ==============================');
  SaveLogPlut(' dataset.RecordCount= ' + IntToStr(dataset.RecordCount) +#13+
                ' Summa= ' + FloatTostr(pPay_packed.Summa) +' SumAll= ' + FloatTostr(pPay_packed.SumAll) +#13+
                ' Doplata ' +IntToStr(pPay_packed.Doplata)   );
                  SaveLogPlut(dataset.Name);
 if (dataset.RecordCount>0) and (pPay_packed.Doplata=0)    then
    begin
       DataSet.First;
       While not DataSet.Eof do
        begin
         // kol:=dataset.FieldByName('kolvo').AsInteger;
            // Регистрация товара или услуги
           
         ///////// НОВЫЙ формат платежей в платных 
      
         SaveLogPlut( 'nastrList.Values[NewFormat]=1');
         sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
         kol:=  dataset.fieldbyname('KOLVO').Value;
         SaveLogPlut('=== услуги на чеке ===');
         kol:=0;
         sumch := sumch + Math.RoundTo(DataSet.fieldbyname('uslugSUM').Value,-2);
         kol:=  DataSet.fieldbyname('KOLVO').Value;
         prom :=  '';
         if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
             prom := dataset.fieldbyname('nmusl').Value;
         if prom='' then
           begin
             result:=false;
             showmessage(' Ошибка нет наименования услуги !');
             exit;
           end;
             
        
         ///////// НОВЫЙ формат платежей в платных 
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
          
             prom := dataset.fieldbyname('nmusl').Value;
                     //отдел
        //  cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
          cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
          cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);

           
          if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
                         
             sum_p:= cena*kol;
             
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) );          
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
                          +' sum_p= '+FloatToStr(sum_p) + ' налог= ' +floatTostr(pPay_packed.summa*tax)); 
                                                 
            //r  :=  //dm.fptr.registration;

            (*if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
              ShowMessage ('Ошибка '+str);
              Result := False;
              Exit;
            end;  *)
             
            /// //dm.fptr.Taxtypenumber :=ATOL.cdTax;  //  Без НДС - из настройки
        
           // Наименование услуги для каждой строки UslNameForCheck
           // В ЧЕК 
            //  //dm.fptr.TextWrap:=2;
           // Перенос по строке-в каждой строке печатается максимально возможное количество символов
            //   //dm.fptr.Name:=prom; 
            SaveLogPlut(' 1118'+prom);
             //  SaveLogPlut(' EndItem ');
             //  //dm.fptr.EndItem;        
            Dataset.NEXT;
        end; //while
      //end; // with
    end;
         // для доплаты или если выбрано без разбивки по услугам
        if (ATOL.Collapse = 1)or(pPay_packed.Doplata=1) then
         begin
           SaveLogPlut('1128 ==Doplata   == V_10  '); 
           // Регистрация товара или услуги
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	Признак предмета расчета
           //dm.fptr.setParam(1212, 4);   //Признак предмета расчёта	4 - услуга
           //1214  	Признак способа расчета
          {pPay_packed.cdpayment=4 полный расчет 3-аванс}
            SaveLogPlut('  1214 Признав способа расчета 4-Полный расчет, 3-Аванс;c dpayment= '+IntTostr(pPay_packed.cdpayment));    
           //dm.fptr.setParam(1214, pPay_packed.cdpayment);
           cena:=pPay_packed.summa;
           kol:=1;
      
 
            // //dm.fptr.Quantity := kol; //fieldbyname('KOLVO').Value;
             //dm.fptr.Price    := cena;
            // //dm.fptr.summ     := cena*kol;  ///????? окруление 
            sum_p:= cena*kol;
            sumch:=sum_p;   
          //// //  //dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,atol.Section);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, //dm.fptr.LIBFPTR_TW_WORDS );  //перенос по словам
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('1153 '+prom); 
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' усл: '+prom+' Quantity=' + FloatTostr(kol)
               +' summa= '+FloatToStr(pPay_packed.summa)+ ' налог= ' +floattostr(pPay_packed.summa*tax));                                       
            r  := 0; 
            //dm.fptr.registration;
           SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(pPay_packed.summa));    
         end; 
   //   end; // with
  //  end;    06/08/2020
//закрыть чек
      if pPay_packed.summCard>0 then
        begin
          SaveLogPlut(' 1164 BezNal=true  безналичный расчет LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCard)); 
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY)
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCard);
         //dm.fptr.payment;
         end;
      if pPay_packed.summCash>0 then
       begin   
         SaveLogPlut('BezNal=False наличка LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCash)); 
         // наличка
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH)
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCash);
         //dm.fptr.payment;
       end;   

       {=зачет аванса}
       if pPay_packed.summaAvans>0 then
       begin   
         SaveLogPlut('Авансом LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_PREPAID'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summaAvans)); 
         // наличка
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_PREPAID)
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCash);
         //dm.fptr.payment;
       end;
   
    //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
    //dm.fptr.payment;
          
   {== слип -чек для клиента }
          {= чек из постерминала}
    if slip_check<>'' then
      begin
        //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
     //  r:= //dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog_test(r,'setFooterLines');
         SaveLogPlut(slip_check); 
      end;
    // Закрытие чека
    //r:=dm.fptr.closeReceipt;
    // showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog_test(r,'closeReceipt');
     result:=true;

		//Sleep(1500);
    //Atol_v10_CheckDocumentClose;
        //закрытие соединения с ккт
      //  sleep(10);
    //dm.fptr.close;  //???
       
     SaveLogPlut(' CloseCheck ' );

    SaveLogPlut(' Конец чека'+strPay );
       {= чек из постерминала}
    (*if check<>'' then
      begin
        //dm.fptr.Caption:=check;
        //dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)

//!!!!
   SaveLogPlut('================формат 1.051_test end=================================== ');        
   nomcheck:=pPay_packed.pcddoc;
   
  SaveLogPlut('PrintCheck_atol_ end ' +  IntToStr(pPay_packed.pcddoc));
end;

{===}

{--======== =====      }




{===========================}



end.
