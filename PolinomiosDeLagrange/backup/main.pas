unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries,
  TATransformations, TAChartCombos, TAStyles, TAIntervalSources, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  { TfrmMain }

  TfrmMain = class(TForm)
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsFuncSeries2: TFuncSeries;
    chartGraphicsFuncSeries3: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    procedure btnGraphClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure btnGraph2Click(Sender: TObject);
    procedure btn_calculateClick(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure chartGraphicsFuncSeries2Calculate(const AX: Double; out AY: Double);
    procedure chartGraphicsFuncSeries3Calculate(const AX: Double; out AY: Double
      );
    procedure chkProportionalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private

  public
      Bolzano : TOCMethods;
  end;
var
  frmMain: TfrmMain;


implementation

{$R *.lfm}
{ TfrmMain }

procedure TfrmMain.btnGraphClick(Sender: TObject);
begin
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= True;
end;

procedure TfrmMain.btnGraph2Click(Sender: TObject);
begin
  chartGraphicsFuncSeries2.Pen.Color:= clRed;
  chartGraphicsFuncSeries2.Active:= True;
end;



procedure TfrmMain.btnPointClick(Sender: TObject);
var x, y: Real;
begin
  x:= StrToFloat(ediPointX.Text);
  y:= StrToFloat(ediPointY.Text);
  chartGraphicsLineSeries1.AddXY( x, y );
end;
//Caso opcional, en en futuro, el de la respuesta oscilante.
procedure TfrmMain.btn_calculateClick(Sender: TObject);
var
  x: Real;
begin
  FormResults.show;
  Bolzano.b := StrToFloat(EdiBeginInterval.Text);
  Bolzano.e := StrToFloat(EdiEndInterval.Text);
  Bolzano.X0 :=  StrTofLoat(EdiX0.Text);
  Bolzano.FunctionType := cmb_biseccion.Itemindex;
  Bolzano.calculateMode := cmb_mode.ItemIndex;
  x := Bolzano.Execute();
  if Bolzano.calculateMode = isModeIntersect then
     chartGraphicsLineSeries1.AddXY( x, Fx(x))
  else
     chartGraphicsLineSeries1.AddXY( x, 0);
  FormResults.sequenceXn    := Bolzano.sequenceXn;
  FormResults.sequenceError := Bolzano.sequenceError;
  FormResults.doResults();

end;

procedure TfrmMain.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  AY:= ( Fx(AX) );
end;

procedure TfrmMain.chartGraphicsFuncSeries2Calculate(const AX: Double; out AY: Double);
begin
  AY:= ( dFx(AX) );
end;

procedure TfrmMain.chartGraphicsFuncSeries3Calculate(const AX: Double; out
  AY: Double);
begin
  AY:= ( Gx(AX) );
end;

procedure TfrmMain.chkProportionalChange(Sender: TObject);
begin
  chartGraphics.Proportional:= not chartGraphics.Proportional;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries1.ShowLines:= False;
  Bolzano := TOCMethods.create;
  cmb_biseccion.items.assign(Bolzano.FunctionList);
  cmb_biseccion.itemindex := 0;
  cmb_mode.items.assign(Bolzano.CalculateModeList);
  cmb_mode.itemindex := 0;
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries2.Pen.Color:= clGreen;
  chartGraphicsFuncSeries3.Pen.Color:= clRed;
end;

procedure TfrmMain.trbMaxChange(Sender: TObject);
begin
  chartGraphics.Extent.XMax:= trbMax.Position;
end;

procedure TfrmMain.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
end;


end.

