unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, polinomios;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonCalcularPol: TButton;
    ButtonEstablecerRaices: TButton;
    ButtonAnadirRaiz: TButton;
    EditNumRaices: TEdit;
    EditPolFinal: TEdit;
    EditRaiz: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringRoots: TStringGrid;
    procedure ButtonAnadirRaizClick(Sender: TObject);
    procedure ButtonCalcularPolClick(Sender: TObject);
    procedure ButtonEstablecerRaicesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    polis: TPolis;
    calcFx1 : Boolean;
  public

  end;

var
  Form1: TForm1;
  numPoints : Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ButtonEstablecerRaicesClick(Sender: TObject);
  var
    n, i : Integer;
begin
  n := StrToInt(EditNumRaices.text);
  if n < 1 then
     raise Exception.create('El numero de puntos no es valido');

  polis := TPolis.create(n);
  StringRoots.RowCount := n + 1;
  for i:=1 to n do
      StringRoots.cells[0,i] := IntToStr(i);
  numPoints := 0;
  EditRaiz.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  polis := TPolis.create(0);
  calcFx1 := True;
end;

procedure TForm1.ButtonAnadirRaizClick(Sender: TObject);
  var
    x : Real;
  begin
    if numPoints = polis.tp then exit();
    x := StrToFloat(EditRaiz.text);
    polis.arrRoots[numPoints].x := x;
    StringRoots.cells[1,numPoints+1] := FloatToStr(x);
    numPoints := numPoints + 1;
end;

procedure TForm1.ButtonCalcularPolClick(Sender: TObject);
  var
    s: String;
  begin
    s := polis.getPolinomy();
    if calcFx1 then begin
      EditPolFinal.text := s;
    end
end;

end.

