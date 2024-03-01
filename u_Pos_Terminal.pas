unit u_Pos_Terminal;


interface

    uses SysUtils,Forms,Windows,Dialogs,Utils;

 type
  TOpetationTypes=(OP_PURCHASE=1,OP_CASH,OP_RETURN, OP_BALANCE,OP_FUNDS,OP_ADD_AUTH,
                   OP_CANC_AUTH{������ ���������������},OP_PREAUTH);




// ��������� ������
  PAuthAnswer = ^TAuthAnswer;
  TAuthAnswer = packed record
    TType: integer;
    // IN ��� ���������� (1 - ������, 3 - �������/������ ������, 7 - ������ ������)
    Amount: cardinal; // IN ����� �������� � ��������
    Rcode: array [0 .. 2] of AnsiChar;
    // OUT ��������� ����������� (0 ��� 00 - �������� �����������, ������ �������� - ������)
    AMessage: array [0 .. 15] of AnsiChar;
    // OUT � ������ ������ � ����������� �������� ������� ��������� � ������� ������
    CType: integer;

    { OUT ��� ����������� �����. ��������� ��������:
      1 � VISA
      2 � MasterCard
      3 � Maestro
      4 � American Express
      5 � Diners Club
      6 � VISA Electron 

      }
    Check: PAnsiChar;
    FLastError: integer;
    // OUT ��� �������� ����������� �������� ����� ���������� ����, ������� ���������� ��������� ������ ��������� �� ������, � ����� ���������� ������� ������� GlobalFree()
    // ����� ����� �������� nil. � ���� ������ ������� �������� � ��� ���������� ��������� ��������� �� ������.
     end;


    PAuthAnswer2 = ^TAuthAnswer2;
    TAuthAnswer2 = packed record
    AuthAnswer: TAuthAnswer;
    // ����/�����: �������� ��������� �������� (��.����)
    AuthCode: array [0 .. 6] of AnsiChar; // ��� �����������
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ��� �����������. ��� �������� �� ����� �������� ���� ����� ��������� ��������� �*�.
   end;


     

     {= ���������� TAuthAnswer+ ���� ��� �� ����}
    PAuthAnswer6 = ^TAuthAnswer6;
    TAuthAnswer6 = packed record
     AuthAnswer: TAuthAnswer;
     AuthCode: array [0 .. 6] of AnsiChar; // ��� �����������
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ��� �����������. ��� �������� �� ����� �������� ���� ����� ��������� ��������� �*�.
     CardID: array [0 .. 24] of AnsiChar; // ����� �����
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ����� �����. ��� ������������� ���� ��� �������, ����� ������ 6 � ��������� 4, ����� �������� ��������� �*�.
    ErrorCode: integer;
    TransDate : array [0 .. 12] of AnsiChar;///���� � ����� ��������
    TransNumber: integer; //����� ���� ��� ���������
     RRN : array [0 .. 11] of AnsiChar;    (*����� ������ ��������, ����������� ������. ������������ ��� �������� ������� � ������������� �����������.
                     �������� ���������� 12-������� ��������� �����.*)
     (*� struct auth_answer auth_answ
� char AuthCode [MAX_AUTHCODE]
� char CardID [CARD_ID_LEN]
� int ErrorCode
� char TransDate [TRANSDATE_LEN]
� int TransNumber
� char RRN [MAX_REFNUM]*)
    
    end;

    pAuthAnswer5=^TAuthAnswer5;
    TAuthAnswer5 = packed record
      AuthAnswer: TAuthAnswer;
      RRN :array [0 .. 11] of AnsiChar; 
      AuthCode : array [0 .. 6] of AnsiChar;
    end;


         {= ���������� TAuthAnswer+ ���� ��� �� ����}
    PAuthAnswer7 = ^TAuthAnswer7;
    TAuthAnswer7 = packed record
     AuthAnswer: TAuthAnswer;
     AuthCode:PAnsiChar;// array [0 .. 6] of AnsiChar; // ��� �����������
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ��� �����������. ��� �������� �� ����� �������� ���� ����� ��������� ��������� �*�.
     CardID: array [0 .. 24] of AnsiChar; // ����� �����
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ����� �����. ��� ������������� ���� ��� �������, ����� ������ 6 � ��������� 4, ����� �������� ��������� �*�.
    SberOwnCard: integer;
    end;
    
      {=���������� TAuthAnswer+ ���� ��� �� ����+ �������� ��� ���������� ������� }
   PAuthAnswer9 = ^TAuthAnswer9;
   TAuthAnswer9 = packed record
    AuthAnswer: TAuthAnswer;
    // ����/�����: �������� ��������� �������� (��.����)
    AuthCode: array [0 .. 6] of AnsiChar; // ��� �����������
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ��� �����������. ��� �������� �� ����� �������� ���� ����� ��������� ��������� �*�.
    CardID: array [0 .. 24] of AnsiChar; // ����� �����
    // OUT ��� �������� ����������� (�� ������������� �����) �������� ����� �����. ��� ������������� ���� ��� �������, ����� ������ 6 � ��������� 4, ����� �������� ��������� �*�.
    SberOwnCard: integer;
    // OUT �������� 1, ���� ����������� ����� ������ ����������, ��� 0 � � ��������� ������
     Hash: array [0 .. 40] of AnsiChar;
    // OUT ��� SHA1 �� ������ ����� � ������� ASCIIZ
   end;


                   
 TPinPad_pilot_nt = class(TObject)
  private 
    FLibHandle : HModule;
    FAuthCode  : String;
    FCardID    : String;  //
    FRRN       : String;
    FCheck     : String;
    fErrProc   : integer;
    fTerminalID:pChar;
    FLastErrorMessage :string;
    fAuthAnswer : TAuthAnswer;
    fAuthAnswer6: TAuthAnswer6;
    fAuthAnswer2: TAuthAnswer2;
    fAuthAnswer5: TAuthAnswer5;
    FTestPinpad    : function :integer; stdcall;
    fGetVer        : function :cardinal;stdcall;
    fget_statistics : function(auth_ans: PAuthAnswer):integer;stdcall;
    fGetTerminalID : function (pTerminalID: pChar) :integer; stdcall;
    fSuspendTrx    : function (dwAmount: cardinal; pAuthCode: pChar):integer; stdcall;
    fRollbackTrx   : function (dwAmount: cardinal; pAuthCode: pChar):integer; stdcall;
    fCommitTrx     : function (dwAmount: cardinal; pAuthCode: pChar):integer; stdcall;
    fAbortTrx      : function (dwAmount: cardinal; pAuthCode: pChar):integer; stdcall;
    fCard_authorize  : function (track2: Pchar; auth_ans: PAuthAnswer):integer; stdcall;
    fCard_authorize5 : function(track2: Pchar; auth_ans: PAuthAnswer5):integer;stdcall;
    fCard_authorize6 : function(track2: Pchar; auth_ans: PAuthAnswer6):integer;stdcall;
    fCloseDay  : function(auth_ans: PAuthAnswer): integer;stdcall;
    fpathNm    : string;   // ���� � ����� ����
    fSaveLoginLocal: integer;// ��������� � ��������� ����� ��� ���
     procedure   ClearBuffers;
  public 
     constructor Create(const pathLib :string; const SaveLoginLocal:integer;const pathNmLog:string );
  destructor  Destroy; override; 

     property check: String read FCheck;
     property CardID: String read FCardID;
     property AuthCode : string read FAuthCode;
     property SaveLogInLocal : integer read fSaveLoginLocal  write fSaveLoginLocal default 0;//  ������
     property pathNmLog : string read fpathNm write fpathNm;
     
     function  TestPingPinpad :integer; 
     function  GetVersion :integer;
     function  Card_authorize  (Summ: cardinal; Operation: integer): integer;
    // function  Card_authorize6 (Summ: cardinal; Operation: integer):integer;
     function  Card_authorize6 (Summ: cardinal; Operation: integer; PFile: string): integer;
     //function  Card_authorize6_2022 (Summ: cardinal; Operation: integer; PFile: string): integer;
     function  Card_authorize5 (Summ: cardinal; Operation: integer;RNN:string):integer;
     function  Get_statistics():integer;
  //   function  Card_authorize2(Summ: cardinal; Operation: integer): integer;
     function  SuspendTrx (Summ: cardinal; pAuthCode: pChar):integer;
     function  RollbackTrx(Summ: cardinal; pAuthCode: pChar):integer;
     function  CommitTrx  (Summ: cardinal; pAuthCode: pChar):integer;
     function  AbortTrx   (Summ: cardinal; pAuthCode: pChar):integer;
    // function  CloseSmena_old: integer;
     function  CloseSmena(): integer;
     function  GetTerminalID: integer;
     function  XSmena(): integer;    
      
     procedure SaveLogPinPad1(const mes_log:string);
    
 
 end;

 
      {= X ����� ������}
    function XSmena_posTerminal(var slipcheck:AnsiString) :Ansistring;
          {=��������� ����� ������}
    {=��������� ����� ������}
   function CloseSmena_posTerminal(var slipcheck: AnsiString) :Ansistring; 

   //procedure SaveLogPos(s: string;const logName: string='Tech_log.log');
