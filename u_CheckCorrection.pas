unit u_CheckCorrection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Mask, rxToolEdit, AdvSmoothButton, StdCtrls,
  AdvOfficeButtons, AdvSmoothPanel, DBGridEh, DBCtrlsEh, DBLookupEh, frxpngimage,
  DB, ADODB;

type
  TfmCorrection = class(TForm)
    AdvSmoothPanel1: TAdvSmoothPanel;
    Label1: TLabel;
    rbPrihod: TAdvOfficeRadioButton;
    rbRashod: TAdvOfficeRadioButton;
    AdvSmoothPanel3: TAdvSmoothPanel;
    Label2: TLabel;
    EditSummCash: TEdit;
    Label4: TLabel;
    EditSummNonCash: TEdit;
    Label5: TLabel;
    AdvSmoothPanel4: TAdvSmoothPanel;
    bPrintCorrection: TAdvSmoothButton;
    bCancelCheck: TAdvSmoothButton;
    AdvSmoothPanel2: TAdvSmoothPanel;
    Label3: TLabel;
    EditDocCorrection: TEdit;
    EditDateDocCorrection: TDateEdit;
    EditNomDocCorrection: TEdit;
    rbCorrectionType1: TAdvOfficeRadioButton;
    rbCorrectionType0: TAdvOfficeRadioButton;
    Image1: TImage;
    Image2: TImage;
    lookupsltax: TDBLookupComboboxEh;
    Label6: TLabel;
    Label7: TLabel;
    edSumAvans: TEdit;
    Image3: TImage;
    ednumChek: TEdit;
    Label8: TLabel;
    qSltax: TADOQuery;
    dsSltax: TDataSource;
    bExit: TAdvSmoothButton;
    ed: TEdit;
    Label9: TLabel;
    edkol: TEdit;
    Label10: TLabel;
    procedure bCancelCheckClick(Sender: TObject);
    procedure bPrintCorrectionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  
  end;

var
  fmCorrection: TfmCorrection;

implementation
uses u_viki_print,u_dm,U_const,u_Atol_8,u_Atol_10,dmlog;

{$R *.dfm}

procedure TfmCorrection.bExitClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfmCorrection.bCancelCheckClick(Sender: TObject);
var s : string;
begin
  case  TypeKassa of
      pVikiPrint : VikiCancelDocument;
      pAtol      : Atol_CancelCheck;
  end;
      s:=' Отмена чека  пользователь '+ USERNM;

     DataModuleLOG.LogExecutePar(now(),'Платные+ Чек коррекции'  ,LOG_LEVEL_Soob,s);  

end;

procedure TfmCorrection.bPrintCorrectionClick(Sender: TObject);
var  SummCash      : Double;
     SummNonCash   : Double;
      SummAvans      : Double;
     isPrihod      : boolean;
     CorrTypeSamost: boolean;
     dt:Tdatetime;
     nameCorre,s,s1,NDoc :string;
      numcheck,fndoc,cdtax :integer;

