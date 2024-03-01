unit u_Atol_10;

interface
   uses Dialogs,u_dm,db,Math,U_const,ComObj,Forms,SysUtils,windows,Variants,DateUtils,u_Pos_Terminal;

{==������ ��� �� ����}
  function Atol_v10_SetTaxMode(const cdtax_val:variant): Double;
  {=����� ������ � ��� � ���������� ����� ������}
  function Atol_v10_SetErrorInLog(const err :integer;const nm: string):string;
  

     {=������ ��������� ���}
   function Atol_v10_LongStatus(var Info: string):boolean;

  ///    ����������� �������  ������ �� �����
  procedure  Atol_v10_SetKassir_Inn;
   {=������� ���������� � ���������-��� ������}
  function   Atol_v10_CreateConnect(var fptr:OleVariant): integer;
   {=���� ��������� ��������}
  function   Atol_v10_OpenDriverWindow(const nmFormParent:string) :integer;
    {=�������� ���������� ����� ����10}
  function   Atol_v10_CheckStatus(var Info: string):boolean;
   {= �������� ������ ������� ��� }
  function   Atol_v10_ShotStatusKKT : string;
    {=�������� ���������_������_���������}
  procedure  Atol_v10_CheckDocumentClose;
  {= X-�����}
  Procedure  Atol_v10_Xotchet;
    {= Z-�����}
  Procedure  Atol_v10_Zotchet;
  
    {=  �������� �����  atol_10}
  procedure Atol_v10_OpenSmena;
  {=�������� ���}
  procedure  Atol_v10_CancelCheck;
  
  {=������ ����������� �����}
  function   Atol_v10_PrintBankSlip(const slip_check : string):boolean;
  {=������ ���������� ���������}
  procedure  Atol_v10_PrintLastDoc;
  
  
    {=��������}
  procedure  Atol_v10_cashIncome(const sum:double);

  {=���������}
  procedure  Atol_v10_cashOutcome(const sum:double);
    {=������ ����� �� ������ ������� ������� v10 }
  function   PrintCheck_Atol_v10_105_old( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 ������}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                     ;pPay_packed: TPay_packed ) : Boolean;

  {=������ ����� �� ������ ������� ������� v10 }
  function   PrintCheck_Atol_v10_1_051_new( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 ������}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                    ;pPay_packed: TPay_packed ) : Boolean;

                                     
       {== ���� 
            ������ ��� ������ ����� ����� �����  ����}                                           
  function PrintCheck_Atol_v1_05_smesh_test(const slip_check: string;
                                         DataSet: TDataSet;
                                         var nomcheck:Integer; var FNDoc: integer; 
                                         pPay_packed: TPay_packed ) : Boolean; 
                                            
           {=������ ����� �� ������ �������  ===    ����������}
  function PrintCheck_Atol_v1_05_smesh( const slip_check: string;
                                         DataSet: TDataSet;
                                         var nomcheck:Integer; var FNDoc: integer; 
                                         pPay_packed: TPay_packed ) : Boolean;                              


  function   PrintCheck_Atol_v10_1_051_new_test( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 ������}DataSet: TDataSet; Summa: Double;
                                    SumAll: Double; Doplata: Integer; 
                                    var nomcheck:Integer; var FNDoc: integer;
                                    BezNal:Boolean;const cddoc :integer
                                    ;pPay_packed: TPay_packed ) : Boolean;
                                    

  function Atol_v10_SetErrorInLog_test(const err :integer;const nm: string):string;

  //������ ����� �������� ��
  function  Atol_v10_End_TimeFN : TDateTime;
  {= ���������� ���� �� ��������� ����� ��������}
  Function Atol_v10_CountDayOfEndFN: string;

  
{==������ ��� �� ����}
  function Atol_v10_SetTaxMode_test(const cdtax_val:variant): Double;
 {=��� ��������� 10}
   procedure Atol_v10_CorrectionCheck_1_05(const SummCash      : Double;
                              const SummNonCash   : Double;
                              const SummAvans     : Double;
                              const TaxCode       : integer;
                              const isPrihod      : boolean;
                              const CorrTypeSamost: boolean;
                              const nameCorre :string;//������ �������
                                const NDoc:string;
                               dt:TDatetime;const nmusl: string;const kol :integer
                              ;var numcheck : integer;var FNDoc:integer);

   
implementation

  (*������������ ���� ��������� (��� 1.0, 1.05) ������� �� ��������� ��������:

    �������� ���� � �������� ���������� ����
    ����������� �����
    ����������� ������� �� ��� (�������������� �����)
    ����������� ����� (�������������� �����)
    �������� ����
    �������� ��������� ����
*)





function  Atol_v10_End_TimeFN : TDateTime;

//������ ����� �������� ��
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
  st:=' !!! �������� ���� '+IntTostr(DaysBetween(date,dt))+' �� ��������� �� '+#13#10+
      ' ���� ��������� ��: '+FormatDateTime('dd.mm.yyyy',dt);
result:=st;     
end;


 {=��� ��������� 10}
procedure Atol_v10_CorrectionCheck_1_05(const SummCash      : Double;
                              const SummNonCash   : Double;
                              const SummAvans     : Double;
                              const TaxCode       : integer;
                              const isPrihod      : boolean;
                              const CorrTypeSamost: boolean;
                              const nameCorre :string;//������ �������
                                const NDoc:string;
                               dt:TDatetime ;const nmusl: string;const kol :integer
                              ;var numcheck : integer;var FNDoc:integer);
 var
  sum_p,tax:double;
  stype:string;
  sprich,str:string; // ��� ���������
 // NCheck:integer;
  systnal,typecor,r : integer;      // ���
  summ: double;
  date: TDateTime;
  correctionInfo: Variant;