implementation
uses u_const;



 
constructor TPinPad_pilot_nt.Create(const pathLib: string; const SaveLoginLocal:integer;const pathNmLog:string );
begin
//  fErrProc:=555;
  fSaveLogInLocal:=SaveLoginLocal;
  fpathNm        :=pathNmLog;
  SaveLogPlut('������ ����� � ������ ��� ���� ����: '+pathNmLog);
  FLibHandle     := LoadLibrary(PChar(pathLib));
  if FLibHandle = 0 then
    raise exception.CreateFmt('������ ������� pilot_nt ���������� %s', [pathLib]);
end;

destructor TPinPad_pilot_nt.Destroy;
begin
  inherited;
   ClearBuffers;
   FreeLibrary(FLibHandle);

end;


function TPinPad_pilot_nt.XSmena(): integer;
// ������ ������ ������(�������� ���)
var s, str, FLastErrorMidessage : string;
    id, FLastError: integer;
    F: TextFile;
begin
FLastError:=0;
      SaveLogPlut('356 TPinPad_pilot_nt.XSmena ========   get_statistics_begin =========');
  Result:=1;
  ClearBuffers;
  fAuthAnswer.Amount := 0;
  fAuthAnswer.TType := 0;
  fAuthAnswer.CType := 0;
  fAuthAnswer.Check  := PAnsiChar('');

  id:=fErrProc;
  //fGetStatistics:= GetProcAddress(FLibHandle,'_get_statistics');
  fCloseDay := GetProcAddress(FLibHandle,'_get_statistics');
  If @fCloseDay = nil then
  begin
    str:='���������� ��������� ������� _get_statistics';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
   // SaveLogPinPad(str+ intTostr(id));
     SaveLogPlut(str+ intTostr(id));
    Exit;
  End;

  try
   id := fCloseDay(@fAuthAnswer);
    Result:=  id;
    if @fAuthAnswer=nil then
      ShowMessage('������ ����!');
   // FLastErrorMidessage := AnsiString(@fAuthAnswer.AMessage);
