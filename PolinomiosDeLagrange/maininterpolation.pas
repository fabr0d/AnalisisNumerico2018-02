unit mainInterpolation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, TATools, Forms,
  Controls, Graphics, Dialogs, StdCtrls, Grids, LogicInterpolation, ParseMath, class_bolzano;

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
    procedure btnIntersectClick(Sender: TObject);
    procedure btnSetTotalPointsClick(Sender: TObject);
    procedure chrFunctionResultFuncSeries1Calculate(const AX: Double; out
      AY: Double);
    procedure chrFunctionResultFuncSeries2Calculate(const AX: Double; out
      AY: Double);
    procedure FormCreate(Sender: TObject);
  private
    interpolation: TInterpolation;
    OCMethods: TOCMethods;
    calcFx1 : Boolean;
  public

  end;
function Fx1(x: double): double;
function Fx2(x: double): double;
function Fx3(x: double): double;

var
  Lagrangefrm: TLagrangefrm;
  numPoints : Integer;
  rawFx1, rawFx2: TParseMath;

implementation

{$R *.lfm}

{ TLagrangefrm }
function Fx1(x: double): double;
begin
    rawFx1.newValue('x',x);
    Result := rawFx1.evaluate();
end;

function Fx2(x: double): double;
begin
    rawFx2.newValue('x',x);
    Result := rawFx2.evaluate();
end;

function Fx3(x: double): double;
begin
    rawFx1.newValue('x',x);
    rawFx2.newValue('x',x);
    Result := rawFx1.evaluate() - rawFx2.evaluate();
end;

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

procedure TLagrangefrm.chrFunctionResultFuncSeries1Calculate(const AX: Double; out
  AY: Double);
begin
  Ay := Fx1(AX);
end;

procedure TLagrangefrm.chrFunctionResultFuncSeries2Calculate(const AX: Double; out
  AY: Double);
begin
  Ay := Fx2(AX);
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
  i: integer;
begin
  s := interpolation.getPolinomy();
  if calcFx1 then begin
    ediPolinomy1.text := s;
    rawFx1.Expression:=s;
    //chrFunctionResultFuncSeries1.Active:= True;
    //chrFunctionResultConstantLine3.Position := interpolation.limInferior();
    //chrFunctionResultConstantLine4.Position := interpolation.limSuperior();
  end
  else begin
    //ediPolinomy2.text := s;
    rawFx2.Expression:=s;
    //chrFunctionResultFuncSeries2.Active:= True;
    //chrFunctionResultConstantLine5.Position := interpolation.limInferior();
    //chrFunctionResultConstantLine6.Position := interpolation.limSuperior();
  end;
end;

procedure TLagrangefrm.btnIntersectClick(Sender: TObject);
begin
  stgPoints.RowCount:=1; //Limpia el StringGrid
  ediX.text := '';
  ediY.text := '';
  ediX.Enabled := False;
  ediY.Enabled := False;
  //ediPolinomy2.Enabled := True;
  calcFx1 := False;

end;

procedure TLagrangefrm.FormCreate(Sender: TObject);
begin
    interpolation := TInterpolation.create(0);
    OCMethods := TOCMethods.create();
    rawFx1 := TParseMath.create();
    rawFx1.AddVariable('x',0);
    rawFx2 := TParseMath.create();
    rawFx2.AddVariable('x',0);
    calcFx1 := True;
end;

end.

