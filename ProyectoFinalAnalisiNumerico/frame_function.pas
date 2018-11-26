unit frame_function;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, LCLType, TAGraph, TAFuncSeries, math, ParseMath;

type

  { TFrameFunction }

  TFrameFunction = class(TFrame)
    ColorButtonF: TColorButton;
    EditFDA: TEdit;
    EditFDB: TEdit;
    EditF: TEdit;
    LabelFD: TLabel;
    PanelFF: TPanel;
    procedure ColorButtonFColorChanged(Sender: TObject);
    procedure EditFKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FrameClick(Sender: TObject);
    procedure FuncSeriesCalculate(const AX: Double; out AY: Double);
    procedure PlotFunc(funtion1, rangoA, rangoB, colorDeF1 : string);
    procedure cleanFrame();
  private
    //IsLastOne: Boolean;
    Parse: TParseMath;
    function f(x: Real): Real;

  public
    FuncColor: TColor;
    FuncSeries: TFuncSeries;

  end;

var
  FrameFunction: TFrameFunction;

implementation

uses main;

{$R *.lfm}

{ TFrameFunction }

function TFrameFunction.f(x: Real): Real;
begin
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();
end;

procedure TFrameFunction.FuncSeriesCalculate(const AX: Double; out AY: Double);
begin
  AY:= f( AX );
end;

procedure TFrameFunction.ColorButtonFColorChanged(Sender: TObject);
begin
  FuncColor:= ColorButtonF.ButtonColor;
   if Assigned( FuncSeries ) then
      FuncSeries.Pen.Color:= FuncColor;

end;

procedure TFrameFunction.PlotFunc(funtion1, rangoA, rangoB, colorDeF1 : string);
begin
  //ShowMessage(colorDeF1);
  with Form1 do begin
     if not Assigned( FuncSeries ) then begin
        FuncSeries:= TFuncSeries.Create( Chart1 );
        FuncSeries.Tag:= Form1.GFMaxPosition;
        Chart1.AddSeries( FuncSeries );
     end;
     FuncColor:=StringToColor(colorDeF1);
     FuncSeries.Pen.Color:= FuncColor;
     FuncSeries.Active:= False;
     Parse:= TParseMath.create;
     Parse.Expression:= funtion1;
     Parse.AddVariable( 'x', 0);
     FuncSeries.OnCalculate:= @FuncSeriesCalculate;
     //ShowMessage(rangoA+' '+rangoB);
     with FuncSeries.DomainExclusions do begin
        if rangoA <> '-inf' then
           AddRange(NegInfinity,StrToFloat(rangoA));
        if rangoB <> 'inf' then
           AddRange(StrToFloat(rangoB),Infinity);
     end;
     EditF.Text := funtion1;
     EditFDA.Text := rangoA;
     EditFDB.Text := rangoB;
     FuncSeries.Active:= True;
     if Self.Tag = Form1.GFMaxPosition then
        Form1.AddGraphics;
  end;

end;
procedure TFrameFunction.cleanFrame();
begin
  FuncSeries.Active := False;
end;

procedure TFrameFunction.EditFKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not (Key = VK_RETURN) then
     exit;

  with Form1 do begin
     if not Assigned( FuncSeries ) then begin
        FuncSeries:= TFuncSeries.Create( Chart1 );
        FuncSeries.Tag:= Form1.GFMaxPosition;
        Chart1.AddSeries( FuncSeries );
     end;

     FuncSeries.Pen.Color:= FuncColor;
     FuncSeries.Active:= False;
     Parse:= TParseMath.create;
     Parse.Expression:= EditF.Text;
     Parse.AddVariable( 'x', 0);
     FuncSeries.OnCalculate:= @FuncSeriesCalculate;
     with FuncSeries.DomainExclusions do begin
        if EditFDA.Text <> '-inf' then
           AddRange(NegInfinity,StrToFloat(EditFDA.Text));
        if EditFDB.Text <> 'inf' then
           AddRange(StrToFloat(EditFDB.Text),Infinity);
     end;

     FuncSeries.Active:= True;

     if Self.Tag = Form1.GFMaxPosition then
        Form1.AddGraphics;

  end;

end;

procedure TFrameFunction.FrameClick(Sender: TObject);
begin
  Form1.GFActualPosition:= Self.Tag;
  PanelFF.Color:= clGray;

end;

end.


