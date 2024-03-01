unit u_Pos_Terminal;


interface

    uses SysUtils,Forms,Windows,Dialogs,Utils;

 type
  TOpetationTypes=(OP_PURCHASE=1,OP_CASH,OP_RETURN, OP_BALANCE,OP_FUNDS,OP_ADD_AUTH,
                   OP_CANC_AUTH{отменв предавторизации},OP_PREAUTH);




// Структура ответа
  PAuthAnswer = ^TAuthAnswer;
  TAuthAnswer = packed record
    TType: integer;
    // IN Тип транзакции (1 - Оплата, 3 - Возврат/отмена оплаты, 7 - Сверка итогов)
    Amount: cardinal; // IN Сумма операции в копейках
    Rcode: array [0 .. 2] of AnsiChar;
    // OUT Результат авторизации (0 или 00 - успешная авторизация, другие значения - ошибка)
    AMessage: array [0 .. 15] of AnsiChar;
    // OUT В случае отказа в авторизации содержит краткое сообщение о причине отказа
    CType: integer;

    { OUT Тип обслуженной карты. Возможные значения:
      1 – VISA
      2 – MasterCard
      3 – Maestro
      4 – American Express
      5 – Diners Club
      6 – VISA Electron 

      }
    Check: PAnsiChar;
    FLastError: integer;
    // OUT При успешной авторизации содержит образ карточного чека, который вызывающая программа должна отправить на печать, а затем освободить вызовом функции GlobalFree()
    // Может иметь значение nil. В этом случае никаких действий с ним вызывающая программа выполнять не должна.
     end;


    PAuthAnswer2 = ^TAuthAnswer2;
    TAuthAnswer2 = packed record
    AuthAnswer: TAuthAnswer;
    // вход/выход: основные параметры операции (см.выше)
    AuthCode: array [0 .. 6] of AnsiChar; // Код авторизации
    // OUT При успешной авторизации (по международной карте) содержит код авторизации. При операции по карте Сберкарт поле будет заполнено символами ‘*’.
   end;


     

     {= Возвращает TAuthAnswer+ сбер или не сбер}
    PAuthAnswer6 = ^TAuthAnswer6;
    TAuthAnswer6 = packed record
     AuthAnswer: TAuthAnswer;
     AuthCode: array [0 .. 6] of AnsiChar; // Код авторизации
    // OUT При успешной авторизации (по международной карте) содержит код авторизации. При операции по карте Сберкарт поле будет заполнено символами ‘*’.
     CardID: array [0 .. 24] of AnsiChar; // номер карты
    // OUT При успешной авторизации (по международной карте) содержит номер карты. Для международных карт все символы, кроме первых 6 и последних 4, будут заменены символами ‘*’.
    ErrorCode: integer;
    TransDate : array [0 .. 12] of AnsiChar;///Дата и время операции
    TransNumber: integer; //Номер чека пос терминала
     RRN : array [0 .. 11] of AnsiChar;    (*Номер ссылки операции, присвоенный хостом. Используется для операций возврат и множественной авторизации.
                     Содержит уникальный 12-значный ссылочный номер.*)
     (*• struct auth_answer auth_answ
• char AuthCode [MAX_AUTHCODE]
• char CardID [CARD_ID_LEN]
• int ErrorCode
• char TransDate [TRANSDATE_LEN]
• int TransNumber
• char RRN [MAX_REFNUM]*)
    
    end;

    pAuthAnswer5=^TAuthAnswer5;
    TAuthAnswer5 = packed record
      AuthAnswer: TAuthAnswer;
      RRN :array [0 .. 11] of AnsiChar; 
      AuthCode : array [0 .. 6] of AnsiChar;
    end;


         {= Возвращает TAuthAnswer+ сбер или не сбер}
    PAuthAnswer7 = ^TAuthAnswer7;
    TAuthAnswer7 = packed record
     AuthAnswer: TAuthAnswer;
     AuthCode:PAnsiChar;// array [0 .. 6] of AnsiChar; // Код авторизации
    // OUT При успешной авторизации (по международной карте) содержит код авторизации. При операции по карте Сберкарт поле будет заполнено символами ‘*’.
     CardID: array [0 .. 24] of AnsiChar; // номер карты
    // OUT При успешной авторизации (по международной карте) содержит номер карты. Для международных карт все символы, кроме первых 6 и последних 4, будут заменены символами ‘*’.
    SberOwnCard: integer;
    end;
    
      {=Возвращает TAuthAnswer+ сбер или не сбер+ Хэшкарты для реализации спасибо }
   PAuthAnswer9 = ^TAuthAnswer9;
   TAuthAnswer9 = packed record
    AuthAnswer: TAuthAnswer;
    // вход/выход: основные параметры операции (см.выше)
    AuthCode: array [0 .. 6] of AnsiChar; // Код авторизации
    // OUT При успешной авторизации (по международной карте) содержит код авторизации. При операции по карте Сберкарт поле будет заполнено символами ‘*’.
    CardID: array [0 .. 24] of AnsiChar; // номер карты
    // OUT При успешной авторизации (по международной карте) содержит номер карты. Для международных карт все символы, кроме первых 6 и последних 4, будут заменены символами ‘*’.
    SberOwnCard: integer;
    // OUT Содержит 1, если обслуженная карта выдана Сбербанком, или 0 – в противном случае
     Hash: array [0 .. 40] of AnsiChar;
    // OUT хеш SHA1 от номера карты в формате ASCIIZ
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
    fpathNm    : string;   // путь к файлу лога
    fSaveLoginLocal: integer;// сохранять в локальной папке или нет
     procedure   ClearBuffers;
  public 
     constructor Create(const pathLib :string; const SaveLoginLocal:integer;const pathNmLog:string );
  destructor  Destroy; override; 

     property check: String read FCheck;
     property CardID: String read FCardID;
     property AuthCode : string read FAuthCode;
     property SaveLogInLocal : integer read fSaveLoginLocal  write fSaveLoginLocal default 0;//  сервер
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

 
      {= X отчет пинпад}
    function XSmena_posTerminal(var slipcheck:AnsiString) :Ansistring;
          {=закрываем смену пинпад}
    {=закрываем смену пинпад}
   function CloseSmena_posTerminal(var slipcheck: AnsiString) :Ansistring; 

   //procedure SaveLogPos(s: string;const logName: string='Tech_log.log');