begin
      //�������� ���������� � ���
  dm.fptr.open; 
          //������ ����������
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   numcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   numcheck:=numcheck+1;
   SaveLogPlut('����� ����= '+IntToStr(numcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('����� ����.���= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

  
    sum_p:=0;
             {= ����������� ������� ��������������� � ����:  � ����� ��������� ���}
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
    SaveLogPlut('������� ��������������� C�� :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 161 Send ������� ���������������: ');

      // ��� ���������

    if CorrTypeSamost=true
      then
           begin typecor:=0; sprich:='������' end  // ��������������
      else begin typecor:=1; sprich:='�����' end; // �� �����������
   
     SaveLogPlut('BeginComplexAttribute 1173 CorrType ='+sprich+ ' ;1177 nameCorre= ' +nameCorre+
                  ';1178 ����= '+DateToStr(dt)+ ';1179 ����� ��������� NDoc=' +NDoc );   
    
    //nameCorre:= '�������� ��������� ���������';
  //  nameCorre;//������ �������; // ������������ ��������� ��������� ��� ���������
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
               //1212          	������� �������� �������
    ///    dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
       //1212          	������� �������� �������
     dm.fptr.setParam(1212, 4);   //������� �������� �������	4 - ������
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
   //  SaveLogPlut('summa= '+FloatToStr(sum_p)+ ' �����= ' +floattostr(sum_p*tax));    
      r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_NO);
           Atol_v10_SetErrorInLog(r,'LIBFPTR_TAX_NO');
      r:=dm.fptr.registration;
        Atol_v10_SetErrorInLog(r,'registration');      
     	if SummNonCash>0 then 
       begin 
         SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 

         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,1);
                  SaveLogPlut(' 225');  

       end
    else
    if SummCash>0 then
     
       begin
        SaveLogPlut('! BezNal=False ������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // �������
     
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
                  ';1178 ����= '+DateToStr(dt)+ ';1179 ����� ��������� NDoc=' +NDoc 
                     +' numch='+intTostr(numcheck)+' ;Fndoc='+IntToStr(FNDoc));    
end;




{=������� ���������� � ���������-��� ������}
function Atol_v10_CreateConnect(var fptr:OleVariant): integer;
var version : string;
 begin
 result:=1;
 try
  {=  10.� }
     // CoInitialize(nil);
    dm.fptr := CreateOleObject('AddIn.Fptr10');
           SaveLogPlut('CreateOleObject Atol_10 �������  ');
    //fptr.ApplicationHandle := Application.Handle;
    
   // fptr.erroecode;
     
        
    except   on e: exception do
     begin
       ShowMessage('�� ������� ������� ������ �������� "����_10"!');
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




 {=���� ��������� ��������}
function Atol_v10_OpenDriverWindow(const nmFormParent:string) :integer;
 var tp :Integer;
      str : string;
begin
//FindWindow(nil, '�������� �����������') <> 0 
 SaveLogPlut('=���� ��������� ��������');
 dm.fptr.open;
// tp:=dm.fptr.showProperties(dm.fptr.LIBFPTR_GUI_PARENT_NATIVE, FindWindow(nil,@nmFormParent));
 tp:=dm.fptr.showProperties(dm.fptr.LIBFPTR_GUI_PARENT_NATIVE, FindWindow('Form1',nil));
 Result:=tp;
   case tp of
   -1: str:=' ������';
    0: str:=' ������ OK';
    1: str:=' ������ ����� �� ����� '
   end;
 dm.fptr.close;
  SaveLogPlut('=���� ��������� �������� ')
end;



///    ����������� ������� ������ �� �����
procedure Atol_v10_SetKassir_Inn;
var r: integer;
begin
 //dm.fptr.open;

  r:=dm.fptr.setParam(1021, '������ '+TRIM(USERNM));
    if r<>0  then
      begin
        ShowMessage(' ������ �������� ������ ������� '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
        SaveLogPlut(' ������ �������� ������ ������� '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
      end;
  SaveLogPlut('������ '+TRIM(USERNM));
  if USER_INN<>'' then
    begin
       SaveLogPlut('USER_INN '+TRIM(USER_INN));
      dm.fptr.setParam(1203,USER_INN );
    end;
    r:=dm.fptr.operatorLogin;
  if r<0 then
   begin
     SaveLogPlut(' ������ ����������� ������� '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
   end else
     SaveLogPlut('Atol_v10_SetKassir_Inn operatorLogin  ������');
// dm.fptr.close;  
end;


 {=�������� ���������� ����� ����10}
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
     {=  ������ ��������� �����  }
SaveLogPlut(' 188 ������ ��������� ����� ');
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DATA_TYPE,dm.Fptr.LIBFPTR_DT_SHIFT_STATE);
  if dm.fptr.queryData<0 then
    begin
      SaveLogPlut('������ �������� �����  '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
      Result:=False;
     end
  else    
   begin
     shiftState:= dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_SHIFT_STATE);
     SaveLogPlut('LIBFPTR_PARAM_SHIFT_shiftState shiftState= '+ IntToStr(shiftState));
     if shiftState= dm.fptr.LIBFPTR_SS_CLOSED then
        begin
          isSmenaOpen:=pClose;
         // SaveLogPlut(' �����= �������' );
           strM:=strM+';'+#13#10+' ����� ������� = ���';
                SaveLogPlut(' ����� ������� = ���');
          result:=false;
        end;
     if shiftState= dm.fptr.LIBFPTR_SS_OPENED then
        begin
          isSmenaOpen:=pOpen;
          //SaveLogPlut(' �����  =  �������' );
            strM:=strM+';'+#13#10+' ����� ������� = ��';
                   SaveLogPlut(' ����� ������� = ��');
          result:=true;
        end; 
     if shiftState= dm.fptr.LIBFPTR_SS_EXPIRED then
        begin
                 SaveLogPlut(' ��������� ��������  ����� 24 ���� = ��');
         isSmenaOpen:=pOldOpen;
       //  SaveLogPlut(' ��������� ��������  ����� 24 ����' );
            strM:=strM+';'+#13#10+'  ��������� ��������  ����� 24 ���� = ��'; 
         result:=true;
        end; 
end;
  SaveLogPlut(strM);    
  Info:=   strM;
  dm.fptr.close;
  // SetStatusForKassa(stbMenue);
end;


{=������ ��������� ���}
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
     {=  ������ ���������  }
SaveLogPlut(' 254 ������ ��������� ���');
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DATA_TYPE, dm.fptr.LIBFPTR_DT_STATUS);
  if dm.fptr.queryData<0 then
    begin
      SaveLogPlut('������ �������� �����  '+IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription);
      Result:=False;
     end
  else    
   begin

     Atol_v10_SetErrorInLog(1,'CheckStatusAtol_10');

      mode        := dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_MODE);
            strM:=strm+';'+#13#10+' ����� mode='+IntToStr(mode); 
     submode         := dm.fptr.getParamInt(dm.fptr.LIBFPTR_PARAM_SUBMODE);
             strM:=strm+';'+#13#10+' �������� submode='+IntToStr(submode); 
     
     isPaperPresent     := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_RECEIPT_PAPER_PRESENT);
     if isPaperPresent=True then
                strM:=strM+';'+#13#10+' ���� ������ = ��' 
      else
         begin
          strM:=strM+';'+#13#10+' ���� ������ = ���';
          result:=false;
         end;
     //  SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
  

    isPaperNearEnd:=dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PAPER_NEAR_END);
    if isPaperNearEnd =True then
     begin
       strM:=strM+';'+#13#10+' ������ ����� ���������� = �� ';
       result:=false;
     end
    else       
       strM:=strM+';'+#13#10+' ������ ����� ���������� = ��� ';

     versionKKT:=dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_UNIT_VERSION);  
     strM:=strm+';'+#13#10+versionKKT; 

     serialNumber    := dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_SERIAL_NUMBER);
     strM:=strM+';'+#13#10+' ��������� ����� ���: '+serialNumber;
     modelName       := dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_MODEL_NAME);
     strM:=strM+';'+#13#10+'�������� ���: '+modelName;  
     firmwareVersion := dm.fptr.getParamString(dm.fptr.LIBFPTR_PARAM_UNIT_VERSION);
     strM:=strM+';'+#13#10+'������ �� ���: '+firmwareVersion; 

     
     isPrinterConnectionLost := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PRINTER_CONNECTION_LOST);
     if isPrinterConnectionLost=True then
       begin
         strM:=strM+';'+#13#10+' �������� ���������� � �������� ���������� = ��';
         result:=false;
       end
     else  
        strM:=strM+';'+#13#10+' �������� ���������� � �������� ���������� = ���';  
     
     
     isPrinterError           := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PRINTER_ERROR);
     if isPrinterError=True then
       begin
         strM:=strM+';'+#13#10+' ��������������� ������ ��������� ��������� = ��';
         result:=false;
       end
     else  
        strM:=strM+';'+#13#10+'  ��������������� ������ ��������� ��������� = ���';  
     isCutError               := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_CUT_ERROR);
     if isCutError=True then
        begin
         strM:=strM+';'+#13#10+' ������ ���������= ��';
         result:=false;
        end
     else  
        strM:=strM+';'+#13#10+' ������ ��������� = ���'; 
     
     isPrinterOverheat        := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PRINTER_OVERHEAT);
     if isPrinterOverheat=True then
       begin
         strM:=strM+';'+#13#10+' �������� ��������� ��������� = ��';
         result:=false;
       end
     else  
        strM:=strM+';'+#13#10+' �������� ��������� ��������� = ���'; 
     
     isDeviceBlocked          := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_BLOCKED);
     if isDeviceBlocked=True then
      begin
        strM:=strM+';'+#13#10+' ��� ������������� ��-�� ������ = ��';
        result:=false;
      end
     else  
        strM:=strM+';'+#13#10+' ��� ������������� ��-�� ������ = ���';
   end;
     SaveLogPlut(strM);    
  Info:=   strM;
  dm.fptr.close;
end;

{=�������� ���������_������_���������}
procedure Atol_v10_CheckDocumentClose;
 var str :string;