//    FCheck := Utils.OemToAnsiStr(fAuthAnswer.Check);
   // SaveLogPlut('FLastError='+IntToStr(FLastError)+'  FLastErrorMessage='+FLastErrorMessage);
   SaveLogPlut('=================');
  //  SaveLogPlut(' Check== '+FCheck);
  except
    on E: Exception do
    begin
      SaveLogPlut(E.message+'__FLastErrorMessage='+FLastErrorMessage );
    end;
  end;

  if (id=0) and (Trim(FCheck)='') then
  begin
    str:='';
    AssignFile(F,  DIR_slip);
    Reset(F); // �������� ����� ��� ������
    Readln(F, str);  // ��� ������
    while (not EOF(f)) do
    begin
      Readln(f, s);
      str := str + s;
    end;
    s := Utils.OemToAnsiStr(str);
  //  ShowMessage(Copy(s,1,Length(s)-3));
    FCheck := s;
    CloseFile(F);
 
  end;
  SaveLogPlut('====��������====');
 // SaveLogPlut(s);
  SaveLogPlut('====*******====');
   @fCloseDay := nil;
  ZeroMemory(@fAuthAnswer.Check, SizeOf( fAuthAnswer.Check));
  ZeroMemory(@fAuthAnswer, SizeOf(fAuthAnswer));
  SaveLogPlut('========   get_statistics_end =========');
end;


function TPinPad_pilot_nt.CloseSmena(): integer;
// ������ ������ ������(�������� ���)
var s, str, FLastErrorMidessage : string;
    id, FLastError: integer;
    F: TextFile;