implementation
uses u_const;



 
constructor TPinPad_pilot_nt.Create(const pathLib: string; const SaveLoginLocal:integer;const pathNmLog:string );
begin
//  fErrProc:=555;
  fSaveLogInLocal:=SaveLoginLocal;
  fpathNm        :=pathNmLog;
  SaveLogPlut('Создаём папку с логами пин пада путь: '+pathNmLog);
  FLibHandle     := LoadLibrary(PChar(pathLib));
  if FLibHandle = 0 then
    raise exception.CreateFmt('Ошибка загруки pilot_nt библиотеки %s', [pathLib]);
end;

destructor TPinPad_pilot_nt.Destroy;
begin
  inherited;
   ClearBuffers;
   FreeLibrary(FLibHandle);

end;


function TPinPad_pilot_nt.XSmena(): integer;
// снятия сверки итогов(закрытие дня)
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
    str:='Невозможно загрузить функцию _get_statistics';
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
      ShowMessage('Объект пуст!');
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
    Reset(F); // Открытие файла для чтения
    Readln(F, str);  // Код ответа
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
  SaveLogPlut('====Закрытие====');
 // SaveLogPlut(s);
  SaveLogPlut('====*******====');
   @fCloseDay := nil;
  ZeroMemory(@fAuthAnswer.Check, SizeOf( fAuthAnswer.Check));
  ZeroMemory(@fAuthAnswer, SizeOf(fAuthAnswer));
  SaveLogPlut('========   get_statistics_end =========');
end;


function TPinPad_pilot_nt.CloseSmena(): integer;
// снятия сверки итогов(закрытие дня)
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
    str:='Невозможно загрузить функцию _close_day';
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
    Reset(F); // Открытие файла для чтения
    Readln(F, str);  // Код ответа
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
 //Проверяем на наличие этой функции в библиотеке.
     MessageBox(0,'Невозможно загрузить функцию','GetTerminalID',0);
     Exit;
   End; 
  GetMem(fTerminalID,9);
  int:= fGetTerminalID(fTerminalID);
  result:=int;
  str:=  pAnsiChar(fTerminalID);
  FreeMem(fTerminalID, SizeOf(fTerminalID^));
end;
 

{=Связь с пос-терминалом}
function TPinPad_pilot_nt.TestPingPinpad:integer;
var id:integer;
    str: string;