begin
SaveLogPlut('289   �heck doc');
  If dm.fptr.checkDocumentClosed <0 then
    begin
        // �� ������� ��������� ��������� ���������. ������� ������������ ����� ������, ��������� ��������� ��������� � ��������� ������
      str:= Atol_v10_SetErrorInLog(-1,'293 Atol_v10_SetErrorInLog');
     showmessage(' ������ �������� ��������� checkDocumentClosed '+#13#10+str);
     //SaveLogPlut(' ������ �������� ��������� checkDocumentClosed'+#13#10 +IntToStr(dm.fptr.errorCode)+'  ' + dm.fptr.errorDescription);
     exit;
    end;

    if not dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_DOCUMENT_CLOSED) then
    begin
        SaveLogPlut('  395  cancelReceipt');
        // �������� �� ��������. ��������� ��� �������� (���� ��� ���) � ������������ ������
      dm.fptr.cancelReceipt;
      str:= Atol_v10_SetErrorInLog(-1,'303 Atol_v10_SetErrorInLog');
      showmessage('������ �������� ��������� checkDocumentClosed '+#13#10+str);
      exit;
    end;

    if not dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_DOCUMENT_PRINTED) then
    begin
        // ����� ����� ������� ����� ������������� ���������, �� ���������� � �������, ���� ��� ����������
        SaveLogPlut('  405 continuePrint');
      if dm.fptr.continuePrint < 0 then
        begin
           str:= Atol_v10_SetErrorInLog(-1,'313 Atol_v10_SetErrorInLog');
           showmessage('������ �������� ��������� continuePrint '+#13#10+str);
        end;
    end;
    
end;





  {=  �������� �����  atol10}
procedure Atol_v10_OpenSmena;
var r :integer;
 str : string;
begin
  SaveLogPlut(' ��������� ����� ����_10');
  dm.fptr.open;
  Atol_v10_SetKassir_Inn;
  r:=dm.fptr.openShift;
  Atol_v10_SetErrorInLog(r,'openShift'); 
    If dm.fptr.checkDocumentClosed <0 then
    begin
        // �� ������� ��������� ��������� ���������. ������� ������������ ����� ������, ��������� ��������� ��������� � ��������� ������
      str:= Atol_v10_SetErrorInLog(-1,'Atol_v10_SetErrorInLog');
     showmessage('������ �������� ��������� checkDocumentClosed '+#13#10+str);
     //SaveLogPlut(' ������ �������� ��������� checkDocumentClosed'+#13#10 +IntToStr(dm.fptr.errorCode)+'  ' + dm.fptr.errorDescription);
     exit;
    end;
  //Atol_v10_CheckDocumentClose;
  dm.fptr.close;  //������ ����������
  //dm.fptr.checkDocumentClosed;

end;


procedure Atol_v10_cancelCheck;
var r:integer;
begin
  SaveLogPlut('Atol10_cancelCheck');
  dm.fptr.open;
  r:=dm.fptr.cancelReceipt;
  Atol_v10_SetErrorInLog(r,' ������ ���� ');
  dm.fptr.close;
end;   

function Atol_v10_SetErrorInLog(const err :integer;const nm: string):string;
var res :string;
begin
res:='';
if err<0 then
  begin
   res:=IntToStr(dm.fptr.errorCode)+'  ' +dm.fptr.errorDescription;
    SaveLogPlut('������ '+nm+' '+res);
  end
  else SaveLogPlut(nm+' ����������� ��� ������');
 result:=res; 
end;


function Atol_v10_SetErrorInLog_test(const err :integer;const nm: string):string;
var res :string;
begin
res:='';
   SaveLogPlut(nm);
 result:=res; 
end;

{= X-�����}
Procedure  Atol_v10_Xotchet;
var r:integer;
sl, check_pos:string;
begin
r:=0;
 SaveLogPlut('������ X-������');
 
   if (nastrlist.Values['PinPad_pilot_nt']='1')  then  
   begin
   //  if TypePinpad=pPinpad then 
     sl:=XSmena_posTerminal(check_pos);
     SaveLogPlut('Atol_v10_PrintBankSlip  '+check_pos );
     if check_pos<>'' then 
       Atol_v10_PrintBankSlip(check_pos)
     else  SaveLogPlut('��� ���� ����');
  end;
  SaveLogPlut('===Atol_v10_Xotchet;===');
   dm.fptr.open;
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_REPORT_TYPE, dm.fptr.LIBFPTR_RT_X);
   r:=dm.fptr.report;
   dm.fptr.close; 
  Atol_v10_SetErrorInLog(r,'������ X-������');
end;

    {= Z-�����}
Procedure  Atol_v10_Zotchet;
var r:integer;
 check_pos,str,slip: string;

begin
 check_pos:='';

r:=0;
  SaveLogPlut('������ Z-������');
  if (nastrlist.Values['PinPad_pilot_nt']='1') then  
   begin
     //if TypePinpad=pPinpad then 
         check_pos:=CloseSmena_posTerminal(slip);
     if slip<>'' then 
       Atol_v10_PrintBankSlip(slip)
     else  SaveLogPlut('��� ���� ����');
  end;
  dm.fptr.open; 
  Atol_v10_SetKassir_Inn;
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_REPORT_TYPE, dm.fptr.LIBFPTR_RT_CLOSE_SHIFT);
  r:=dm.fptr.report;
   Atol_v10_SetErrorInLog(r,'������ Z-������');
      If dm.fptr.checkDocumentClosed <0 then
    begin
        // �� ������� ��������� ��������� ���������. ������� ������������ ����� ������, ��������� ��������� ��������� � ��������� ������
      str:= Atol_v10_SetErrorInLog(-1,'Atol_v10_SetErrorInLog');
     showmessage('������ �������� ��������� checkDocumentClosed '+#13#10+str);
     //SaveLogPlut(' ������ �������� ��������� checkDocumentClosed'+#13#10 +IntToStr(dm.fptr.errorCode)+'  ' + dm.fptr.errorDescription);
   //  exit;
    end;
  dm.fptr.close; 
end;




{= �������� ������ ������� ��� }

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
strZag:='�������� �����c ��������� �������� ���� v10 ';
SaveLogPlut(strZag);
  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DATA_TYPE, dm.fptr.LIBFPTR_DT_SHORT_STATUS);
   if dm.fptr.queryData<0 then
    begin
      Atol_v10_SetErrorInLog(-1,'ShotStatusKKT');
      strM:= strM+';'+#13#10+IntToStr(dm.fptr.errorCode)+' ' +dm.fptr.errorDescription; 
      showmessage_good('������'+ strZag+ #13#10+strM);
      SaveLogPlut('������'+ strZag+ #13#10+strM);
      Result:=strM;
      exit;
    end;
  Atol_v10_SetErrorInLog(1,'ShotStatusKKT');
 // isCashDrawerOpened := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_CASHDRAWER_OPENED);
  isPaperPresent     := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_RECEIPT_PAPER_PRESENT);
  if isPaperPresent=False then
   begin
    strM:=strM+';'+#13#10+' ��� ������ '; 
    SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
    Result:=strM;
   end;

  isPaperNearEnd:=dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_PAPER_NEAR_END);
  if isPaperNearEnd =True then
   begin
    strM:=strM+';'+#13#10+' ������ ����� ����������'; 
    SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
    Result:=strM;
   end;

  isCoverOpened      := dm.fptr.getParamBool(dm.fptr.LIBFPTR_PARAM_COVER_OPENED);
  if isCoverOpened =True then
   begin
     strM:=strM+';'+#13#10+' ������� ������ ���'; 
    SaveLogPlut(strZag + ' ShotStatusKKT'#13#10+strM);
    Result:=strM;
   end;
end;


function Atol_v10_PrintBankSlip(const slip_check : string):boolean;
var r:integer;
 str : string;
begin
result:=False;
  SaveLogPlut('==  ������ ����� �������� ������ ===');
    dm.fptr.open;///���������� � ���
     // ������������ ����� ���-������������
    dm.fptr.beginNonfiscalDocument;
        //������� �� 
    r:= dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP,dm.fptr.LIBFPTR_TW_CHARS);
     str:=Atol_v10_SetErrorInLog(r,'slip_check');
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT,slip_check);
    dm.fptr.printText;  
    r:=dm.fptr.endNonfiscalDocument;
      str:=Atol_v10_SetErrorInLog(r,'endNonfiscalDocument');
      
 result:=True;   
  SaveLogPlut('== ������ ����� �����===');  
end;  


  {=������ ���������� ���������}
procedure  Atol_v10_PrintLastDoc;
var r : integer;
begin
 dm.fptr.open;
 dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_REPORT_TYPE, dm.fptr.LIBFPTR_RT_LAST_DOCUMENT);
 r:=dm.fptr.report;
  Atol_v10_SetErrorInLog(r,'printLastDoc');
 dm.fptr.close;
  
end;


  {=��������}
procedure Atol_v10_cashIncome(const sum:double);
var r:integer;
begin
 SaveLogPlut('�������� sum='+FloatTostr(sum));
 dm.fptr.open;
 dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_SUM, sum);
 r:=dm.fptr.cashIncome;
 dm.fptr.close;
 Atol_v10_SetErrorInLog(r,'Atol10_cashIncome ');
end;


  {=���������}
procedure Atol_v10_cashOutcome(const sum:double);
var r:integer;
begin
 SaveLogPlut('��������� sum='+FloatTostr(sum));
  dm.fptr.open;
 dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_SUM, 100.00);
 r:=dm.fptr.cashOutcome;
  dm.fptr.close;
 Atol_v10_SetErrorInLog(r,'Atol10_cashOutcome ');
end;


   (* ����������  if ExistsMark then
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
      ShowMessage ('������ '+IntToStr(DataModuleUser.Atol.errorCode)+'  ' +DataModuleUser.Atol.errorDescription);
      Result := False;
      Exit;
    end;*)

{==������ ��� �� ����}
function Atol_v10_SetTaxMode(const cdtax_val:variant):double;
var nmTax, str :string;
  res: double;
  r,cd : integer;
begin
str:='';
nmTax:='��� ������';
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
          
   if (AnsiLowerCase(nmTax)='��� ������') or (AnsiLowerCase(nmTax)='��� ���') then
      begin
       r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_NO);
       str:='LIBFPTR_TAX_NO';
      end;
   if AnsiLowerCase(nmTax)='��� 0%' then
      begin
        r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT0);  
        str:='LIBFPTR_TAX_VAT0';
      end; 
   if AnsiLowerCase(nmTax)='��� 10%' then
      begin
       r:= dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT10);  
        str:='LIBFPTR_TAX_VAT10';
        res:=0.1;
      end; 
  if AnsiLowerCase(nmTax)='��� 20%' then
      begin
        r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT20 );  
        str:='LIBFPTR_TAX_VAT20';
        res:=0.2;
      end;  
  if AnsiLowerCase(nmTax)='��� � ����������� ������� 10% ' then
      begin
        r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
        str:='LIBFPTR_TAX_VAT110';
        res:=0.1;
      end;    
   if AnsiLowerCase(nmTax)='��� � ����������� ������� 20%  ' then
     begin
       r:=dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
       str:='LIBFPTR_TAX_VAT120';
       res:=0.2;
    end;     
     Atol_v10_SetErrorInLog(r,'Atol_v10_SetTaxMode');       
      SaveLogPlut('����� cdTax= '+IntToStr(cd)+' - '+nmTax+' par= '+str+' ���= '+ FloatTostr(res) );
 Result:=res;                                                    
end;    




{==������ ��� �� ����}
function Atol_v10_SetTaxMode_test(const cdtax_val:variant):double;
var nmTax, str :string;
  res: double;
  cd:integer;
