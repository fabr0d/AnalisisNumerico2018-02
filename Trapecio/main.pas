unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, MetodosDeIntegracion,
  ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CBMetodos: TComboBox;
    EditFuncion: TEdit;
    EditA: TEdit;
    EditB: TEdit;
    EditN: TEdit;
    EditResultado: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Methods: FuncionesMetodosIntegracion;
    Parse1: TParseMath;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  AMethods: FuncionesMetodosIntegracion;
  s: String;
begin
  //ShowMessage('This is a message from Lazarus');
  Parse1.Expression:= EditFuncion.Text;
  AMethods:= FuncionesMetodosIntegracion.create;
  with AMethods do
  begin
    a := StrToFloat(EditA.Text);
    b := StrToFloat(EditB.Text);
    n := StrToInt(EditN.Text);
    fx := EditFuncion.Text;
    MethodType:= Int64(CBMetodos.Items.Objects[CBMetodos.ItemIndex]);
    s:= Execute();
    EditResultado.Text := s;
  end;
end;
procedure TForm1.FormCreate(Sender: TObject);
begin
  Methods:= FuncionesMetodosIntegracion.create;
  CBMetodos.Items.Assign(Methods.MethodList);
  CBMetodos.ItemIndex:= 0;
  //ShowMessage('This is a message from Lazarus');
  Parse1:= TParseMath.create();
  Parse1.AddVariable('x', 0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Methods.Destroy;
  Parse1.destroy;
end;
end.

