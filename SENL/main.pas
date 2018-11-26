unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools,
  TAChartListbox, TANavigation, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ColorBox, ExtCtrls, Menus, ComCtrls, senl, ParseMath, Types, math,TAChartUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Chart1FuncSeries2: TFuncSeries;
    Chart1LineSeries1: TLineSeries;
    BtnEjecutar: TButton;
    CBsenl: TComboBox;
    EditF2A: TEdit;
    EditF2B: TEdit;
    EditF1A: TEdit;
    EditF1B: TEdit;
    EdtFuncion1: TEdit;
    EdtFuncion2: TEdit;
    EdtA: TEdit;
    EdtB: TEdit;
    EdtError: TEdit;
    Funcion1: TLabel;
    Funcion2: TLabel;
    a: TLabel;
    b: TLabel;
    Error: TLabel;
    Metodo: TLabel;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    procedure BtnEjecutarClick(Sender: TObject);
    procedure Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure Chart1FuncSeries2Calculate(const AX: Double; out AY: Double);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    //procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      //APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Methods: SENLFunciones;
    Parse1: TParseMath;
    Parse2: TParseMath;
    function f(x: Real): Real;
    function g(x: Real): Real;
    procedure Plot(x: Real);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.f( x: Real): Real;
begin
   Parse1.NewValue('x', x );
   Result:= Parse1.Evaluate();
end;

function TForm1.g( x: Real): Real;
begin
   Parse2.NewValue('x', x );
   Result:= Parse2.Evaluate();
end;

procedure TForm1.Plot( x: Real );
begin
   Chart1FuncSeries1.Active:= True;
   Chart1LineSeries1.ShowLines:= False;
   Chart1LineSeries1.ShowPoints:= True;
   Chart1LineSeries1.AddXY( x, f(x) );
   Chart1LineSeries1.Active:= True;
   Chart1FuncSeries2.Active:= True;
end;

procedure TForm1.BtnEjecutarClick(Sender: TObject);
var AMethods: SENLFunciones;
    i: Integer;
    s: String;
begin
  Parse1.Expression:= EdtFuncion1.Text;
  Parse2.Expression:= EdtFuncion2.Text;
  AMethods:= SENLFunciones.create;
  with AMethods do
    begin
       a:= StrToFloat( EdtA.Text );
       b:= StrToFloat( EdtB.Text );
       fx:= '(' + EdtFuncion1.Text + ')-(' + EdtFuncion2.Text + ')';
       ErrorAllowed:= StrToFloat( EdtError.Text );
       MethodType:= Int64(CBsenl.Items.Objects[CBsenl.ItemIndex]);
       with Chart1FuncSeries1.DomainExclusions do begin
        if EditF1A.Text <> '-inf' then
           AddRange(NegInfinity,StrToFloat(EditF1A.Text));
        if EditF1B.Text <> 'inf' then
           AddRange(StrToFloat(EditF1B.Text),Infinity);
       end;
       with Chart1FuncSeries1.DomainExclusions do begin
        if EditF2A.Text <> '-inf' then
           AddRange(NegInfinity,StrToFloat(EditF2A.Text));
        if EditF2B.Text <> 'inf' then
           AddRange(StrToFloat(EditF2B.Text),Infinity);
       end;
       s:= Execute;
       StringGrid1.RowCount:= Sequence.Count;
       StringGrid1.Cols[1].Assign( ValuesA );
       StringGrid1.Cols[2].Assign( ValuesB );
       StringGrid1.Cols[3].Assign( Sequence );
       StringGrid1.Cols[4].Assign( NError );
       if s <> 'NoCumpleBolzano' then Plot(xi);
  end;

  AMethods.Destroy;
  for i:= 0 to StringGrid1.RowCount -1 do
     StringGrid1.Cells[ 0, i ]:= IntToStr( i );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Methods:= SENLFunciones.create;
  CBsenl.Items.Assign(Methods.MethodList);
  CBsenl.ItemIndex:= 0;
  Parse1:= TParseMath.create();
  Parse1.AddVariable('x', 0);
  Parse2:= TParseMath.create();
  Parse2.AddVariable('x', 0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Methods.Destroy;
  Parse1.destroy;
  Parse2.destroy;
end;

procedure TForm1.Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

procedure TForm1.Chart1FuncSeries2Calculate(const AX: Double; out AY: Double);
begin
  AY := g(AX);
end;

procedure TForm1.ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool; APoint: TPoint);
var
  x, y: Double;
  DPoint: TDoublePoint;
begin
  DPoint:= Chart1.ImageToGraph(APoint);
  with ATool as TDatapointClickTool do
    if (Series is TLineSeries) then
      with TLineSeries(Series) do begin
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        ShowMessage(FloatToStr(DPoint.X) + ',' + FloatToStr(DPoint.Y));
        Statusbar1.SimpleText := Format('%s: x = %f, y = %f', [Title, x, y]);
      end
    else
      Statusbar1.SimpleText := '';
end;

end.