begin
 s:='';
 dt:=0;
 if rbCorrectionType1.checked then
  begin
  if Trim(EditDocCorrection.Text)=''  then
   begin
     s:=s+'Не заполнена причина '+#13#10;
     ShowMessage(s);
     EditDocCorrection.SetFocus;
     exit; 
   end;

  if Trim(EditNomDocCorrection.Text)=''  then
     begin
       s:=s+'Не заполнен № документа'+#13#10;
       ShowMessage(s);
       EditNomDocCorrection.SetFocus;
       exit; 
     end;

  if (Trim(EditDateDocCorrection.Text)='') or (Trim(EditDateDocCorrection.Text)='.  .')
    then begin
           s:=s+'Не заполнена Дата документа'+#13#10;
           ShowMessage(s);
           EditDateDocCorrection.SetFocus;
           exit; 
         end;
  end;

    if Trim(Ed.Text)=''  then
   begin
     s:=s+'Не заполнена услуга '+#13#10;
     ShowMessage(s);
     ed.SetFocus;
     exit; 
   end;

  // Если поле с суммой пустое, то записываем '0'
  if trim(EditSummCash.Text)='' then EditSummCash.Text:='0';
  if trim(EditSummNonCash.Text)='' then EditSummNonCash.Text:='0';

  
  // Проверка корректности наличной суммы
 if EditSummCash.Text<>'0' then

  try
    SummCash:=strtofloat(trim(EditSummCash.Text));
  except on E:exception do
    begin
      s:=s+'Чек коррекции. Ошибка преобразования наличных!!! '+trim(EditSummCash.Text)+#13#10+E.Message;
      ShowMessage('Чек коррекции. Ошибка преобразования наличных!!! '+trim(EditSummCash.Text)+#13#10+E.Message);
      EditSummCash.SetFocus;
      exit;
    end;
  end;
  if EditSummNonCash.Text<>'0' then

  try
    SummNonCash:=strtofloat(trim(EditSummNonCash.Text));
  except on E:exception do
    begin
      s:=s+'Чек коррекции. Ошибка преобразования наличных!!! '+trim(EditSummNonCash.Text)+#13#10+E.Message;
      ShowMessage('Чек коррекции. Ошибка преобразования наличных!!! '+trim(EditSummNonCash.Text)+#13#10+E.Message);
      EditSummNonCash.SetFocus;
      exit;
    end;
  end;

  if (trim(EditSummCash.Text)='0') and (trim(EditSummNonCash.Text)='0') then
  begin
    s:=s+#13#10+'Чек коррекции. Не указана ни одна сумма!!!';
    ShowMessage(s);
    EditSummNonCash.SetFocus;
    exit;
  end;

  isPrihod:= rbPrihod.Checked;
  CorrTypeSamost:= rbCorrectionType0.Checked;
  if rbCorrectionType1.checked=true then
     dt:=EditDateDocCorrection.date; 
     if isPrihod =true then s1:='Приход коррекции '
      else s1:='Возврат коррекции ';
    if rbCorrectionType0.Checked then s1:=s1+ '1173 CorrType= Самостоятельно  '
  else   s1:=s1+ ' 1173 CorrType = По предписанию   ';
     
    
 case  TypeKassa of
    pVikiPrint :
      begin      
         cdtax:=  qsltax.fieldbyNAme('cdtax_Viki').AsInteger;
         Viki_CorrectionCheck1_05( StrToFloat(EditSummCash.Text),
                        StrToFloat(EditSummNonCash.Text),
                        StrToFloat(edSumAvans.Text),
                        cdtax,isPrihod,rbCorrectionType0.Checked,
                            EditDocCorrection.text,
                            EditNomDocCorrection.Text,
                            dt,strtoint(ednumChek.Text));
           s1:=s1+' ВикиПринт ';                      
        end;
   pAtol :
      begin
        cdtax:=  qsltax.fieldbyNAme('cdtax_atol').AsInteger;
      case drvAtol of
          8: begin
               Atol_CorrectionCheck_1_05( StrToFloat(EditSummCash.Text),
                        StrToFloat(EditSummNonCash.Text),
                        StrToFloat(edSumAvans.Text),
                        cdtax,isPrihod,rbCorrectionType0.Checked,
                            EditDocCorrection.text,
                            EditNomDocCorrection.Text,
                            dt,strtoint(ednumChek.Text));
                end;
    
        10: begin   
               {=чек коррекции 10}
                Atol_v10_CorrectionCheck_1_05(StrToFloat(EditSummCash.Text),
                        StrToFloat(EditSummNonCash.Text),
                        StrToFloat(edSumAvans.Text),
                        cdtax,isPrihod,rbCorrectionType0.Checked,
                            EditDocCorrection.text,
                            EditNomDocCorrection.Text,
                            dt, ed.Text,strtoint(edkol.Text),
                            numcheck,fndoc);
                            ednumChek.Text:= IntToStr(fndoc);
                   s1:=s1+' Атол 10';                
             end;
       
           end;
    //  end;
                        
      end;     
    
  end;

     s:=s1+'  ;1177 nameCorre= ' +EditDocCorrection.text+
                  ' ;1178 дата= '+DateToStr(dt)+ ';1179 Номер документа NDoc=' +EditNomDocCorrection.Text 
                  +' ;Сумма_безнал='+EditSummNonCash.Text
                  +' ;Сумма_нал='+EditSummCash.Text
                  +' ;Сумма_предоплата='+edSumAvans.Text +' ;пользователь: '+ USERNM;

     DataModuleLOG.LogExecutePar(now(),'Платные+.Счет Чек коррекции'  ,LOG_LEVEL_Soob,s);   
   //  EditSummCash.Text:='0';
   //  EditSummNonCash.Text:='0';

end;

procedure TfmCorrection.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   qSlTax.close;
end;

procedure TfmCorrection.FormShow(Sender: TObject);
begin
  qSlTax.open;
  lookupsltax.KeyValue:=0;
end;

end.