begin
str:='';
nmTax:='��� ������';
res:=0;
if cdtax_val <> null then
   begin
      nmTax := dm.qsltax_cd.Lookup('cdtax',cdtax_val,'nmtax');
      cd    :=cdtax_val;
   end
  else cd:=0;    
      
          
   if (AnsiLowerCase(nmTax)='��� ������') or (AnsiLowerCase(nmTax)='��� ���') then
      begin
    //   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_NO);
       str:='LIBFPTR_TAX_NO';
      end;
   if AnsiLowerCase(nmTax)='��� 0%' then
      begin
       // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT0);  
        str:='LIBFPTR_TAX_VAT0';
      end; 
   if AnsiLowerCase(nmTax)='��� 10%' then
      begin
       // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT10);  
        str:='LIBFPTR_TAX_VAT10';
        res:=0.1;
      end; 
  if AnsiLowerCase(nmTax)='��� 20%' then
      begin
      //  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT20 );  
        str:='LIBFPTR_TAX_VAT20';
        res:=0.2;
      end;  
  if AnsiLowerCase(nmTax)='��� � ����������� ������� 10% ' then
      begin
      //  dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
        str:='LIBFPTR_TAX_VAT110';
        res:=0.1;
      end;    
   if AnsiLowerCase(nmTax)='��� � ����������� ������� 20%  ' then
     begin
    //   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TAX_TYPE, dm.fptr.LIBFPTR_TAX_VAT110);  
       str:='LIBFPTR_TAX_VAT120';
       res:=0.2;
    end;            
      SaveLogPlut('����� cdTax= '+ intTostr(cd)+' - '+nmTax+' par= '+str+' ���= '+ FloatTostr(res) );
 Result:=res;                                                    
end;    




{=������ ����� �� ������ ������� }
function PrintCheck_Atol_v10_105_old( const check: string;
                                    const CustomerEmail: string;
                                    OperType: integer;{>0 ������}DataSet: TDataSet; Summa: Double;
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

if check<>'' then Atol_v10_PrintBankSlip(check);/// ��� ������� ��� � ��������
 try
  Result := False;
  SaveLogPlut('================ 659 v10 ������ 1.051=================================== ');  
    //�������� ���������� � ���
  dm.fptr.open;


        //������ ����������
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   nomcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   nomcheck:=nomcheck+1;
   SaveLogPlut('����� ����= '+IntToStr(nomcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('����� ����.���= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

 //����������� �������
    Atol_v10_SetKassir_Inn;
    SaveLogPlut('660');  
//��� ����
   case OperType of
     1: begin
         if (Doplata=1 ) then strPay:=' _�������_ ' 
           else  strPay:=' _������_ ';
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL);
          SaveLogPlut(' 671 OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL  �������'); 
        end;
     2: begin
         strPay:=' _�������_';
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL_RETURN); 
         SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  �������');                     
        end;
   end;

   sumch := 0;
   kol:=0;     
  if check<>'' then
         begin
         {== ��� ��� �����}
          // SaveLogPlut('==== �������� ��� ������ �� ��� ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END �������� ��� ������ �� ��� ===============');
         end;      
 
  {=  �������� ������������ ����}
  if CustomerEmail<>'' then
     begin
       SaveLogPlut('692 ����� ');
       r:=dm.fptr.setParam(1008, CustomerEmail);
   	    // �������� ����� ��� ������������ ������
       SaveLogPlut('698 ����� AttrNumber := 1008  AttrValue:='+CustomerEmail);
     if r<>0 then
        begin
          Atol_v10_SetErrorInLog(r,'CustomerEmail');
          ShowMessage('702 ������ CustomerEmail  ������ ��� ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= ����������� ������� ��������������� � ����:  � ����� ��������� ���}
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
    SaveLogPlut('������� ��������������� C�� :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 739 Send ������� ���������������: ');

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
          ShowMessage('������ cancelReceipt ������ ��� ');
       end; 
    end;    
   
  SaveLogPlut('===========����������� �������  ==============================');
  SaveLogPlut(' dataset.RecordCount= ' + IntToStr(dataset.RecordCount) +#13+
                ' Summa= ' + FloatTostr(Summa) +' SumAll= ' + FloatTostr(SumAll) +#13+
                ' Doplata ' +IntToStr(Doplata)   );
                    SaveLogPlut(dataset.Name +' dataset.RecordCount='+IntTostr(dataset.RecordCount));
 if (dataset.RecordCount>0) and (Doplata=0)      then
    begin
       DataSet.First;
       While not DataSet.Eof do
        begin
         ////////������ ������     � �������
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
             end;      ///////// ������ ������ �������� � �������  
              ///////// ����� ������ �������� � ������� 
             // if sl.Count=0 then
            if nastrList.Values['NewFormat']='1' then
               begin
                 sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
                 kol:=  dataset.fieldbyname('KOLVO').Value;
               end;
          
         // kol:=dataset.FieldByName('kolvo').AsInteger;
            // ����������� ������ ��� ������
     
          prom :=  '';
         if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
             prom := dataset.fieldbyname('nmusl').Value;
         // prom := dataset.fieldbyname('nmusl').Value;
                     //�����
                      //1212          	������� �������� �������
              dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
              //1214  	������� ������� �������
            //  dm.fptr.setParam(1214, 4);     //16.06.2021
            if pPay_packed.cdpayment>0 then
               begin
                case pPay_packed.cdpayment of
                 0,4: begin
                      dm.fptr.setParam(1214,4);   // ������ ��� ��� 1.05. 4-������ ������
                      SaveLogPlut('--- 4 ������� ������� ������� (������ ������');
                     end;
                  3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //���������
                       else     dm.fptr.setParam(1214,4);         
                        SaveLogPlut('--- 3 ������� ������� ������� (��������� ������');
                       end;   
                  1: begin
                      
                      dm.fptr.setParam(1214,1);    
                      SaveLogPlut('--- 1 ������� ������� ������� (���������� 100 ');
                   end;
                end;   
      

          
              // cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
               cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
               cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);
              if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
                sum_p:= cena*kol;
                 SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) ); 
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
           
                  SaveLogPlut('���. '+prom+'  cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                          +'sum_p= '+FloatToStr(sum_p) + ' �����= ' +floatTostr(summa*tax)); 
                                                 
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 941 registration');
            if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration str='+str);
              //ShowMessage ('������ '+str);  07/07/2021
              Result := False;
              Exit;
            end;
          
   
            Dataset.NEXT;
        end; //while
      //end; // with
    end;
         // ��� ������� ��� ���� ������� ��� �������� �� �������
       if (ATOL.Collapse = 1)or(Doplata=1) then
         begin
           SaveLogPlut('==Doplata   == V_10  '); 
           // ����������� ������ ��� ������
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	������� �������� �������
           dm.fptr.setParam(1212, 4);   //������� �������� �������	4 - ������
           //1214  	������� ������� �������
                
         //  dm.fptr.setParam(1214, 4);  16/06/2021
            if pPay_packed.cdpayment>0 then
               begin
                case pPay_packed.cdpayment of
                 0,4: begin
                    dm.fptr.setParam(1214,4);   // ������ ��� ��� 1.05. 4-������ ������
                     SaveLogPlut('--- 4 ������� ������� ������� (������ ������');
                  end;
                 3: begin
                  if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //���������
                   else     dm.fptr.setParam(1214,4);         
                     SaveLogPlut('--- 3 ������� ������� ������� (��������� ������');
                    end;   
               (* 1: begin
                      
                      dm.fptr.setParam(1214,1);    
                  SaveLogPlut('--- 1 ������� ������� ������� (���������� 100 ');
                 end; *)  
                end;
               end;

               
              
            end;
           cena:=summa;
           kol:=1;
      
                
            // dm.fptr.Quantity := kol; //fieldbyname('KOLVO').Value;
             //dm.fptr.Price    := cena;
            // dm.fptr.summ     := cena*kol;  ///????? ��������� 
            sum_p:= cena*kol;
           //  dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
          
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );  //������� �� ������
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
            tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            sumch := sum_p;
                SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                     +'summa= '+FloatToStr(summa)+ ' �����= ' +floattostr(summa*tax));                                       
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 990 registration');
            if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
                  Atol_v10_SetErrorInLog(r,' 990 registration  str='+str);
             // ShowMessage ('������ '+str);
              Result := False;
              Exit;
            end; 
               SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(summa));    
         end; 
   //   end; // with
  //  end;    06/08/2020
