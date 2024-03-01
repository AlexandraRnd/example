unit uGetHardConfig;

interface

uses  Windows,Classes, OleServer, ActiveX,Variants,SysUtils,WbemScripting_TLB;

 const
    st='Стационар';
const
   rr='Раковый Регистр';
    {=мак адрес +метка жёсткого диска+ имя машины+уид биоса}
 //oleauto; 
   type 
   TarrMac =array of widestring;

  type 
   TNetAdapter= packed record
    Mac              :string;
    PhysicalAdapter  :boolean;
    Description      :string;
 
 end;

     PNetAdapter=^TNetAdapter;

  {uid-биоса}
 function  Get_Bios_uid :string;

  {=серийный номер материнки}
  function GetMatheboard_serial: string;
  {=шифруем по rc_4}
  function EncryptString_rc4(source:string;Key:pointer;size_key:integer):widestring;
  {=расшифровываем rc_4}
  function DecryptString_rc4(source:string;Key:pointer;size_key:integer):widestring;
  {= расшифровка с ключом md5 }
  function Decrypt_rc4_keyMd5(source: string):widestring;
  {=расшифровка с ключом key4}
  function Decrypt_tea_key(source: string):widestring;
  function EncryptStringtea(source:string;Key:pointer;size_key:integer):widestring;
  function DecryptStringtea(source:string;Key:pointer;size_key:integer):widestring;
  {=инфо о жестком диске}
  Function GetHDDInfo(Disk : Char;Var VolumeName, FileSystemName : String;
                     Var VolumeSerialNo, MaxComponentLength,
                       FileSystemFlags:LongWord) : Boolean;  
  {буква логического диска с системой, чтобы считать серийник для жесткого диска}
  function GetHDD_letter:string;                    
    {=Генерим уникальный ключ}
  function CodeGenerate :string;
   {=Генерим уникальный ключ с учетом физической сетевой карты}
  function CodeGenerate_v20 :string;
   {=Генерим уникальный ключи с возможными мас адресами}
  //procedure genKey_list(var arr:TarrMac);
  function genKey_list(var arr:TarrMac):TarrMac;

  
 function GetStringHash(Source: string): string;
{=соль для шифровки ключа нужно 128 бит}
 function SaltKey_md5:widestring;
 function SaltKey_64:widestring;
 function SaltKey4:widestring;
  {=ключ на основе железа}
 function genKey:widestring;
 function XorEncode(Source, Key: string): string;
 function XorDecode(Source, Key: string): string;
 {=Считываем все MAc-адреса}
 procedure All_mac_list(var MacL:TstringList);
  {=версия windows}
 function WinInt_Version:integer;
   {=// определить мак адрес для физической сетевой}
 function Mac_v20:string;
   {mac физической платы}
 function mac_PhysicalAdapter:string;


  
implementation

 uses DCPbase64,DCPconst,DCPcrypt2,DCPrc4,DCPmd5,uTcpIpUtils,DCPtea;




function XorEncode(Source, Key: string): string;
var
  I: Integer;
  C: Byte;
begin
  Result := '';
  for I := 1 to Length(Source) do
  begin
    if Length(Key) > 0 then
      C := Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Byte(Source[I])
    else
      C := Byte(Source[I]);
    Result := Result + AnsiLowerCase(IntToHex(C, 2));
  end;
end;
 
function XorDecode(Source, Key: string): string;
var
  I: Integer;
  C: Char;
 
begin
  Result := '';
  for I := 0 to Length(Source) div 2 - 1 do
   begin
    C := Chr(StrToIntDef('$' + Copy(Source, (I * 2) + 1, 2), Ord(' ')));
    if Length(Key) > 0 then
      C := Chr(Byte(Key[1 + (I mod Length(Key))]) xor Byte(C));
    Result := Result + C;
  end;
end;

procedure SaveLongStringENC(var F:File;ST:String);
var
// кодирование строки
i,j:integer;
begin
st:=st+#13#10;
i:=length(ST);
blockwrite(F,I,sizeof(i));
for j:=1 to i do ST[j]:=chr(ord(ST[j]) xor (i mod 256));
blockwrite(F,ST[1],i);
end;

function LoadLongStringENC(var F:File):String;overload;
var i,j:integer;
st:string;
begin
// раскодирование строки
blockread(F,I,sizeof(I));
SetLength(ST,I);
blockread(F,st[1],i);
for j:=1 to i do ST[j]:=chr(ord(ST[j]) xor (i mod 256));
result:=st;
end;

 
 
function EncryptStringtea(source:string;Key:pointer;size_key:integer):widestring;
var
  encrypted,k:string;
  len:integer;
  Cipher: TDCP_tea;
 
begin
k:=SaltKey4;
encrypted:=XorEncode(source,k);
result:= encrypted;
 (* encrypted:='';
  len:=length(source);
  SetLength(encrypted,len);
  Cipher:=TDCP_tea.Create(nil);
  try
  Cipher.Init(Key^,size_key*8,nil);
  Cipher.Encrypt(source[1],encrypted[1],len);
  Cipher.Burn;
  SaveLogKey('59');
    result:=encrypted;
  finally
     freeandNil(Cipher);
     //Cipher.Free;
     //Cipher:=nil;
  end;  *)


end;



function DecryptStringtea(source:string;Key:pointer;size_key:integer):widestring;
var
  encrypted,k:string;
  len:integer;
  Cipher: TDCP_tea;
 
begin
 encrypted:='';
 k:=SaltKey4;
 encrypted:=XorDecode(source,k);
 result:=encrypted;
(*len:=length(source);
SetLength(encrypted,len);
Cipher:=TDCP_tea.Create(nil);
 try
  Cipher.Init(Key^,size_key*8,nil);
  Cipher.Decrypt(source[1],encrypted[1],len);
  Cipher.Burn;
    SaveLogKey('84');
    result:=encrypted;
 finally
 freeandNil(Cipher);
 // Cipher.Free;
   //:=nil;
 end;   *)



end;



{=серийный номер диска}
function HddInfo_SerialN(const letter :char): string;
 Var  
  //S,
  SOut : String;  
 // I : Integer;   
 VolumeName,FileSystemName : String;   
 VolumeSerialNo,MaxComponentLength,FileSystemFlags:LongWord;  
begin
try
  if GetHDDInfo(letter, VolumeName, FileSystemName, VolumeSerialNo,   
   MaxComponentLength, FileSystemFlags) then {... тогда собираем информацию}  
   SOut:=SOut+   getCurrentDir()+    
   'Диск: '+letter+#13#10+   
   'Метка: '+VolumeName+#13#10+ 
   'Файловая система: '+FileSystemName+#13+#10+ 
   'Серийный номер: '+IntToHex(VolumeSerialNo,8)+#13+#10+   
   'Макс. длина имени файла: '+IntToStr(MaxComponentLength)+#13+#10+   
   'Flags: '+IntToHex(FileSystemFlags,4)+#13#10+#13#10;
    result:= IntToHex(VolumeSerialNo,8);//sout;
 except on e:exception  do
      SaveLogKey('115 hdd'+e.Message);
  end;

end;
 
{=инфо о жестком диске}
Function GetHDDInfo(Disk : Char;Var VolumeName, FileSystemName : String;
                     Var VolumeSerialNo, MaxComponentLength,
                      FileSystemFlags:LongWord) : Boolean; 
                      
  Var  _VolumeName,
       _FileSystemName:array [0..MAX_PATH-1] of Char;
      _VolumeSerialNo,_MaxComponentLength,
       _FileSystemFlags:LongWord;  
Begin
     Result:=False; 

try
 if GetVolumeInformation(PChar(Disk+':\'),_VolumeName,MAX_PATH,@_VolumeSerialNo,  
    _MaxComponentLength,_FileSystemFlags,_FileSystemName,MAX_PATH) then  
  Begin  
   VolumeName:=_VolumeName;  
   VolumeSerialNo:=_VolumeSerialNo;  
   MaxComponentLength:=_MaxComponentLength;  
   FileSystemFlags:=_FileSystemFlags;  
   FileSystemName:=_FileSystemName;  
   Result:=True;  
 End;
except on e: exception do 
  SaveLogKey('144 '+e.message);

end; 
  
   
End;

  {буква логического диска с системой, чтобы считать серийник для жесткого диска}
function GetHDD_letter:string;
var PRes : PChar; 
  Res : word; 
 // ,str :string;
 // Disk: char;
   str_disk, VolumeName,
    FileSystemName : String;
    VolumeSerialNo, MaxComponentLength,
                      FileSystemFlags:LongWord;
begin 
// Каталог, где установлена Windows 
result:='';
try
PRes := StrAlloc(255); 
Res := GetWindowsDirectory(PRes, 255);
if res>0 then 
    str_disk:=StrPas(@PRes[0])
    else str_disk:=getCurrentDir;
 str_disk:=copy(str_disk,1,1);
  SaveLogKey('180_letter_'+str_disk[1]);
if GetHDDInfo(str_disk[1],VolumeName, FileSystemName, VolumeSerialNo,  
                    MaxComponentLength, FileSystemFlags) then
 result:=IntToHex(VolumeSerialNo,8);
except on e:exception do
  SaveLogKey('180_letter_'+e.Message);

end;
end;

 
{=шифруем по rc_4}
function EncryptString_rc4(source:string;Key:pointer;size_key:integer):widestring;
var
  encrypted:string;
  len:integer;
  Cipher: TDCP_rc4;
 
begin
encrypted:='';
  len:=length(source);
  SetLength(encrypted,len);
  Cipher:=TDCP_rc4.Create(nil);
  try
  Cipher.Init(Key^,size_key*8,nil);
  Cipher.Encrypt(source[1],encrypted[1],len);
  Cipher.Burn;
    result:=encrypted;
  finally
    freeAndNil(Cipher);
  end;


end;

{=расшифровываем rc_4}
function DecryptString_rc4(source:string;Key:pointer;size_key:integer):widestring;
var
  encrypted:string;
  len:integer;
  Cipher: TDCP_rc4;
 // Key:pointer;
begin
 encrypted:='';
  len:=length(source);
  SetLength(encrypted,len);
  Cipher:=TDCP_rc4.Create(nil);
  try
  Cipher.Init(Key^,size_key*8,nil);
  Cipher.Decrypt(source[1],encrypted[1],len);
  Cipher.Burn;
   
  result:=encrypted;

  finally
    freeAndNil(Cipher);
  end;

end;

   {= расшифровка с ключом md5 }
function Decrypt_rc4_keyMd5(source: string):widestring;
var  //key_salt: widestring;
     pkey_salt:pointer;
      sz_key:integer;
begin
  result:='';
  pkey_salt := pWidechar(SaltKey_md5);
  sz_key    := length(SaltKey_md5);
  result    := DecryptString_rc4(source,pkey_salt,sz_key);
end;


{=расшифровка с ключом key4}
function Decrypt_tea_key(source: string):widestring;
var  //key_salt: widestring;
     pkey_salt:pointer;
      sz_key:integer;
      k:string;
      encrypted:widestring ;
begin
 encrypted:='';
 k:=SaltKey4;
 encrypted:=XorDecode(source,k);
 result:=encrypted;
(*  result:='';
  pkey_salt := pWidechar(SaltKey4);
  sz_key    := length(SaltKey4);
  result    := Decryptstringtea(source,pkey_salt,sz_key);  *)
end;



function GetStringHash(Source: string): string;
var
  Hash: TDCP_md5;
  Digest: array[0..15] of Byte;
  j: integer;
  s:string;
begin
  Hash := TDCP_md5.Create(nil); // создаём объект
  try
   Hash.Init;                      // инициализируем
   Hash.UpdateStr(Source);         // вычисляем хэш-сумму
   Hash.Final(Digest);             // сохраняем её в массив
  finally 
   freeandnil(hash);                     // уничтожаем объект
  end;
   for j := 0 to Length(Digest) - 1 do  // convert it into a hex string
        s := s + IntToHex(Digest[j],2);
  Result := s;  // получаем хэш-сумму строкой
end;


{uid-биоса}
function  Get_Bios_uid :string;
  var
  Service: ISWbemServices;
  ObjectSet: ISWbemObjectSet;
  SObject: ISWbemObject;
  PropSet: ISWbemPropertySet;
  SProp: ISWbemProperty;
  SWbemLocator: TSWbemLocator;
  PropEnum, Enum: IEnumVariant;
  TempObj: OleVariant;
  Value: Cardinal;
  //StrValue: string;
  nm,val : OleVariant;
 // emptyCom:TComponent;
begin
CoInitialize(nil);
   // SaveLogKey('260 uid_b');
 val:='';
Result:=val;
try
SWbemLocator:=TSWbemLocator.Create(nil);
try
 Service := SWbemLocator.ConnectServer('.', 'root\CIMV2', '', '', '', '', 0, nil);
 // SObject := Service.Get('Win32_CDROMDrive', wbemFlagUseAmendedQualifiers, nil);
  ObjectSet := Service.ExecQuery('Select * FROM win32_computersystemproduct', 'WQL', 0, nil);
  //Enum := (SWbemObjectSet._NewE num) as IEnumVariant;
 // ObjectSet := SObject.Instances_(0, nil);
  Enum := (ObjectSet._NewEnum) as IEnumVariant;
  //Enum.Next(1, TempObj, Value);

 while (Enum.Next(1, TempObj, Value) = S_OK) do
  begin
    SObject:= IUnknown(TempObj) as SWBemObject; 
    PropSet:= SObject.Properties_; 
    PropEnum:= (PropSet._NewEnum) as IEnumVariant; 
     while PropEnum.Next(1, TempObj, Value) = S_OK do 
      begin 
       SProp:= IUnknown(TempObj) as SWBemProperty; 
       nm:=SProp.Name;
       if nm='UUID' then val:= SProp.Get_Value;
      end;
    Result:=val;
  end;
finally
 FreeAndNil(SWbemLocator);
 CoUnInitialize;
end;
  except on e: exception do
    SaveLogKey('260 u_b:  '+e.Message);
 end;
 
end;



{=серийный номер материнки}
function GetMatheboard_serial : string;
var
  Service: ISWbemServices;
  ObjectSet: ISWbemObjectSet;
  SObject: ISWbemObject;
  PropSet: ISWbemPropertySet;
  SProp: ISWbemProperty;
  SWbemLocator: TSWbemLocator;
  PropEnum, Enum: IEnumVariant;
  TempObj: OleVariant;
  Value: Cardinal;
 // StrValue: string;
  nm,val : OleVariant;

begin
 val:='';
Result:=val;
SWbemLocator:=TSWbemLocator.Create(nil);
try
  Service := SWbemLocator.ConnectServer('.', 'root\CIMV2', '', '', '', '', 0, nil);
  ObjectSet := Service.ExecQuery('Select * FROM Win32_BaseBoard', 'WQL', 0, nil);
  Enum := (ObjectSet._NewEnum) as IEnumVariant;
  while (Enum.Next(1, TempObj, Value) = S_OK) do
  begin
    SObject:= IUnknown(TempObj) as SWBemObject; 
    PropSet:= SObject.Properties_; 
    PropEnum:= (PropSet._NewEnum) as IEnumVariant; 
     while PropEnum.Next(1, TempObj, Value) = S_OK do 
    begin 
      SProp:= IUnknown(TempObj) as SWBemProperty; 
   //  SProp:= IUnknown(TempObj) as SWBemProperty;  

       nm:=SProp.Name;
       val:='';
       if nm='SerialNumber' then val:= SProp.Get_Value;
       if val=null then  val:='';

    end;
    Result:=val;
  end;
finally
    FreeAndNil(SWbemLocator);
end;
end;

{=соль для шифровки ключа нужно 128 бит}
function SaltKey_md5:widestring;
const s_md5='c2a6b0073846e255cea7c45141aba708';//128
begin
  result :=s_md5;
end;


function SaltKey_64:widestring;
const s_base64='YnVuMTcwOF9rYXZlbG1lZHNoYXYxOTkw';
begin
  result:=s_base64;
end;

function SaltKey4:widestring;
  const s= '1708_elmed1990';
begin
  result:=s;
end;

 {=Генерим уникальный ключ}
function CodeGenerate :string;
var Mac     : string;  //24 bit
   LogikHDD : string;{метка логического тома-диска. там где установлена windows
                      изменяется при форматировании или переустановке windows}
   bios_uid : string;{uid биоса через wmi службу}    
   compName : string; {имя компа}  
   //motherBoard,
   res :string;   
  const uid_const='0768F8A494234DD0BE567156AB7BA8B1';           
                   
begin
res:='';

 Mac        := GetMACAddress;
 LogikHDD   := HddInfo_SerialN(GetHDD_letter[1]);
 compName   := GetOwnComputerName;
 bios_uid   := Get_Bios_uid;
// motherBoard:= GetMatheboard_serial;
 if uppercase(mac)=uppercase('mac not found') then
                begin 
                  Mac:= uid_const;
                  SaveLogKey('350 uid_const1');
                end;
 //  SaveLogKey('350_m good');              
 if uppercase(LogikHDD)='' then
                begin
                  LogikHDD:= uid_const;
                  SaveLogKey('359 uid_const2');
                end; 
  // SaveLogKey('350_lh good');                             
 if compName='' then
                   begin
                     compName:= uid_const; 
                     SaveLogKey('353 uid_const3');
                  end;
  //  SaveLogKey('350_cn good');                     
 if uppercase(bios_uid)='' then 
                    begin
                      bios_uid:= uid_const;
                      SaveLogKey('354 uid_const4');
                    end;
     // SaveLogKey('350_bu good');                    
// if uppercase(motherBoard)='' then
 //                              motherBoard:= uid_const;
  res:=Mac+'$'+LogikHDD+'$'+ compName+'$'+bios_uid+'$'+SaltKey_64;                               
 result:= res;
  SaveLogKey('good 340');
end;



 {=Генерим уникальный ключ с учетом физической сетевой карты}
function CodeGenerate_v20 :string;
var Mac     : string;  //24 bit
   LogikHDD : string;{метка логического тома-диска. там где установлена windows
                      изменяется при форматировании или переустановке windows}
   bios_uid : string;{uid биоса через wmi службу}    
   compName : string; {имя компа}  
   //motherBoard,
   res :string;   
  const uid_const='0768F8A494234DD0BE567156AB7BA8B1';           
                   
begin
res:='';

 Mac        := Mac_v20;
  SaveLogKey('583 good ');  
 LogikHDD   := HddInfo_SerialN(GetHDD_letter[1]);
 compName   := GetOwnComputerName;
 bios_uid   := Get_Bios_uid;
// motherBoard:= GetMatheboard_serial;
 //  SaveLogKey('350_m good');              
 if uppercase(LogikHDD)='' then
                begin
                  LogikHDD:= uid_const;
                  SaveLogKey('359 uid_const2');
                end; 
  // SaveLogKey('350_lh good');                             
 if compName='' then
                   begin
                     compName:= uid_const; 
                     SaveLogKey('353 uid_const3');
                  end;
  //  SaveLogKey('350_cn good');                     
 if uppercase(bios_uid)='' then 
                    begin
                      bios_uid:= uid_const;
                      SaveLogKey('354 uid_const4');
                    end;
     // SaveLogKey('350_bu good');                    
// if uppercase(motherBoard)='' then
 //                              motherBoard:= uid_const;
 {=мак адрес +метка жёсткого диска+ имя машины+уид биоса}
  res:=Mac+'$'+LogikHDD+'$'+ compName+'$'+bios_uid+'$'+SaltKey_64;                               
 result:= res;
  SaveLogKey('good 340');
end;


   {=Генерим уникальный ключи с возможными мас адресами}
function genKey_list(var arr:TarrMac):TarrMac;

var Mac_list : TStringList;  //24 bit
   LogikHDD  : string;{метка логического тома-диска. там где установлена windows
                      изменяется при форматировании или переустановке windows}
   bios_uid : string;{uid биоса через wmi службу}    
   compName : string; {имя компа}  
   mac_nul:string;
   //motherBoard,
   res :string;   
   i:integer;
   var pkey,salt:widestring;
   psalt :pointer;
  const uid_const='0768F8A494234DD0BE567156AB7BA8B1';           
                   
begin
//res:='';
 SaveLogKey('577');
    CoInitialize(nil);
    try
 LogikHDD   := HddInfo_SerialN(GetHDD_letter[1]);
 compName   := GetOwnComputerName;
 bios_uid   := Get_Bios_uid;
 mac_nul    := uid_const;

 //  SaveLogKey('350_m good');              
 if uppercase(LogikHDD)='' then
                begin
                  LogikHDD:= uid_const;
                  SaveLogKey('359 uid_const2');
                end; 
  // SaveLogKey('350_lh good');                             
 if compName='' then
                   begin
                     compName:= uid_const; 
                     SaveLogKey('353 uid_const3');
                  end;
  //  SaveLogKey('350_cn good');                     
 if uppercase(bios_uid)='' then 
                    begin
                      bios_uid:= uid_const;
                      SaveLogKey('354 uid_const4');
                    end;
     // SaveLogKey('350_bu good');                    
// if uppercase(motherBoard)='' then
 //                              motherBoard:= uid_const;

 Mac_list:=TStringList.Create;
 try
 
  All_mac_list(Mac_list);
   Mac_list.Add(mac_nul);
  SetLength(arr,Mac_list.Count);
  
      for i := 0 to Mac_list.Count - 1 do
       begin
          pkey:= Mac_list.Strings[i]+'$'+LogikHDD+'$'+ compName+'$'+bios_uid+'$'+SaltKey_64;
          pkey:= GetStringHash(pkey);
        //  SaveLogKey('610 Listkey '+pkey);
          salt:= SaltKey4;
          psalt:= pwidechar(SaltKey4);
         //  SaveLogKey('617 Listkey '+pkey);
           {=массив хэшей}
          arr[i]:=EncryptStringtea(pkey,psalt,length(salt));
         
       end;                              
   //result:= arr;
 finally
   FreeAndNil(Mac_list);
 end;
  finally
    CoUninitialize;
  end;
 
 result :=arr;
  SaveLogKey('good 625');
end;


  {=// определить мак адрес для физической сетевой}
function Mac_v20:string;
  const uid_const='0768F8A494234DD0BE567156AB7BA8B1';   
var
  ver: integer;
   
   //motherBoard,
   str_mac :string;   
//  pkey,salt:widestring;
   // :pointer;
begin
str_mac:='';
 SaveLogKey('577');

     {=Версия винды}
  ver:=WinInt_Version;
  if ver<=5 then  // xp  и ниже
      str_mac := uid_const
  else    
      str_mac := mac_PhysicalAdapter;

 

 
 result :=str_mac;
  SaveLogKey('good 625');
end;

{mac физической платы}
function mac_PhysicalAdapter:string;
 const
  wbemFlagForwardOnly = $00000020;
    const uid_const='0768F8A494234DD0BE567156AB7BA8B1'; 
var
  SWbemLocator: TSWbemLocator;
//Service: ISWbemServices;

  FWMIService   : ISWbemServices;
  FWbemObjectSet: ISWbemObjectSet;
  FWbemObject   : OleVariant;
    nm,val : OleVariant;
    val1:double;
  FSWbemObject  : ISWbemObject;

  PropSet: ISWbemPropertySet;
  SProp   : ISWbemProperty;

  oEnum,PropEnum         : IEnumvariant;
  iValue        : LongWord;
   str_mac : String;
   ver : integer; 
  //dt: TDatetime;
   i,j: integer;
   NetAdapter:TNetAdapter;
  NetParam: array[0..30] of TNetAdapter;
   Mac_list:TStringList;
begin 
    CoInitialize(nil);
 try
 i:=0;
  str_mac:=uid_const;
  Mac_list:=TStringList.Create;
  try
  SWbemLocator:=TSWbemLocator.Create(nil);
  FWMIService   := SWbemLocator.ConnectServer('.', 'root\CIMV2',  '', '', '', '', 0, nil);
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM  Win32_NetworkAdapter where  PhysicalAdapter = TRUE and NetEnabled=TRUE ','WQL',wbemFlagForwardOnly,nil);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while (oEnum.Next(1, FWbemObject, iValue) = S_OK) do
  begin
    FSWbemObject:= IUnknown(FWbemObject) as SWBemObject; 
    PropSet:= FSWbemObject.Properties_; 
    PropEnum:= (PropSet._NewEnum) as IEnumVariant; 

     while PropEnum.Next(1, FWbemObject, iValue) = S_OK do 
     begin 
      SProp:= IUnknown(FWbemObject) as SWBemProperty; 
       nm:=SProp.Name;
       val:='';

      
       if nm='MACAddress'  then 
       begin
         val:= SProp.Get_Value;
          if val=null then  val:='null';
              NetAdapter.Mac:=StringReplace(val,':','-',[rfReplaceAll, rfIgnoreCase]);
                end;
          
       if nm='PhysicalAdapter' then
         begin
     
         val:= SProp.Get_Value;
          if val=null then  val:='null'
          else
          if val=True then
             val:='True'
         
             else val:='false';
          NetAdapter.PhysicalAdapter:=val;
    
        
        end;
       if nm='Description' then  
        begin
   
         val:= SProp.Get_Value;
          if val=null then  val:='null';
   
           NetAdapter.Description:=val;
       end;
       ///////////////////////////////////////////
    
     end;
      if pos(NetAdapter.Mac,'null')=0 then  //убираем пустые
      if pos(NetAdapter.Mac,str_mac)=0 then  //убираем дубли
        begin
          Mac_list.Add(NetAdapter.mac);
          NetParam[i].Mac:=NetAdapter.Mac;
          NetParam[i].PhysicalAdapter:=NetAdapter.PhysicalAdapter;
          NetParam[i].Description:=NetAdapter.Description;
         // str_mac:=str_mac+','+NetAdapter.Mac;
              inc(i);   
        end;
   
     
   end;
   if Mac_list.Count >0 then
   begin
     str_mac:=Mac_list.Strings[0];
   end;
     
  finally
    FreeAndNil(Mac_list);
  end;
 FreeAndNil(swbemLocator);
   finally
    CoUninitialize;
  end;
  result:=str_mac;
end;




 {=версия windows}
function WinInt_Version:integer;
var
 VerInfo : TOSVersionInfo;
 caption:integer;
begin
Caption:=0;
  FillChar(VerInfo, SizeOf(VerInfo), 0);
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  GetVersionEx(VerInfo);
  Caption := VerInfo.dwMajorVersion;
  result:=Caption;           

end;

procedure All_mac_list(var MacL:TstringList);
 const
  wbemFlagForwardOnly = $00000020;
var
  SWbemLocator: TSWbemLocator;
//Service: ISWbemServices;

  FWMIService   : ISWbemServices;
  FWbemObjectSet: ISWbemObjectSet;
  FWbemObject   : OleVariant;
    nm,val : OleVariant;
    val1:double;
  FSWbemObject  : ISWbemObject;

  PropSet: ISWbemPropertySet;
  SProp   : ISWbemProperty;

  oEnum,PropEnum         : IEnumvariant;
  iValue        : LongWord;
   str_mac : String;
   ver : integer; 
  //dt: TDatetime;
   i,j: integer;
   NetAdapter:TNetAdapter;
   NetParam: array[0..30] of TNetAdapter;
begin 
 i:=0;
 str_mac:='';
   {=Версия винды}
   ver:=WinInt_Version;
  SWbemLocator:=TSWbemLocator.Create(nil);
 
    FWMIService   := SWbemLocator.ConnectServer('.', 'root\CIMV2',  '', '', '', '', 0, nil);
   FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM  Win32_NetworkAdapter ','WQL',wbemFlagForwardOnly,nil);
   oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while (oEnum.Next(1, FWbemObject, iValue) = S_OK) do
  begin
    FSWbemObject:= IUnknown(FWbemObject) as SWBemObject; 
    PropSet:= FSWbemObject.Properties_; 
    PropEnum:= (PropSet._NewEnum) as IEnumVariant; 

     while PropEnum.Next(1, FWbemObject, iValue) = S_OK do 
     begin 
      SProp:= IUnknown(FWbemObject) as SWBemProperty; 
       nm:=SProp.Name;
       val:='';

      
       if nm='MACAddress'  then 
       begin
         val:= SProp.Get_Value;
          if val=null then  val:='null';
              NetAdapter.Mac:=StringReplace(val,':','-',[rfReplaceAll, rfIgnoreCase]);
                end;
          
       if nm='PhysicalAdapter' then
         begin
     
         val:= SProp.Get_Value;
          if val=null then  val:='null'
          else
          if val=True then
             val:='True'
         
             else val:='false';
          NetAdapter.PhysicalAdapter:=val;
    
        
        end;
       if nm='Description' then  
        begin
   
         val:= SProp.Get_Value;
          if val=null then  val:='null';
   
           NetAdapter.Description:=val;
       end;
       ///////////////////////////////////////////
    
     end;
      if pos(NetAdapter.Mac,'null')=0 then  //убираем пустые
      if pos(NetAdapter.Mac,str_mac)=0 then  //убираем дубли
        begin
          MacL.Add(NetAdapter.mac);
          NetParam[i].Mac:=NetAdapter.Mac;
          NetParam[i].PhysicalAdapter:=NetAdapter.PhysicalAdapter;
          NetParam[i].Description:=NetAdapter.Description;
          str_mac:=str_mac+','+NetAdapter.Mac;
              inc(i);   
        end;
   
     
   end;
 FreeAndNil(swbemLocator);
 
 (*for j := 0 to i-1 do
  begin
  if NetParam[j].Mac<>'' then
   begin
     RichEdit1.Lines.Add('------ '+IntTostr(j)+' -------------');
     RichEdit1.Lines.Add( 'Description='+NetParam[j].Description);
     RichEdit1.Lines.Add( 'Mac='+NetParam[j].Mac);
     RichEdit1.Lines.Add( 'PhysicalAdapter='+BoolToStr(NetParam[j].PhysicalAdapter,True));
     RichEdit1.Lines.Add('---------___----------'); 
   end;
  end;  *)
end;








{=ключ на основе железа}
function genKey:widestring;
var pkey,salt:widestring;
   psalt :pointer;
begin

 {pkey:= CodeGenerate;   23-08-2021}
 //генерим ключ с привязкой к реальному  v20
 pkey:= CodeGenerate_v20;  
//pkey:='6C-F0-49-B3-0B-45$9AC89D86$PROG_2$30464336-3934-3342-3042-3435FFFFFFFF$YnVuMTcwOF9rYXZlbG1lZHNoYXYxOTkw';
//pkey:='1C-1B-0D-68-A4-84$C0101665$PROG-7$031B021C-040D-0568-A406-840700080009$YnVuMTcwOF9rYXZlbG1lZHNoYXYxOTkw';
// SaveLogKey('470 key '+pkey);
 pkey:= GetStringHash(pkey);
//  SaveLogKey('470 key '+pkey);
 salt:= SaltKey4;
 psalt:= pwidechar(SaltKey4);
  //SaveLogKey('371 key '+pkey);
 result:=EncryptStringtea(pkey,psalt,length(salt));
end;







 initialization


finalization
end.