begin
FLastError:=0;
  SaveLogPlut('========   fCloseSmena_begin =========');
      SaveLogPlut('446 TPinPad_pilot_nt.CloseSmena '+ str+ intTostr(id));
  Result:=1;
  ClearBuffers;
  fAuthAnswer.Amount := 0;
  fAuthAnswer.TType := 7;
  fAuthAnswer.CType := 0;
  fAuthAnswer.Check  := PAnsiChar('');

  id:=fErrProc;
  fCloseDay:= GetProcAddress(FLibHandle,'_close_day');
  If @fCloseDay = nil then
  begin
    str:='���������� ��������� ������� _close_day';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    //SaveLogPinPad(str+ intTostr(id));
    SaveLogPlut('448 TPinPad_pilot_nt.CloseSmena '+ str+ intTostr(id));
    Exit;
  End;

  try
    id := fCloseDay(@fAuthAnswer);
    Result:=  id;

    SaveLogPlut('=================');
    //('=='+FCheck);
  except
    on E: Exception do
    begin
      SaveLogPlut(E.message+'__FLastErrorMessage='+FLastErrorMessage );
    end;
  end;

  if (id=0) and (Trim(FCheck)='') then
  begin
    str:='';
    AssignFile(F, DIR_slip);
    Reset(F); // �������� ����� ��� ������
    Readln(F, str);  // ��� ������
    while (not EOF(f)) do
    begin
      Readln(f, s);
      str := str + s;
    end;
      s := Utils.OemToAnsiStr(str);
  //  ShowMessage(Copy(s,1,Length(s)-3));
     FCheck := s;
     CloseFile(F);
  end;  
   @fCloseDay := nil;  //13012023
  ZeroMemory(@fAuthAnswer.Check, SizeOf( fAuthAnswer.Check));
  ZeroMemory(@fAuthAnswer, SizeOf(fAuthAnswer));
  SaveLogPlut('========   fCloseSmena_end =========');
end;
  

function TPinPad_pilot_nt.GetTerminalID: integer;
var int : integer;
     str: string;
begin
Result:=-1;
 @fGetTerminalID:=GetProcAddress(FLibHandle,'_GetTerminalID'); 
 If @fGetTerminalID= nil then
  begin
 //��������� �� ������� ���� ������� � ����������.
     MessageBox(0,'���������� ��������� �������','GetTerminalID',0);
     Exit;
   End; 
  GetMem(fTerminalID,9);
  int:= fGetTerminalID(fTerminalID);
  result:=int;
  str:=  pAnsiChar(fTerminalID);
  FreeMem(fTerminalID, SizeOf(fTerminalID^));
end;
 

{=����� � ���-����������}
function TPinPad_pilot_nt.TestPingPinpad:integer;
var id:integer;
    str: string;