//������� ���
	if BezNal=true then 
       begin 
         SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 
        // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,1);
         //  SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE =1 ');

       end
    else  
       begin
        SaveLogPlut('! BezNal=False ������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // �������
         // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
                dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
         //  SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE =0 ');

       end;
   
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
   SaveLogPlut('  end == oplata   ==  ;sumch= '+floatTostr(sumch));   
    
   r:= dm.fptr.payment;
      Atol_v10_SetErrorInLog(r,'payment');
   {== ���� -��� ��� ������� }
          {= ��� �� ������������}
    if check<>'' then
      begin
         SaveLogPlut(' = ��� �� ������������ ��� �������'); 
        dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
         r:= dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog(r,'setFooterLines');
        SaveLogPlut(check); 
      end;
    // �������� ����
     r:=dm.fptr.closeReceipt;
     //showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog(r,'closeReceipt');
    if r<> 0 then 
      begin 
        showmessage('������ closeReceipt rjl:'+IntTostr(r));
         result:=false;
         exit;
      end
      else result:=true;
 		//Sleep(1500);
    Atol_v10_CheckDocumentClose;
        //�������� ���������� � ���
    sleep(5);
    dm.fptr.close;  //???
    SaveLogPlut(' CloseCheck ' );
    SaveLogPlut(' ����� ����'+strPay );
       {= ��� �� ������������}
    (*if check<>'' then
      begin
        dm.fptr.Caption:=check;
        dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)


   SaveLogPlut('================������ old_105 end=================================== ');        

  SaveLogPlut('PrintCheck_atol_ end ����� cddoc= ' +  IntToStr(cddoc));
 


  except on e: exception do
    begin
     // showmessage('������: '+ e.Message);
      SaveLogPlut('������: '+ e.Message);
       r:=dm.fptr.cancelReceipt;
       dm.fptr.close;
       Atol_v10_SetErrorInLog(r,' 935 dm.fptr.cancelReceipt');
      Result:=False;
    end;
  end;
end;



{=������ ����� �� ������ ������� }
function PrintCheck_Atol_v10_1_051_new( const check: string;
                                    const CustomerEmail: string;
                                    OperType: integer;{>0 ������}DataSet: TDataSet; Summa: Double;
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

if check<>'' then Atol_v10_PrintBankSlip(check);/// ��� ������� ��� � ��������
 try
  Result := False;
  SaveLogPlut('================ 659 v10 ������ 1.051=================================== ');  
    //�������� ���������� � ���
  dm.fptr.open;

    //������ ����������
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   nomcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   nomcheck:=nomcheck+1;
   SaveLogPlut('����� ����= '+IntToStr(nomcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('����� ����.���= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

 //����������� �������
    Atol_v10_SetKassir_Inn;
    SaveLogPlut('660');  
//��� ����
   case OperType of
     1: begin
         if (Doplata=1 ) then strPay:=' _�������_ ' 
           else  strPay:=' _������_ ';
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL);
          SaveLogPlut(' 671 OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL  �������'); 
        end;
     2: begin
         strPay:=' _�������_';
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL_RETURN); 
         SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  �������');                     
        end;
   end;

   sumch := 0;
   kol:=0;     
 // if check<>'' then
       //  begin
         {== ��� ��� �����}
          // SaveLogPlut('==== �������� ��� ������ �� ��� ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END �������� ��� ������ �� ��� ===============');
       //  end;      
 
  {=  �������� ������������ ����}
  if CustomerEmail<>'' then
     begin
       SaveLogPlut('692 ����� ');
       r:=dm.fptr.setParam(1008, CustomerEmail);
   	    // �������� ����� ��� ������������ ������
       SaveLogPlut('698 ����� AttrNumber := 1008  AttrValue:='+CustomerEmail);
       if r<>0 then
        begin
          Atol_v10_SetErrorInLog(r,'CustomerEmail');
          ShowMessage('702 ������ CustomerEmail  ������ ��� ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= ����������� ������� ��������������� � ����:  � ����� ��������� ���}
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
    SaveLogPlut('������� ��������������� C�� :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 739 Send ������� ���������������: ');

     {=��������\�� ������ ��� �� ���}
   if pPay_packed.isPrintCheck=False then
    begin
       SaveLogPlut('==== 1496 ��� �������� ��� isPrintCheck=Fflse ');
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
          ShowMessage('������ cancelReceipt ������ ��� ');
       end; 
    end;    
   
  SaveLogPlut('===========����������� �������  ==============================');
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

          
          // ����������� ������ ��� ������
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
             prom := dataset.fieldbyname('nmusl').Value;
            //����� 1212          	������� �������� �������
            
          dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
              //1214  	������� ������� �������
            //  dm.fptr.setParam(1214, 4);     //16.06.2021
            //if pPay_packed.cdpayment>0 then
               //begin
            case pPay_packed.cdpayment of
                 0,4: begin
                      dm.fptr.setParam(1214,4);   // ������ ��� ��� 1.05. 4-������ ������
                      SaveLogPlut('--- 4 ������� ������� ������� (������ ������');
                     end;
                  3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //���������
                       else     dm.fptr.setParam(1214,4);         
                        SaveLogPlut('--- 3 ������� ������� ������� (��������� ������');
                     end;   
                  1: begin
                      dm.fptr.setParam(1214,1);    
                      SaveLogPlut('--- 1 ������� ������� ������� (���������� 100 ');
                   end;
              end;
             
              // cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
              cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
              cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);
              if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
              sum_p:= cena*kol;
              SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) ); 
        
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, sum_p);
               tax:=0;
              tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
              dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
              // sumch := sumch +  Math.RoundTo(fieldbyname('uslugVozvrSum').Value,-2); 
           
              SaveLogPlut('���. '+prom+'  cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                          +'sum_p= '+FloatToStr(sum_p) + ' �����= ' +floatTostr(summa*tax)); 
                                                 
              r  :=  dm.fptr.registration;
              Atol_v10_SetErrorInLog(r,' 941 registration');
              if r<>0 then
               begin
                 str:= Atol_v10_SetErrorInLog(r,'registration str='+str);
                //ShowMessage ('������ '+str);  07/07/2021
                 Result := False;
                 Exit;
               end;
          
   
            Dataset.NEXT;
        end; //while
    end;//if
    
         // ��� ������� ��� ���� ������� ��� �������� �� �������
   if (ATOL.Collapse = 1)or(Doplata=1) then
      begin
           SaveLogPlut('==Doplata   == V_10  '); 
           // ����������� ������ ��� ������
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	������� �������� �������
           dm.fptr.setParam(1212, 4);   //������� �������� �������	4 - ������
           //1214  	������� ������� �������
                
         //  dm.fptr.setParam(1214, 4);  16/06/2021
           // if pPay_packed.cdpayment>0 then
           //    begin
                case pPay_packed.cdpayment of
                 0,4:
                  begin
                     dm.fptr.setParam(1214,4);   // ������ ��� ��� 1.05. 4-������ ������
                     SaveLogPlut('--- 4 ������� ������� ������� (������ ������');
                  end;
                 3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                                       dm.fptr.setParam(1214,3)    //���������
                      else     dm.fptr.setParam(1214,4);         
                      SaveLogPlut('--- 3 ������� ������� ������� (��������� ������');
                   end;   
                     (* 1: begin
                          dm.fptr.setParam(1214,1);    
                         SaveLogPlut('--- 1 ������� ������� ������� (���������� 100 ');
                       end; *)  
                 end;
 
           cena:=summa;
           kol:=1;
            sum_p:= cena*kol;
           //  dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
          
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );  //������� �� ������
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
            tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            sumch := sum_p;
                SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                     +'summa= '+FloatToStr(summa)+ ' �����= ' +floattostr(summa*tax));                                       
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 990 registration');
            if r<>0 then
             begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
                  Atol_v10_SetErrorInLog(r,' 990 registration  str='+str);
             // ShowMessage ('������ '+str);
               Result := False;
               Exit;
             end; 
               SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(summa));    
      end; 
