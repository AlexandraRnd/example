unit u_PosTerNastr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvSmoothButton, ExtCtrls,u_Pos_Terminal;

type
  TfrmPosTerm = class(TForm)
    Panel: TPanel;
    edSum: TEdit;
    bConnect: TAdvSmoothButton;
    lbPing: TLabel;
    bFullPayOut: TAdvSmoothButton;
    bFullPayIn: TAdvSmoothButton;
    Label2: TLabel;
    ClosePOS: TAdvSmoothButton;
    chbPrintKKT: TCheckBox;
    bCancel: TAdvSmoothButton;
    Bevel1: TBevel;
    X_rep: TAdvSmoothButton;
    Label1: TLabel;
    procedure edSumKeyPress(Sender: TObject; var Key: Char);
    procedure bConnectClick(Sender: TObject);
    procedure ClosePOSClick(Sender: TObject);
    procedure bFullPayInClick(Sender: TObject);
    procedure bFullPayOutClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure X_repClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



     
var
  frmPosTerm: TfrmPosTerm;

implementation
 uses u_const;

{$R *.dfm}

procedure TfrmPosTerm.bCancelClick(Sender: TObject);
begin
 close;
end;

procedure TfrmPosTerm.bConnectClick(Sender: TObject);
var str : string;
begin

  ping_posTerminal;
     case TypePinpad of
    pNotPinpad : lbPing.Caption:='���������� ����� '+' ��� Pos���';
    pfillPinpad    : lbPing.Caption:='���������� ����� '+' ��� Pos���';
     
   end;
end;

procedure TfrmPosTerm.bFullPayInClick(Sender: TObject);
var pCheck,CardID_out:string;
    pPay_packed:TPay_packed;
begin
if edSum.Text='' then 
   begin
     ShowMessage('������� ����� ������!');
     exit;
   end;

 pPay_packed.Summa:=StrToFloat(edSum.Text);
 pPay_packed.opertype:=1;
 
 pCheck:= payPosTerminal(pPay_packed.Summa,pPay_packed.opertype);
 SaveLogPlut('===73==TfrmPosTerm  ��� ��� =====');
 SaveLogPlut(pCheck);
  SaveLogPlut('===75==TfrmPosTerm   =====');
  if pCheck='' then
   begin
     SaveLogPlut('payPosTerminal �� ������ ������ ��� �� ��� �� ��������!!');
     exit;
   end;
 
end;

procedure TfrmPosTerm.bFullPayOutClick(Sender: TObject);
var pCheck,CardID_out:string;
    pPay_packed:TPay_packed;
begin
if edSum.Text='' then 
   begin
     ShowMessage('������� ����� ������!');
     exit;
   end;

 pPay_packed.Summa:=StrToFloat(edSum.Text);
 pPay_packed.opertype:=2;
 
 pCheck:= payPosTerminal(pPay_packed.Summa,pPay_packed.opertype);
  SaveLogPlut('===96==TfrmPosTerm  ��� ��� =====');
 SaveLogPlut(pCheck);
   SaveLogPlut('===99==TfrmPosTerm   =====');
  if pCheck='' then
   begin
     SaveLogPlut('payPosTerminal �� ������ ������ ��� �� ��� �� ��������!!');
     exit;
   end;

end;

procedure TfrmPosTerm.ClosePOSClick(Sender: TObject);
var check_pos,slip: string;
begin
  if TypePinpad=pfillPinpad then 
         check_pos:=CloseSmena_posTerminal(slip);
    SaveLogPlut('TfrmPosTerm   '+#13+ slip)              
end;

procedure TfrmPosTerm.edSumKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9','.',#13,#8]) then key:=#0;
end;




procedure TfrmPosTerm.X_repClick(Sender: TObject);
var check_pos,slip: string;
begin
  if TypePinpad=pfillPinpad then 
         check_pos:=XSmena_posTerminal(slip);
  SaveLogPlut('TfrmPosTerm   '+#13+ slip)       
end;

end.