begin
id:=fErrProc;
  fTestPinpad:= GetProcAddress(FLibHandle,'_TestPinpad');
  If @fTestPinpad = nil then 
  begin
   str:='���������� ��������� ������� _TestPinpad';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    SaveLogPlut('====TestPingPinpad===='+#13+str+ intTostr(id));
    Exit;
  End;
  id:=fTestPinpad;
  if id=0 then   str:=' ����� � ������ �����������';
  if id>0 then   str:=' ������ ������������ ����� � ������ ';
  result:=id;//=0  ��� ������
  SaveLogPlut('TestPinpad ='+str+IntToStr(id));
end;

function TPinPad_pilot_nt.getVersion:integer;
var id:integer;
    str: string;
begin
id:=fErrProc;
  fGetVer:= GetProcAddress(FLibHandle,'_GetVer');
  If @fGetVer = nil then 
  begin
   str:='���������� ��������� ������� _GetVer';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    SaveLogPlut('_GetVer    '+#13+str+ intTostr(id));
    Exit;
  End;
  id:=fGetVer;
  if id=0 then   str:=' ����� � ������ �����������';
  if id>0 then   str:=' ������ ������������ ����� � ������ ';
  result:=id;//=0  ��� ������
  SaveLogPlut('_GetVer ='+str+IntToStr(id));
end;


function TPinPad_pilot_nt.Get_statistics:integer;
var id:integer;
    str: string;
begin
     SaveLogPlut('==============Get_statistics============');
id:=fErrProc;
  fGet_statistics:= GetProcAddress(FLibHandle,'_get_statistics');
  If @fGet_statistics= nil then 
  begin
   str:='���������� ��������� ������� _Get_statistics';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    SaveLogPlut(str+ intTostr(id));
    Exit;
  End;
 fAuthAnswer.Amount := 0;
  fAuthAnswer.TType := 0;
  fAuthAnswer.CType := 0;
  id:=fGet_statistics(@fAuthAnswer);
  if id=0 then   str:=' ����� � ������ �����������';
  if id>0 then   str:=' ������ ������������ ����� � ������ ';
  result:=id;//=0  ��� ������
  FCheck:=(fAuthAnswer.Check);
  //FAuthCode:=(fAuthAnswer.Check);
     SaveLogPlut(' FLastErrorMessage '+FLastErrorMessage);
      SaveLogPlut(' AuthAnswer.Rcode='+AnsiString(fAuthAnswer.Rcode));
      SaveLogPlut(' AuthAnswer.CType='+IntTostr(fAuthAnswer.CType));
      SaveLogPlut(' AuthAnswer.FLastError='+IntTostr(fAuthAnswer.FLastError)); 
      SaveLogPlut(' AuthAnswer.Amount='+IntTostr(fAuthAnswer.Amount)); 
      SaveLogPlut(' AuthAnswer.TType='+IntTostr(fAuthAnswer.TType));  
      SaveLogPlut(' AuthAnswer.Check=');
      SaveLogPlut(AnsiString(fAuthAnswer.Check));
      
  SaveLogPlut('_Get_statistics ='+str+IntToStr(id));
       SaveLogPlut('============== end Get_statistics============');
//     function  Get_statistics():integer;

end;



procedure TPinPad_pilot_nt.ClearBuffers;
begin
 try

  ZeroMemory(@fAuthAnswer.check,SizeOf(fAuthAnswer.check));
  ZeroMemory(@fAuthAnswer,SizeOf(fAuthAnswer));
   if @fAuthAnswer6<>nil then 
         ZeroMemory(@fAuthAnswer6,SizeOf(fAuthAnswer6));
  FLastErrorMessage := '';
  FAuthCode := '';
  FRRN      := '';
  FCardID   := '';
 except on e: exception do
    SaveLogPlut('Error_ClearBuffers _'+e.Message); 
 end;

end;





function  TPinPad_pilot_nt.Card_authorize (Summ: cardinal; Operation: integer): integer;
var
 FLastError:integer;
  str : string;
begin
 SaveLogPlut(' ================== ������ CardAuth_authorize ========================');
Result:=1;
  ClearBuffers;
  fCard_authorize:= GetProcAddress(FLibHandle,'_card_authorize');
  If @fCard_authorize = nil then 
  begin
   str:='���������� ��������� ������� _card_authorize � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;

  fAuthAnswer.Amount := Summ;
  fAuthAnswer.TType := Operation;
  fAuthAnswer.CType := 0;
  try
   FLastError := fCard_authorize(nil, @fAuthAnswer);
   SaveLogPlut(' fCardAuth_authorize='+IntToStr(FLastError));
   Result := FLastError;

   if result =0 then    
       Fcheck   := AnsiString(fAuthAnswer.Check);
     FLastErrorMessage := AnsiString(fAuthAnswer.AMessage);
  
    //  SaveLogPlut(' FCheque='+FCheque+' FAuthCode '+FAuthCode+' FCardID '+FCardID);
      SaveLogPlut(' FLastErrorMessage '+FLastErrorMessage);
      SaveLogPlut(' AuthAnswer.Rcode='+AnsiString(fAuthAnswer.Rcode));
      SaveLogPlut(' AuthAnswer.CType='+IntTostr(fAuthAnswer.CType));
      SaveLogPlut(' AuthAnswer.FLastError='+IntTostr(fAuthAnswer.FLastError)); 
      SaveLogPlut(' AuthAnswer.Amount='+IntTostr(fAuthAnswer.Amount)); 
      SaveLogPlut(' AuthAnswer.TType='+IntTostr(fAuthAnswer.TType));  
      SaveLogPlut(' AuthAnswer.Check=');
      SaveLogPlut(AnsiString(fAuthAnswer.Check));
      
    except
      on E: Exception do
       begin
        RaiseLastOSError;
        SaveLogPlut(' Card_authorize='+e.Message);
       end;
    end;
     SaveLogPlut(' ==================����� CardAuth_authorize========================');

end;

{�������� ����������}
function TPinPad_pilot_nt.CommitTrx(Summ: cardinal;pAuthCode:pchar):integer;
var str:string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================������ _CommitTrx========================');
 fCommitTrx:= GetProcAddress(FLibHandle,'_CommitTrx');
  If @fCommitTrx = nil then 
  begin
   str:='���������� ��������� ������� _CommitTrx � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fCommitTrx(summ, pAuthCode);// ������������� ����������
 SaveLogPlut('CommitTrx='+IntTostr(fErrProc));
 //if FLastError=0 then
  Result:=fErrProc;
   SaveLogPlut(' ==================�����_CommitTrx========================');
end;



{�������� ����������}
function TPinPad_pilot_nt.RollbackTrx(Summ: cardinal;pAuthCode:pchar):integer;
 var str: string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================������ _RollbackTrx========================');
 fRollbackTrx:= GetProcAddress(FLibHandle,'_RollbackTrx');
  If @fRollbackTrx = nil then 
  begin
   str:='���������� ��������� ������� _RollbackTrx � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fRollbackTrx(summ, pAuthCode);// ������������� ����������
 SaveLogPlut('CommitTrx='+IntTostr(fErrProc));

  Result:=fErrProc;
   SaveLogPlut(' ==================�����__RollbackTrx========================');
end;



{����� ����������}
function TPinPad_pilot_nt.SuspendTrx(Summ: cardinal;pAuthCode:pchar):integer;
 var str :string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================������ _SuspendTrx========================');
 fSuspendTrx:= GetProcAddress(FLibHandle,'_SuspendTrx');
  If @fSuspendTrx = nil then 
  begin
   str:='���������� ��������� ������� _SuspendTrx � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fSuspendTrx(summ, pAuthCode);// ������������� ����������
 SaveLogPlut('SuspendTrx='+IntTostr(fErrProc));

  Result:=fErrProc;
   SaveLogPlut(' ==================�����__SuspendTr========================');
end;

 {������ ����������}
function TPinPad_pilot_nt.AbortTrx (Summ: cardinal;pAuthCode:pchar): integer;
var str:string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================������ _AbortTrx========================');
 fAbortTrx:= GetProcAddress(FLibHandle,'_AbortTrx');
  If @fAbortTrx = nil then 
  begin
   str:='���������� ��������� ������� AbortTrx � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fAbortTrx(summ, pAuthCode);// ������������� ����������
 SaveLogPlut('_AbortTrx='+IntTostr(fErrProc));

  Result:=fErrProc;
   SaveLogPlut(' ==================�����__AbortTrx========================');
end;




function TPinPad_pilot_nt.Card_authorize6(Summ: cardinal; Operation: integer; PFile: string): integer;
var FLastError: integer;
    s, str: string;
    F: TextFile;    
begin
  SaveLogPlut(' ==================������ Card_authorize6========================');
  Result:=1;
  ClearBuffers;
  FCheck:='';
  FAuthCode:='';
  FCardID:='';
  fCard_authorize6:= GetProcAddress(FLibHandle,'_card_authorize6');
  If @fCard_authorize6 = nil then
  begin
    str:='���������� ��������� ������� _card_authorize6 � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
  fAuthAnswer.Amount := Summ;
  fAuthAnswer.TType := Operation;
  fAuthAnswer.CType := 0;
  fAuthAnswer6.AuthAnswer := fAuthAnswer;
  try
    FLastError := fCard_authorize6(nil, @fAuthAnswer6);
    if @fAuthAnswer6=nil then
      SaveLogPlut('authorize6=nil');
    try
      SaveLogPlut(' Card_authorize6='+IntToStr(FLastError));
    except on E:Exception do
      ShowMessage('FLastError ���������� � �������:' + #13#10 + E.Message)
    end;
    try
      SaveLogPlut(' Card_authorize6='+fAuthAnswer6.CardID);
    except on E:Exception do
      ShowMessage('fAuthAnswer6.CardID ���������� � �������:' + #13#10 + E.Message)
    end;
    Result := FLastError;
    if result =0 then
    begin
      str:='';
      AssignFile(F, PFile);
      Reset(F); // �������� ����� ��� ������
      Readln(F, str);  // ��� ������
      while (not EOF(f)) do
      begin
        Readln(f, s);           
        str := str + s;
      end;
      s := Utils.OemToAnsiStr(str);
    //  ShowMessage(Copy(s,1,Length(s)-3));
      FCheck := s;
      CloseFile(F);
      try
        fAuthAnswer := fAuthAnswer6.AuthAnswer;
        FCardID   := AnsiString(fAuthAnswer6.CardID);
//        FCheck    := AnsiString(fAuthAnswer6.AuthAnswer.Check);
//        FAuthCode := AnsiString(fAuthAnswer6.AuthCode);
//        FRRN      := AnsiString(fAuthAnswer6.RRN);
//        FLastErrorMessage := AnsiString(fAuthAnswer6.AuthAnswer.AMessage);

        SaveLogPlut(' FLastErrorMessage '+FLastErrorMessage);
        SaveLogPlut(' fAuthAnswer6.CardID='+Ansistring(fAuthAnswer6.CardID));
//        SaveLogPinPad(' fAuthAnswer6.TransNumber='+IntTostr(fAuthAnswer6.TransNumber));
//        SaveLogPinPad(' fAuthAnswer6.ErrorCode='+IntTostr(fAuthAnswer6.ErrorCode));
//        SaveLogPinPad(' fAuthAnswer6.TransDate='+AnsiString(fAuthAnswer6.TransDate));
//        SaveLogPinPad(' fAuthAnswer6.RRN='+AnsiString(fAuthAnswer6.RRN));
//        SaveLogPinPad(' fAuthAnswer6.AuthCode='+AnsiString(fAuthAnswer6.AuthCode));
//        SaveLogPinPad(' fAuthAnswer6.AuthAnswer.Rcode='+AnsiString(fAuthAnswer6.AuthAnswer.Rcode));
//        SaveLogPinPad(' fAuthAnswer6.AuthAnswer.CType='+IntTostr(fAuthAnswer6.AuthAnswer.CType));
//        SaveLogPinPad(' fAuthAnswer6.AuthAnswer.FLastError='+IntTostr(fAuthAnswer6.AuthAnswer.FLastError));
//        SaveLogPinPad(' fAuthAnswer6.AuthAnswer.Amount='+IntTostr(fAuthAnswer6.AuthAnswer.Amount));
//        SaveLogPinPad(' fAuthAnswer6.AuthAnswer.TType='+IntTostr(fAuthAnswer6.AuthAnswer.TType));
//        SaveLogPinPad(' fAuthAnswer6.AuthAnswer.Check='+AnsiString(fAuthAnswer6.AuthAnswer.Check));
      except on E:Exception do
        ShowMessage('fAuthAnswer6.AuthAnswer ���������� � �������:' + #13#10 + E.Message)
      end;
    end;
  except
    on E: Exception do
     begin
      ShowMessage('' + #13#10 + E.Message);
      RaiseLastOSError;
      SaveLogPlut(' Card_authorize6=' + E.Message);
      @fCard_authorize6 := nil;
     end;
  end;

  @fCard_authorize6 := nil;
  SaveLogPlut(' ==================����� _card_authorize6========================');
end;


function TPinPad_pilot_nt.Card_authorize5(Summ: cardinal; Operation: integer;RNN:string): integer;
var
 FLastError:integer;
 str :string;
begin
 SaveLogPlut(' ==================������ Card_authorize5========================');
Result:=1;
  ClearBuffers;
  fCard_authorize5:= GetProcAddress(FLibHandle,'_card_authorize5');
  If @fCard_authorize5 = nil then 
  begin
   str:='���������� ��������� ������� _card_authorize5 � pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
  fAuthAnswer.Amount := Summ;
  fAuthAnswer.TType := Operation;
  fAuthAnswer.CType := 0;
  fAuthAnswer5.AuthAnswer := fAuthAnswer;
 // fAuthAnswer5.RRN:=pAnsichar(RNN);
   try
      FLastError := fCard_authorize5(nil, @fAuthAnswer5);
      SaveLogPlut(' Card_authorize5='+IntToStr(FLastError));
      Result := FLastError;
   if result =0 then      fAuthAnswer := fAuthAnswer5.AuthAnswer;
      FCheck    := AnsiString(fAuthAnswer5.AuthAnswer.Check);
      FAuthCode := AnsiString(fAuthAnswer5.AuthCode);
     // FCardID   := AnsiString(fAuthAnswer5);
      FLastErrorMessage := AnsiString(fAuthAnswer5.AuthAnswer.AMessage);
  
    //  SaveLogPlut(' FCheque='+FCheque+' FAuthCode '+FAuthCode+' FCardID '+FCardID);
      SaveLogPlut(' FLastErrorMessage '+FLastErrorMessage);

      SaveLogPlut(' AuthAnswer5.AuthCode='+AnsiString(fAuthAnswer5.AuthCode));
      SaveLogPlut(' AuthAnswer5.AuthCode='+AnsiString(fAuthAnswer5.AuthCode));
      SaveLogPlut(' AuthAnswer5.AuthAnswer.Rcode='+AnsiString(fAuthAnswer5.AuthAnswer.Rcode));
      SaveLogPlut(' AuthAnswer5.AuthAnswer.CType='+IntTostr(fAuthAnswer5.AuthAnswer.CType));
      SaveLogPlut(' AuthAnswer5.AuthAnswer.FLastError='+IntTostr(fAuthAnswer5.AuthAnswer.FLastError)); 
      SaveLogPlut(' AuthAnswer5.AuthAnswer.Amount='+IntTostr(fAuthAnswer5.AuthAnswer.Amount)); 
      SaveLogPlut(' AuthAnswer5.AuthAnswer.TType='+IntTostr(fAuthAnswer5.AuthAnswer.TType));  
      SaveLogPlut(' AuthAnswer5.AuthAnswer.Check='+AnsiString(fAuthAnswer5.AuthAnswer.Check));
    except
      on E: Exception do
       begin
        RaiseLastOSError;
        SaveLogPlut(' Card_authorize5='+e.Message);
        @fCard_authorize5 := nil;
       end;
    end;
    @fCard_authorize5 := nil;
     SaveLogPlut(' ==================����� _card_authorize5========================');
end;

procedure TPinPad_pilot_nt.SaveLogPinPad1(const mes_log:string);
  {=��������� '\' ���� ���}
 function AddSlash(const path : string):string;
begin
  if copy(path,length(path),1)<>'\' then Result:=path+'\'
  else Result:=path;
end;
//const logName = Application.ExeName+'.log';

var   logFile: TextFile;
      LogPath,logName,pathNm :string;
begin
 logName:='Tech_log'+'.log';

 pathNm  := fpathNm;//Host+'_'+nmWinUser+'_'+USERNM;
 if SaveLoginLocal=1 then  LogPath := AddSlash(GetCurrentDir)
 else   LogPath := AddSlash(ExtractFilePath(Application.ExeName));

 if NOT DirectoryExists(LogPath+'Log_f\') then   ForceDirectories(LogPath+'Log_f\');
 if NOT DirectoryExists(AddSlash(LogPath+'Log_f\'+pathNm)) then   ForceDirectories(AddSlash(LogPath+'Log_f\'+pathNm));
     LogPath:=AddSlash(LogPath+'Log_f\'+pathNm);

  logPath:= LogPath+logName;
 //logPath := AddSlash(ExtractFilePath(Application.ExeName))+logName;

//ExtractFilePath(Application.ExeName+'.log');
    try
//  LogSection1.Enter;
    if not FileExists(LogPath) then
       begin
       AssignFile(logFile,LogPath);
       ReWrite(logFile);
       WriteLn(logFile, FormatDateTime('yyyy"_"mm"_"dd"_"hh":"mm":"ss"."zzz" ', now)+': Start');
       WriteLn(logFile, mes_log);
       CloseFile(logFile);
       end
    else
       begin
       AssignFile(logFile, LogPath);
       Append(logFile);
       WriteLn(logFile, FormatDateTime('yyyy"_"mm"_"dd"_"hh":"mm":"ss"."zzz" ', now)+':  '+mes_log);
       CloseFile(logFile);
       end;

   finally
//  LogSection1.Leave;
   end;
end;

  {=��������� ����� ������}
function CloseSmena_posTerminal(var slipcheck:Ansistring) :Ansistring;
 var x: integer;
 pinpad_:TPinPad_pilot_nt;
 pathLog : string;
 pcheck :AnsiString;
begin
 pathLog:=Host+'_'+nmWinUser+'_'+USERNM;
result:='';
pcheck:='';
slipcheck:='';
 SaveLogPlut('CloseSmena_posTerminal ������ ������');
// x:=fCloseSmena;
x:=0;

   SaveLogPlut('������ ������ good');
    DIR_slip:=Set_FileSlip(DIRPilot_nt);
     pinpad_:= TPinPad_pilot_nt.Create(DIRPilot_nt,SaveLoginLocal,pathLog);
   try
     if pinpad_.CloseSmena()=0 then 
      begin
       // result:=pcheck;
         pcheck:=pinpad_.check;
         SaveLogPlut(' CloseSmena �������� ����� �������');
         SaveLogPlut(' ������������ ');
         if pcheck<>'' then  SaveLogPlut('������');
      end
     else ShowMessage('������  ��� �������� �����');

   slipcheck:=pcheck;
   result:=pcheck;
   SaveLogPlut('�����_CloseSmena_posTerminal ������ ������');
   finally
    //FreeAndNil(pinpad_);
     pinpad_:=nil;
    
  end;
end;

   {= X ����� ������}
function XSmena_posTerminal(var slipcheck:Ansistring) :Ansistring;
 var x   : integer;
 pinpad1 : TPinPad_pilot_nt;
 pcheck  : Ansistring;
 pathLog : string;
begin
 pathLog:=Host+'_'+nmWinUser+'_'+USERNM;
result:='';
pcheck:='';
slipcheck:='';
 SaveLogPlut('X �����_posTerminal ������ ������');

x:=0;

   SaveLogPlut('������ ������  good');
    DIR_slip:=Set_FileSlip(DIRPilot_nt);
     pinpad1:= TPinPad_pilot_nt.Create(DIRPilot_nt,SaveLoginLocal,pathLog);
   try
    if pinpad1.XSmena=0 then 
      begin  
         pcheck:=pinpad1.check;
         SaveLogPlut(' XSmena X ����� ������� ������������ ');
         slipcheck:=pcheck;
         if pcheck<>'' then  SaveLogPlut('������');
      end
     else ShowMessage('������  ��� X �����');

  result:=pcheck;
  SaveLogPlut('�����_X �����_posTerminal ������ ������');
 finally
  pinpad1:=nil;
 // pinpad1.Free;
  //FreeAndNil(pinpad1);
 end;

end;


end.