//������� ���
	if BezNal=true then 
       begin 
         SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 
        // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         //  SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE =1 ');

       end
    else  
       begin
        SaveLogPlut('! BezNal=False ������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // �������
         // dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
                dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
         //  SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE =0 ');

       end;
   
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
   SaveLogPlut('  end == oplata   ==  ;sumch= '+floatTostr(sumch));   
    
   r:= dm.fptr.payment;
      Atol_v10_SetErrorInLog(r,'payment');
   {== ���� -��� ��� ������� }
          {= ��� �� ������������}
    if check<>'' then
      begin
         SaveLogPlut(' = ��� �� ������������ ��� �������'); 
        dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
         r:= dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog(r,'setFooterLines');
        SaveLogPlut(check); 
      end;
    // �������� ����
     r:=dm.fptr.closeReceipt;
     //showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog(r,'closeReceipt');
    if r<> 0 then 
      begin 
        showmessage('������ closeReceipt rjl:'+IntTostr(r));
         result:=false;
         exit;
      end
      else result:=true;
 		//Sleep(1500);
    Atol_v10_CheckDocumentClose;
        //�������� ���������� � ���
    sleep(5);
    dm.fptr.close;  //???
    SaveLogPlut(' CloseCheck ' );
    SaveLogPlut(' ����� ����'+strPay );
       {= ��� �� ������������}
    (*if check<>'' then
      begin
        dm.fptr.Caption:=check;
        dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)


   SaveLogPlut('================������ new_1.051 end=================================== ');        

  SaveLogPlut('PrintCheck_atol_ end ����� cddoc= ' +  IntToStr(cddoc));
 


  except on e: exception do
    begin
     // showmessage('������: '+ e.Message);
      SaveLogPlut('������: '+ e.Message);
       r:=dm.fptr.cancelReceipt;
       dm.fptr.close;
       Atol_v10_SetErrorInLog(r,' 935 dm.fptr.cancelReceipt');
      Result:=False;
    end;
  end;
end;



{===================����======================}


{=������ ����� �� ������ ������� }

function PrintCheck_Atol_v10_1_051_new_test( const check: string;
                                    const CustomerEmail: string;//TypeOplat: TTypeOplat;
                                    OperType: integer;{>0 ������}DataSet: TDataSet; Summa: Double;
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

if check<>'' then Atol_v10_PrintBankSlip(check);/// ��� ������� ��� � ��������

  Result := False;
  SaveLogPlut('================v10 ������ 1.051 test=================================== ');  
    //�������� ���������� � ���
  //dm.fptr.open;
  //����������� �������
  //  Atol_v10_SetKassir_Inn;
  // SaveLogPlut('==='+CustomerEmail);
//��� ����
   case OperType of
     1: begin
         if (Doplata=1 ) then strPay:=' _�������_ ' 
           else  strPay:=' _������_ ';
         
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL           );
          SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL  �������'); 
        end;
     2: begin
         strPay:=' _�������_';
      
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL_RETURN                   ); 
         SaveLogPlut('OperType='+IntToStr(OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  �������');                     
        end;
   end;
   
   sumch := 0;
   kol:=0;     
  if check<>'' then
         begin
         {== ��� ��� �����}
          // SaveLogPlut('==== �������� ��� ������ �� ��� ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END �������� ��� ������ �� ��� ===============');
         end;      
 
  {=  �������� ������������ ����}
  if CustomerEmail<>'' then
     begin
  //    r:=dm.fptr.setParam(1008, CustomerEmail);
   	 // �������� ����� ��� ������������ ������
      SaveLogPlut('����� AttrNumber := 1008  AttrValue:='+CustomerEmail);
   	
      if r<>0 then
        begin
          Atol_v10_SetErrorInLog_test(r,'CustomerEmail');
          ShowMessage('������ CustomerEmail  ������ ��� ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= ����������� ������� ��������������� � ����:  � ����� ��������� ���}
 
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
    SaveLogPlut('������� ��������������� C�� :'+str+' '+ IntToStr(systnal));
  //  SaveLogPlut('==== Send ������� ���������������: ('+IntToStr( //dm.fptr.ErrorCode)+'): '+dm.fptr.ResultCodeDescription);

     Atol_v10_SetErrorInLog_test(1,'openReceipt');
   
  (*//r :=  dm.fptr.openReceipt;
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= //dm.fptr.cancelReceipt;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('������ cancelReceipt ������ ��� ');
       end; 
    end; *)   
   //������ ����������
 //dm.fptr.setParam( //dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  //dm.fptr.LIBFPTR_DT_STATUS);
 //dm.fptr.queryData;


  SaveLogPlut('===========����������� �������   ==============================');
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
            // ����������� ������ ��� ������
                     ////////������ ������     � �������
 
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
                     //�����
        //  cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
          cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
          cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);

           
          if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
                         
             sum_p:= cena*kol;
             
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) );          
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                          +' sum_p= '+FloatToStr(sum_p) + ' �����= ' +floatTostr(summa*tax)); 
                                                 
            //r  :=  //dm.fptr.registration;

            (*if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
              ShowMessage ('������ '+str);
              Result := False;
              Exit;
            end;  *)
             
            /// //dm.fptr.Taxtypenumber :=ATOL.cdTax;  //  ��� ��� - �� ���������
        
           // ������������ ������ ��� ������ ������ UslNameForCheck
           // � ��� 
            //  //dm.fptr.TextWrap:=2;
           // ������� �� ������-� ������ ������ ���������� ����������� ��������� ���������� ��������
            //   //dm.fptr.Name:=prom; 
            SaveLogPlut(' 1118'+prom);
             //  SaveLogPlut(' EndItem ');
             //  //dm.fptr.EndItem;        
            Dataset.NEXT;
        end; //while
      //end; // with
    end;
         // ��� ������� ��� ���� ������� ��� �������� �� �������
        if (ATOL.Collapse = 1)or(Doplata=1) then
         begin
           SaveLogPlut('1128 ==Doplata   == V_10  '); 
           // ����������� ������ ��� ������
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	������� �������� �������
           //dm.fptr.setParam(1212, 4);   //������� �������� �������	4 - ������
           //1214  	������� ������� �������
           //dm.fptr.setParam(1214, 4);
           cena:=summa;
           kol:=1;
      
 
            // //dm.fptr.Quantity := kol; //fieldbyname('KOLVO').Value;
             //dm.fptr.Price    := cena;
            // //dm.fptr.summ     := cena*kol;  ///????? ��������� 
            sum_p:= cena*kol;
            sumch:=sum_p;   
           //  //dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,atol.Section);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, //dm.fptr.LIBFPTR_TW_WORDS );  //������� �� ������
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('1153 '+prom); 
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
               +' summa= '+FloatToStr(summa)+ ' �����= ' +floattostr(summa*tax));                                       
            r  := 0; //dm.fptr.registration;
           SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(summa));    
         end; 
   //   end; // with
  //  end;    06/08/2020
//������� ���
	if BezNal=true then 
       begin 
         SaveLogPlut(' 1164 BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '); 
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, //dm.fptr.LIBFPTR_PT_ELECTRONICALLY)

       end
    else  
       begin
        SaveLogPlut('BezNal=False ������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         // �������
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, //dm.fptr.LIBFPTR_PT_CASH)

       end;
   
    //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
    //dm.fptr.payment;
            SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(sumch)); 
   {== ���� -��� ��� ������� }
          {= ��� �� ������������}
    if check<>'' then
      begin
        //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
     //  r:= //dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog_test(r,'setFooterLines');
         SaveLogPlut(check); 
      end;
    // �������� ����
    //r:=dm.fptr.closeReceipt;
    // showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog_test(r,'closeReceipt');
     result:=true;

		//Sleep(1500);
    //Atol_v10_CheckDocumentClose;
        //�������� ���������� � ���
      //  sleep(10);
    //dm.fptr.close;  //???
       
     SaveLogPlut(' CloseCheck ' );

    SaveLogPlut(' ����� ����'+strPay );
       {= ��� �� ������������}
    (*if check<>'' then
      begin
        //dm.fptr.Caption:=check;
        //dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)

//!!!!
   SaveLogPlut('================������ new_1.051_test end=================================== ');        
   nomcheck:=cddoc;
   
  SaveLogPlut('PrintCheck_atol_ end ' +  IntToStr(cddoc));
end;


{}
{=������ ����� �� ������ �������  ===    ����������}
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
if slip_check<>'' then Atol_v10_PrintBankSlip(slip_check);/// ��� ������� ��� � ��������
 try
  Result := False;
  SaveLogPlut('================ 659 v10 ������ 1.051=================================== ');  
    //�������� ���������� � ���
  dm.fptr.open;

    //������ ����������
   SaveLogPlut('====  dm.fptr.queryData ');
   dm.fptr.setParam( dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  dm.fptr.LIBFPTR_DT_STATUS);
   dm.fptr.queryData;
   nomcheck :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_RECEIPT_NUMBER);
   nomcheck:=nomcheck+1;
   SaveLogPlut('����� ����= '+IntToStr(nomcheck) );
   FNDoc :=  dm.fptr.getParamInt( dm.fptr.LIBFPTR_PARAM_DOCUMENT_NUMBER);
   FNDoc:=FNDoc+1;
   SaveLogPlut('����� ����.���= '+IntToStr(FNDoc) );
      SaveLogPlut('====  end dm.fptr.queryData ');

 //����������� �������
    Atol_v10_SetKassir_Inn;
    SaveLogPlut('660');  
