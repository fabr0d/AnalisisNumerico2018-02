unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TATools, TAFuncSeries, TASeries, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, ComCtrls, framefunctions, Types;

type

  { TfrmGraphics }

  TfrmGraphics = class(TForm)
    charFunction: TChart;
    charFunctionConstantLine1: TConstantLine;
    charFunctionConstantLine2: TConstantLine;
    charFunctionFuncSeries1: TFuncSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    GraphicScroll: TPanel;
    StatusBar1: TStatusBar;
    procedure charFunctionFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    GraphicFrame: Array of TGraphicsFrameTemplate;

  public
    GFMaxPosition,
    GFActualPosition: Integer;
    procedure AddGraphics;
  end;

var
  frmGraphics: TfrmGraphics;

implementation

{$R *.lfm}

{ TfrmGraphics }

procedure TfrmGraphics.AddGraphics;
begin
   GFMaxPosition:= GFMaxPosition + 1;
   SetLength( GraphicFrame, GFMaxPosition + 1 );
   GraphicFrame[ GFMaxPosition ]:= TGraphicsFrameTemplate.Create( GraphicScroll );
   GraphicFrame[ GFMaxPosition ].Name:= 'GF'+ IntToStr( GFMaxPosition );
   GraphicFrame[ GFMaxPosition ].Parent:= GraphicScroll;
   GraphicFrame[ GFMaxPosition ].Align:= alTop;
   GraphicFrame[ GFMaxPosition ].Tag:= GFMaxPosition;

 (*  with GraphicFrame[ GFMaxPosition -1 ] do
   if GFMaxPosition > 1 then begin
      AnchorSide[akBottom].Side:= asrBottom;
      AnchorSide[akBottom].Control:= GraphicFrame[ GFMaxPosition  ];
      //Anchors:= GraphicFrame[ GFMaxPosition -1 ].Anchors + [akTop];
   end;

   *)
end;

procedure TfrmGraphics.charFunctionFuncSeries1Calculate(const AX: Double; out
  AY: Double);
begin

end;

procedure TfrmGraphics.ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
var
  x, y: Double;
begin
  with ATool as TDatapointClickTool do
    if (Series is TLineSeries) then
      with TLineSeries(Series) do begin
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        Statusbar1.SimpleText := Format('%s: x = %f, y = %f', [Title, x, y]);
      end
    else
      Statusbar1.SimpleText := '';
end;

procedure TfrmGraphics.FormCreate(Sender: TObject);
begin
  GFMaxPosition:= -1;
  AddGraphics;

end;

procedure TfrmGraphics.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i:= 0 to Length( GraphicFrame ) - 1 do
      if Assigned( GraphicFrame[ i ] ) then
         GraphicFrame[ i ].Destroy;

end;

end.

