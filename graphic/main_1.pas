unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TATools, TAFuncSeries, TASeries, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Grids, ComCtrls,
  framefunctions, Types, class_senl, ParseMath, TAChartUtils;

type

  { TfrmGraphics }

  TfrmGraphics = class(TForm)
    Button1: TButton;
    charFunction: TChart;
    charFunctionConstantLine1: TConstantLine;
    charFunctionConstantLine2: TConstantLine;
    charFunctionFuncSeries1: TFuncSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    Edit1: TEdit;
    GraphicScroll: TPanel;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure charFunctionFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure charFunctionFuncSeries2Calculate(const AX: Double; out AY: Double);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    GraphicFrame: Array of TGraphicsFrameTemplate;
    Func1, Func2: String;
    Punto1, Punto2: Double;
    Sistema: TSENL;
    cont: Integer;

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

procedure TfrmGraphics.Button1Click(Sender: TObject);
begin
  Sistema:=TSENL.Create;
  Sistema.MethodFunction:=Func1+'-('+Func2+')';
  Sistema.a:= Punto1;
  Sistema.b:= Punto2;
  Sistema.ErrorAllowed:= 0.00001;
  Sistema.IndexMethodType:= 0;
  ShowMessage(Sistema.MethodFunction);
  //ShowMessage(FloatToStr(Sistema.a));
  //ShowMessage(FloatToStr(Sistema.b));

  Edit1.Text:=FloatToStr(Sistema.Execute());
end;

procedure TfrmGraphics.charFunctionFuncSeries2Calculate(const AX: Double; out
  AY: Double);
begin
  AY:= AX;
end;

procedure TfrmGraphics.ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
var
  PointDouble: TDoublePoint;
  x,y: Double;
begin
  with ATool as TDatapointClickTool do
    if (Series <> nil) then
      with (Series as TFuncSeries) do begin
        PointDouble:=charFunction.ImageToGraph(APoint);
        ShowMessage( GraphicFrame[ TFuncSeries(Series).Tag ].ediF.Text );
        if (cont = 0) then begin
          Func1:= GraphicFrame[ TFuncSeries(Series).Tag ].ediF.Text;
          Punto1:= PointDouble.X;
        end else if (cont = 1) then begin
          Func2:= GraphicFrame[ TFuncSeries(Series).Tag ].ediF.Text;
          Punto2:= PointDouble.X;

        end;
        cont:= cont+1;

      end;
end;

procedure TfrmGraphics.FormCreate(Sender: TObject);
begin
  GFMaxPosition:= -1;
  AddGraphics;
  cont:=0;

end;

procedure TfrmGraphics.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i:= 0 to Length( GraphicFrame ) - 1 do
      if Assigned( GraphicFrame[ i ] ) then
         GraphicFrame[ i ].Destroy;

end;

end.