//��� ����
   case pPay_packed.opertype of
     1: begin
         if (pPay_packed.Doplata=1 ) then strPay:=' _�������_ ' 
           else  strPay:=' _������_ ';
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL);
          SaveLogPlut(' 671 OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL  �������'); 
        end;
     2: begin
         strPay:=' _�������_';
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,dm.fptr.LIBFPTR_RT_SELL_RETURN); 
         SaveLogPlut('OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  �������');                     
        end;
   end;

 //  sumch := 0;
   kol:=0;     
 // if slip_check<>'' then
 //        begin
         {== ��� ��� �����}
          // SaveLogPlut('==== �������� ��� ������ �� ��� ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END �������� ��� ������ �� ��� ===============');
     //    end;      
 
  {=  �������� ������������ ����}
  if pPay_packed.CustomerEmail<>'' then
     begin
       SaveLogPlut('692 ����� ');
       r:=dm.fptr.setParam(1008, pPay_packed.CustomerEmail);
   	    // �������� ����� ��� ������������ ������
       SaveLogPlut('698 ����� AttrNumber := 1008  AttrValue:='+pPay_packed.CustomerEmail);
       if r<>0 then
        begin
          Atol_v10_SetErrorInLog(r,'CustomerEmail');
          ShowMessage('702 ������ CustomerEmail  ������ ��� ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= ����������� ������� ��������������� � ����:  � ����� ��������� ���}
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
    SaveLogPlut('������� ��������������� C�� :'+str+' '+ IntToStr(systnal));
    Atol_v10_SetErrorInLog(r,' dm.fptr.setParam(1055  ');
    SaveLogPlut('==== 739 Send ������� ���������������: ');
    {=��������\�� ������ ��� �� ���}
   if pPay_packed.isPrintCheck=False then
     begin
       SaveLogPlut('==== 2173 ��� �������� ��� isPrintCheck=Fflse ');
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
          ShowMessage('������ cancelReceipt ������ ��� ');
       end; 
    end;    
   
  SaveLogPlut('===========����������� �������  ==============================');
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
            // ����������� ������ ��� ������
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
           else   
             prom := dataset.fieldbyname('nmusl').Value;
         // prom := dataset.fieldbyname('nmusl').Value;
                     //�����
                      //1212          	������� �������� �������
            dm.fptr.setParam(1212, dataset.FieldByName('cdPrRasch').AsInteger);
              //1214  	������� ������� �������
            //  dm.fptr.setParam(1214, 4);     //16.06.2021
      
                case pPay_packed.cdpayment of
                 0,4: begin
                      dm.fptr.setParam(1214,4);   // ������ ��� ��� 1.05. 4-������ ������
                      SaveLogPlut('--- 4 ������� ������� ������� (������ ������');
                     end;
                  3: begin
                      if nastrList.Values['Real_Avans_InPay']='1' then
                          dm.fptr.setParam(1214,3)    //���������
                       else     dm.fptr.setParam(1214,4);         
                        SaveLogPlut('--- 3 ������� ������� ������� (��������� ������');
                       end;   
                  1: begin
                      
                      dm.fptr.setParam(1214,1);    
                      SaveLogPlut('--- 1 ������� ������� ������� (���������� 100 ');
                  end;
                end;   
      
     
              // cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
           cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
           cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);
           if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
             sum_p:= cena*kol;
             SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) ); 
     
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, sum_p);
           tax:=0;
           tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
           dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
              // sumch := sumch +  Math.RoundTo(fieldbyname('uslugVozvrSum').Value,-2); 
           
            SaveLogPlut('���. '+prom+'  cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                          +'sum_p= '+FloatToStr(sum_p) + ' �����= ' +floatTostr(pPay_packed.summa*tax)); 
                                                 
            r  :=  dm.fptr.registration;
            Atol_v10_SetErrorInLog(r,' 941 registration');
            if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration str='+str);
              //ShowMessage ('������ '+str);  07/07/2021
              Result := False;
              Exit;
            end;
          Dataset.NEXT;
        end; //while

    end;
    
         // ��� ������� ��� ���� ������� ��� �������� �� �������
if (ATOL.Collapse = 1)or(pPay_packed.Doplata=1) then
  begin
   SaveLogPlut('==Doplata   == V_10  '); 
   // ����������� ������ ��� ������
   prom :=  '';
   prom := ATOL.CheckText;
   //1212          	������� �������� �������
   dm.fptr.setParam(1212, 4);   //������� �������� �������	4 - ������
   //1214  	������� ������� �������
                
 //  dm.fptr.setParam(1214, 4);  16/06/2021
   
        case pPay_packed.cdpayment of
         0,4: begin
            dm.fptr.setParam(1214,4);   // ������ ��� ��� 1.05. 4-������ ������
             SaveLogPlut('--- 4 ������� ������� ������� (������ ������');
          end;
         3: begin
             if nastrList.Values['Real_Avans_InPay']='1' then
                  dm.fptr.setParam(1214,3)    //���������
                else     dm.fptr.setParam(1214,4);         
             SaveLogPlut('--- 3 ������� ������� ������� (��������� ������');
           end;   
           (* 1: begin
                      
              dm.fptr.setParam(1214,1);    
             SaveLogPlut('--- 1 ������� ������� ������� (���������� 100 ');
              end; *)  
        end;
    cena:=pPay_packed.summa;
   kol:=1;

    sum_p:= cena*kol;
            
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,0);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, dm.fptr.LIBFPTR_TW_WORDS );  //������� �� ������
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, pPay_packed.summa);
    tax:=0;
    tax:=Atol_v10_SetTaxMode(dataset.FieldByName('cdtax').Value);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
    dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
    sumch := sum_p;
      SaveLogPlut('2357  sumch='+FloatTostr(sumch));
 
        SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
             +'summa= '+FloatToStr(pPay_packed.summa)+ ' �����= ' +floattostr(pPay_packed.summa*tax));                                       
    r  :=  dm.fptr.registration;
    Atol_v10_SetErrorInLog(r,' 990 registration');
    if r<>0 then
    begin
      str:= Atol_v10_SetErrorInLog(r,'registration');
          Atol_v10_SetErrorInLog(r,' 990 registration  str='+str);
     // ShowMessage ('������ '+str);
      Result := False;
      Exit;
    end; 
       SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(pPay_packed.summa));    
  end; 



//������� ���

   SaveLogPlut('2357 !!!!! printCheckOn_Atol_new sumAvans='+FloatTostr(pPay_packed.summaAvans)
      +'  sum_beznal='+FloatTostr(pPay_packed.summCard)+
       ' sum_nal= '+FloatTostr(pPay_packed.summCash)+#13+'pPay_packed.BezNal='+BoolToStr(pPay_packed.BezNal) );

  if pPay_packed.summCard>0 then
        begin
          SaveLogPlut(' 1164 BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '); 
          SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCard)); 
     
                  SaveLogPlut(' !BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '
                      +'__'+INTtoStr(dm.fptr.LIBFPTR_PT_ELECTRONICALLY)); 
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY);
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE,1);
       
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCard);
          r:= dm.fptr.payment;   
          Atol_v10_SetErrorInLog(r,'payment_summCard>'); 
        
         end;
  if pPay_packed.summCash>0 then
       begin   
         SaveLogPlut('BezNal=False ������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCash)); 
         // �������
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH);
             
         dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCash);
          r:= dm.fptr.payment;   
          Atol_v10_SetErrorInLog(r,'payment_summCash>');
   
       end;     
        {=����� ������}
  if pPay_packed.summaAvans>0 then
       begin   
         SaveLogPlut('������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_PREPAID'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summaAvans)); 
         // �������
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_PREPAID);
          dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summaAvans);
          r:= dm.fptr.payment;   
          Atol_v10_SetErrorInLog(r,'payment_summaAvans>');
       end;     
     
   dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
   SaveLogPlut('  end == oplata   ==  ;sumch= '+floatTostr(sumch));   
    
   r:= dm.fptr.payment;   //���� ���!!!
   Atol_v10_SetErrorInLog(r,'payment_sumch');
  
   (*       {= ��� �� ������������}   {== ���� -��� ��� ������� }
    if slip_check<>'' then
      begin
         SaveLogPlut(' = ��� �� ������������ ��� �������'); 
        dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, slip_check);
         r:= dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog(r,'setFooterLines');
        SaveLogPlut(slip_check); 
      end;  *)
    // �������� ����
     r:=dm.fptr.closeReceipt;
     //showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog(r,'closeReceipt');
    if r<> 0 then 
      begin 
        showmessage('������ closeReceipt :'+IntTostr(r));
         result:=false;
         r:=dm.fptr.cancelReceipt;
         Atol_v10_SetErrorInLog(r,'cancelReceipt');
         dm.fptr.close;
         exit;
      end
      else result:=true;
 		//Sleep(1500);
    Atol_v10_CheckDocumentClose;
        //�������� ���������� � ���
    sleep(5);
    dm.fptr.close;  //???
    SaveLogPlut(' CloseCheck ' );
    SaveLogPlut(' ����� ����'+strPay );
       {= ��� �� ������������}
    (*if check<>'' then
      begin
        dm.fptr.Caption:=check;
        dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)


   SaveLogPlut('================������ smesh_1.05 end=================================== ');        

  SaveLogPlut('PrintCheck_atol_ end ����� cddoc= ' +  IntToStr(pPay_packed.pcddoc));
 
 except on e: exception do
    begin
     // showmessage('������: '+ e.Message);
      SaveLogPlut('������: '+ e.Message);
       r:=dm.fptr.cancelReceipt;
       dm.fptr.close;
       Atol_v10_SetErrorInLog(r,' 2416 dm.fptr.cancelReceipt');
      Result:=False;
    end;
  end;
end;




    {== ����  
       ������ ��� ������ ����� ����� �����  ��������� ������ �����}                                           
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
if slip_check<>'' then Atol_v10_PrintBankSlip(slip_check);/// ��� ������� ��� � ��������

  Result := False;
  SaveLogPlut('================v1 ������ 1.05 ����� ������ �������� test=================================== ');  
    //�������� ���������� � ���
  //dm.fptr.open;
  //����������� �������
  //  Atol_v10_SetKassir_Inn;
  // SaveLogPlut('==='+CustomerEmail);