begin
id:=fErrProc;
  fTestPinpad:= GetProcAddress(FLibHandle,'_TestPinpad');
  If @fTestPinpad = nil then 
  begin
   str:='Невозможно загрузить функцию _TestPinpad';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    SaveLogPlut('====TestPingPinpad===='+#13+str+ intTostr(id));
    Exit;
  End;
  id:=fTestPinpad;
  if id=0 then   str:=' Связь с пинпад установлена';
  if id>0 then   str:=' Ошибка установления связи с пинпад ';
  result:=id;//=0  все хорошо
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
   str:='Невозможно загрузить функцию _GetVer';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    SaveLogPlut('_GetVer    '+#13+str+ intTostr(id));
    Exit;
  End;
  id:=fGetVer;
  if id=0 then   str:=' Связь с пинпад установлена';
  if id>0 then   str:=' Ошибка установления связи с пинпад ';
  result:=id;//=0  все хорошо
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
   str:='Невозможно загрузить функцию _Get_statistics';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=id;
    SaveLogPlut(str+ intTostr(id));
    Exit;
  End;
 fAuthAnswer.Amount := 0;
  fAuthAnswer.TType := 0;
  fAuthAnswer.CType := 0;
  id:=fGet_statistics(@fAuthAnswer);
  if id=0 then   str:=' Связь с пинпад установлена';
  if id>0 then   str:=' Ошибка установления связи с пинпад ';
  result:=id;//=0  все хорошо
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
 SaveLogPlut(' ================== начало CardAuth_authorize ========================');
Result:=1;
  ClearBuffers;
  fCard_authorize:= GetProcAddress(FLibHandle,'_card_authorize');
  If @fCard_authorize = nil then 
  begin
   str:='Невозможно загрузить функцию _card_authorize в pilot_nt.dll';
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
     SaveLogPlut(' ==================конец CardAuth_authorize========================');

end;

{Фиксация транзакции}
function TPinPad_pilot_nt.CommitTrx(Summ: cardinal;pAuthCode:pchar):integer;
var str:string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================начало _CommitTrx========================');
 fCommitTrx:= GetProcAddress(FLibHandle,'_CommitTrx');
  If @fCommitTrx = nil then 
  begin
   str:='Невозможно загрузить функцию _CommitTrx в pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fCommitTrx(summ, pAuthCode);// Зафиксировать транзакцию
 SaveLogPlut('CommitTrx='+IntTostr(fErrProc));
 //if FLastError=0 then
  Result:=fErrProc;
   SaveLogPlut(' ==================конец_CommitTrx========================');
end;



{Фиксация транзакции}
function TPinPad_pilot_nt.RollbackTrx(Summ: cardinal;pAuthCode:pchar):integer;
 var str: string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================начало _RollbackTrx========================');
 fRollbackTrx:= GetProcAddress(FLibHandle,'_RollbackTrx');
  If @fRollbackTrx = nil then 
  begin
   str:='Невозможно загрузить функцию _RollbackTrx в pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fRollbackTrx(summ, pAuthCode);// Зафиксировать транзакцию
 SaveLogPlut('CommitTrx='+IntTostr(fErrProc));

  Result:=fErrProc;
   SaveLogPlut(' ==================конец__RollbackTrx========================');
end;



{Пауза транзакции}
function TPinPad_pilot_nt.SuspendTrx(Summ: cardinal;pAuthCode:pchar):integer;
 var str :string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================начало _SuspendTrx========================');
 fSuspendTrx:= GetProcAddress(FLibHandle,'_SuspendTrx');
  If @fSuspendTrx = nil then 
  begin
   str:='Невозможно загрузить функцию _SuspendTrx в pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fSuspendTrx(summ, pAuthCode);// Зафиксировать транзакцию
 SaveLogPlut('SuspendTrx='+IntTostr(fErrProc));

  Result:=fErrProc;
   SaveLogPlut(' ==================конец__SuspendTr========================');
end;

 {Отмена транзакции}
function TPinPad_pilot_nt.AbortTrx (Summ: cardinal;pAuthCode:pchar): integer;
var str:string;
begin
fErrProc:=555;
 SaveLogPlut(' ==================начало _AbortTrx========================');
 fAbortTrx:= GetProcAddress(FLibHandle,'_AbortTrx');
  If @fAbortTrx = nil then 
  begin
   str:='Невозможно загрузить функцию AbortTrx в pilot_nt.dll';
    MessageBox(0,pchar(str),'u_Pos_Terminal',0);
    Result:=fErrProc;
    SaveLogPlut(str+ intTostr(fErrProc));
    Exit;
  End;
 fErrProc:=fAbortTrx(summ, pAuthCode);// Зафиксировать транзакцию
 SaveLogPlut('_AbortTrx='+IntTostr(fErrProc));

  Result:=fErrProc;
   SaveLogPlut(' ==================конец__AbortTrx========================');
end;




function TPinPad_pilot_nt.Card_authorize6(Summ: cardinal; Operation: integer; PFile: string): integer;
var FLastError: integer;
    s, str: string;
    F: TextFile;    
begin
  SaveLogPlut(' ==================начало Card_authorize6========================');
  Result:=1;
  ClearBuffers;
  FCheck:='';
  FAuthCode:='';
  FCardID:='';
  fCard_authorize6:= GetProcAddress(FLibHandle,'_card_authorize6');
  If @fCard_authorize6 = nil then
  begin
    str:='Невозможно загрузить функцию _card_authorize6 в pilot_nt.dll';
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
      ShowMessage('FLastError завершился с ошибкой:' + #13#10 + E.Message)
    end;
    try
      SaveLogPlut(' Card_authorize6='+fAuthAnswer6.CardID);
    except on E:Exception do
      ShowMessage('fAuthAnswer6.CardID завершился с ошибкой:' + #13#10 + E.Message)
    end;
    Result := FLastError;
    if result =0 then
    begin
      str:='';
      AssignFile(F, PFile);
      Reset(F); // Открытие файла для чтения
      Readln(F, str);  // Код ответа
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
        ShowMessage('fAuthAnswer6.AuthAnswer завершился с ошибкой:' + #13#10 + E.Message)
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
  SaveLogPlut(' ==================конец _card_authorize6========================');
end;


function TPinPad_pilot_nt.Card_authorize5(Summ: cardinal; Operation: integer;RNN:string): integer;
var
 FLastError:integer;
 str :string;
begin
 SaveLogPlut(' ==================начало Card_authorize5========================');
Result:=1;
  ClearBuffers;
  fCard_authorize5:= GetProcAddress(FLibHandle,'_card_authorize5');
  If @fCard_authorize5 = nil then 
  begin
   str:='Невозможно загрузить функцию _card_authorize5 в pilot_nt.dll';
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
     SaveLogPlut(' ==================конец _card_authorize5========================');
end;

procedure TPinPad_pilot_nt.SaveLogPinPad1(const mes_log:string);
  {=Добавляем '\' если нет}
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

  {=закрываем смену пинпад}
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
 SaveLogPlut('CloseSmena_posTerminal сверка итогов');
// x:=fCloseSmena;
x:=0;

   SaveLogPlut('сверка итогов good');
    DIR_slip:=Set_FileSlip(DIRPilot_nt);
     pinpad_:= TPinPad_pilot_nt.Create(DIRPilot_nt,SaveLoginLocal,pathLog);
   try
     if pinpad_.CloseSmena()=0 then 
      begin
       // result:=pcheck;
         pcheck:=pinpad_.check;
         SaveLogPlut(' CloseSmena Закрытие смены успешно');
         SaveLogPlut(' сформировано ');
         if pcheck<>'' then  SaveLogPlut('хорошо');
      end
     else ShowMessage('Ошибка  при закрытии смены');

   slipcheck:=pcheck;
   result:=pcheck;
   SaveLogPlut('Конец_CloseSmena_posTerminal сверка итогов');
   finally
    //FreeAndNil(pinpad_);
     pinpad_:=nil;
    
  end;
end;

   {= X отчет пинпад}
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
 SaveLogPlut('X отчет_posTerminal сверка итогов');

x:=0;

   SaveLogPlut('сверка итогов  good');
    DIR_slip:=Set_FileSlip(DIRPilot_nt);
     pinpad1:= TPinPad_pilot_nt.Create(DIRPilot_nt,SaveLoginLocal,pathLog);
   try
    if pinpad1.XSmena=0 then 
      begin  
         pcheck:=pinpad1.check;
         SaveLogPlut(' XSmena X отчет успешно сформировано ');
         slipcheck:=pcheck;
         if pcheck<>'' then  SaveLogPlut('хорошо');
      end
     else ShowMessage('Ошибка  при X отчет');

  result:=pcheck;
  SaveLogPlut('Конец_X отчет_posTerminal сверка итогов');
 finally
  pinpad1:=nil;
 // pinpad1.Free;
  //FreeAndNil(pinpad1);
 end;

end;


end.
