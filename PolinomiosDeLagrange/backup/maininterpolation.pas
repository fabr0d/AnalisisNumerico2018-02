unit mainInterpolation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, TATools, Forms,
  Controls, Graphics, Dialogs, StdCtrls, Grids, LogicInterpolation, ParseMath;

type

  { TLagrangefrm }

  TLagrangefrm = class(TForm)
    btnSetTotalPoints: TButton;
    btnCalculate: TButton;
    btnAddPoint: TButton;
    ediPolinomy1: TEdit;
    ediTotalPoints: TEdit;
    edix: TEdit;
    ediy: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    stgPoints: TStringGrid;
    procedure btnAddPointClick(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
    procedure btnSetTotalPointsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    interpolation: TInterpolation;
    calcFx1 : Boolean;
  public

  end;

var
  Lagrangefrm: TLagrangefrm;
  numPoints : Integer;

implementation

{$R *.lfm}

{ TLagrangefrm }

procedure TLagrangefrm.btnSetTotalPointsClick(Sender: TObject);
var
  n, i : Integer;
begin
  n := StrToInt(ediTotalPoints.text);
  if n < 1 then
     raise Exception.create('El numero de puntos no es valido');

  interpolation := TInterpolation.create(n);
  stgPoints.RowCount := n + 1;
  for i:=1 to n do
      stgPoints.cells[0,i] := IntToStr(i);
  numPoints := 0;
  ediX.Enabled := True;
  ediY.Enabled := True;

end;

procedure TLagrangefrm.btnAddPointClick(Sender: TObject);
var
  x, y : Real;
begin
  if numPoints = interpolation.tp then exit();
  x := StrToFloat(edix.text);
  y := StrToFloat(ediy.text);
  interpolation.arrPoints[numPoints].x := x;
  interpolation.arrPoints[numPoints].y := y;
  stgPoints.cells[1,numPoints+1] := FloatToStr(x);
  stgPoints.cells[2,numPoints+1] := FloatToStr(y);


  numPoints := numPoints + 1;

end;

procedure TLagrangefrm.btnCalculateClick(Sender: TObject);
var
  s: String;
begin
  s := interpolation.getPolinomy();
  if calcFx1 then begin
    ediPolinomy1.text := s;
  end
end;

procedure TLagrangefrm.FormCreate(Sender: TObject);
begin
    interpolation := TInterpolation.create(0);
    calcFx1 := True;
end;

end.