//��� ����

   case pPay_packed.OperType of
     1: begin
        // if (pPay_packed.Doplata=1 ) then strPay:=' ������� '              else  
           strPay:=' _������_ ';
         
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL           );
          SaveLogPlut('OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL  �������'); 
        end;
     2: begin
         strPay:=' _�������_';
      
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_RECEIPT_TYPE,
                              //dm.fptr.LIBFPTR_RT_SELL_RETURN                   ); 
         SaveLogPlut('OperType='+IntToStr(pPay_packed.OperType)+'dm.fptr.LIBFPTR_RT_SELL_RETURN  �������');                     
        end;
   end;
   
   sumch := 0;
   kol:=0;     
  if slip_check<>'' then
         begin
         {== ��� ��� �����}
          // SaveLogPlut('==== �������� ��� ������ �� ��� ===============');
          // Result:=printPrintHeaderInCheck(check,True);
          // SaveLogPlut('==== END �������� ��� ������ �� ��� ===============');
         end;      
 
  {=  �������� ������������ ����}
  if pPay_packed.CustomerEmail<>'' then
     begin
  //    r:=dm.fptr.setParam(1008, CustomerEmail);
   	 // �������� ����� ��� ������������ ������
      SaveLogPlut('����� AttrNumber := 1008  AttrValue:='+pPay_packed.CustomerEmail);
   	
      if r<>0 then
        begin
          Atol_v10_SetErrorInLog_test(r,'CustomerEmail');
          ShowMessage('������ CustomerEmail  ������ ��� ');
          result:=false;
        end;
     end;
  // systnal:=setTaxSystemNalogAtolShtrih(Atol.TaxSystemNalog);
       {= ����������� ������� ��������������� � ����:  � ����� ��������� ���}
 
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
    SaveLogPlut('������� ��������������� C�� :'+str+' '+ IntToStr(systnal));
  //  SaveLogPlut('==== Send ������� ���������������: ('+IntToStr( //dm.fptr.ErrorCode)+'): '+dm.fptr.ResultCodeDescription);

     Atol_v10_SetErrorInLog_test(1,'openReceipt');
   
  (*//r :=  dm.fptr.openReceipt;
   if r<>0 then
    begin
     Atol_v10_SetErrorInLog(r,'openReceipt');
      r:= //dm.fptr.cancelReceipt;
     if r<0 then
       begin
          Atol_v10_SetErrorInLog(r,'openReceipt');
          ShowMessage('������ cancelReceipt ������ ��� ');
       end; 
    end; *)   
   //������ ����������
 //dm.fptr.setParam( //dm.fptr.LIBFPTR_PARAM_DATA_TYPE,  //dm.fptr.LIBFPTR_DT_STATUS);
 //dm.fptr.queryData;


  SaveLogPlut('===========����������� �������   ==============================');
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
            // ����������� ������ ��� ������
           
         ///////// ����� ������ �������� � ������� 
      
         SaveLogPlut( 'nastrList.Values[NewFormat]=1');
         sumch := sumch + Math.RoundTo(dataset.fieldbyname('uslugSUM').Value,-2);
         kol:=  dataset.fieldbyname('KOLVO').Value;
         SaveLogPlut('=== ������ �� ���� ===');
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
             showmessage(' ������ ��� ������������ ������ !');
             exit;
           end;
             
        
         ///////// ����� ������ �������� � ������� 
     
          prom :=  '';
          if nastrList.Values['Kod_usl']='1' then
             prom:=  dataset.fieldbyname('cdusl_u').Value
          else   
          
             prom := dataset.fieldbyname('nmusl').Value;
                     //�����
        //  cena:= Math.RoundTo(dataset.FieldByName('cenausl').asFloat,-2);
          cenaProc    := DataSet.FieldByName('cenausl').asFloat*(100-DataSet.FieldByName('procent').asFloat)/100;
          cena        :=Math.RoundTo(cenaProc-DataSet.FieldByName('bonus').asFloat,-2);

           
          if (nastrlist.Values['USE_ROUND']='1') then cena:=rnd(cena);
                         
             sum_p:= cena*kol;
             
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)+ ' sum_p='+FloatTostr(sum_p) );          
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
                          +' sum_p= '+FloatToStr(sum_p) + ' �����= ' +floatTostr(pPay_packed.summa*tax)); 
                                                 
            //r  :=  //dm.fptr.registration;

            (*if r<>0 then
            begin
              str:= Atol_v10_SetErrorInLog(r,'registration');
              ShowMessage ('������ '+str);
              Result := False;
              Exit;
            end;  *)
             
            /// //dm.fptr.Taxtypenumber :=ATOL.cdTax;  //  ��� ��� - �� ���������
        
           // ������������ ������ ��� ������ ������ UslNameForCheck
           // � ��� 
            //  //dm.fptr.TextWrap:=2;
           // ������� �� ������-� ������ ������ ���������� ����������� ��������� ���������� ��������
            //   //dm.fptr.Name:=prom; 
            SaveLogPlut(' 1118'+prom);
             //  SaveLogPlut(' EndItem ');
             //  //dm.fptr.EndItem;        
            Dataset.NEXT;
        end; //while
      //end; // with
    end;
         // ��� ������� ��� ���� ������� ��� �������� �� �������
        if (ATOL.Collapse = 1)or(pPay_packed.Doplata=1) then
         begin
           SaveLogPlut('1128 ==Doplata   == V_10  '); 
           // ����������� ������ ��� ������
           prom :=  '';
           prom := ATOL.CheckText;
           //1212          	������� �������� �������
           //dm.fptr.setParam(1212, 4);   //������� �������� �������	4 - ������
           //1214  	������� ������� �������
          {pPay_packed.cdpayment=4 ������ ������ 3-�����}
            SaveLogPlut('  1214 ������� ������� ������� 4-������ ������, 3-�����;c dpayment= '+IntTostr(pPay_packed.cdpayment));    
           //dm.fptr.setParam(1214, pPay_packed.cdpayment);
           cena:=pPay_packed.summa;
           kol:=1;
      
 
            // //dm.fptr.Quantity := kol; //fieldbyname('KOLVO').Value;
             //dm.fptr.Price    := cena;
            // //dm.fptr.summ     := cena*kol;  ///????? ��������� 
            sum_p:= cena*kol;
            sumch:=sum_p;   
          //// //  //dm.fptr.setParam(dm.fptr. LIBFPTR_PARAM_INFO_DISCOUNT_SUM,SkidkaInfo);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_DEPARTMENT,atol.Section);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT_WRAP, //dm.fptr.LIBFPTR_TW_WORDS );  //������� �� ������
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_COMMODITY_NAME, prom);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PRICE, cena);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_QUANTITY, kol);
            //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_POSITION_SUM, summa);
            tax:=0;
             tax:=Atol_v10_SetTaxMode_test(dataset.FieldByName('cdtax').Value);
               SaveLogPlut('1153 '+prom); 
            SaveLogPlut('cena: ' + FloatTostr(cena)+ ' ���: '+prom+' Quantity=' + FloatTostr(kol)
               +' summa= '+FloatToStr(pPay_packed.summa)+ ' �����= ' +floattostr(pPay_packed.summa*tax));                                       
            r  := 0; 
            //dm.fptr.registration;
           SaveLogPlut('  end ==Doplata   == '+prom +' ;summa= '+floatTostr(pPay_packed.summa));    
         end; 
   //   end; // with
  //  end;    06/08/2020
//������� ���
      if pPay_packed.summCard>0 then
        begin
          SaveLogPlut(' 1164 BezNal=true  ����������� ������ LIBFPTR_PARAM_PAYMENT_TYPE = LIBFPTR_PT_ELECTRONICALLY '); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCard)); 
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_ELECTRONICALLY)
         //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCard);
         //dm.fptr.payment;
         end;
      if pPay_packed.summCash>0 then
       begin   
         SaveLogPlut('BezNal=False ������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_CASH'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summCash)); 
         // �������
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_CASH)
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCash);
         //dm.fptr.payment;
       end;   

       {=����� ������}
       if pPay_packed.summaAvans>0 then
       begin   
         SaveLogPlut('������� LIBFPTR_PARAM_PAYMENT_TYPE=LIBFPTR_PT_PREPAID'); 
         SaveLogPlut('dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch='+floatTostr(pPay_packed.summaAvans)); 
         // �������
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_TYPE, dm.fptr.LIBFPTR_PT_PREPAID)
          //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, pPay_packed.summCash);
         //dm.fptr.payment;
       end;
   
    //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_PAYMENT_SUM, sumch);
    //dm.fptr.payment;
          
   {== ���� -��� ��� ������� }
          {= ��� �� ������������}
    if slip_check<>'' then
      begin
        //dm.fptr.setParam(dm.fptr.LIBFPTR_PARAM_TEXT, check);
     //  r:= //dm.fptr.setFooterLines;
         Atol_v10_SetErrorInLog_test(r,'setFooterLines');
         SaveLogPlut(slip_check); 
      end;
    // �������� ����
    //r:=dm.fptr.closeReceipt;
    // showmessage(dm.fptr.errorDescription);
     Atol_v10_SetErrorInLog_test(r,'closeReceipt');
     result:=true;

		//Sleep(1500);
    //Atol_v10_CheckDocumentClose;
        //�������� ���������� � ���
      //  sleep(10);
    //dm.fptr.close;  //???
       
     SaveLogPlut(' CloseCheck ' );

    SaveLogPlut(' ����� ����'+strPay );
       {= ��� �� ������������}
    (*if check<>'' then
      begin
        //dm.fptr.Caption:=check;
        //dm.fptr.PrintString;
        SaveLogPlut(check); 
      end;   *)

//!!!!
   SaveLogPlut('================������ 1.051_test end=================================== ');        
   nomcheck:=pPay_packed.pcddoc;
   
  SaveLogPlut('PrintCheck_atol_ end ' +  IntToStr(pPay_packed.pcddoc));
end;

{===}

{--======== =====      }




{===========================}



end.
