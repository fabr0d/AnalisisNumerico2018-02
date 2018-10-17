unit frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, LCLType,
  ColorBox, Dialogs, TAGraph, TAFuncSeries, math, ParseMath, Graphics, ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    cbtnFunSeriesColor: TColorButton;
    ediF: TEdit;
    Panel1: TPanel;
  private
    IsLastOne: Boolean;
    Parse: TParseMath;

    function f(x: Real): Real;
  public
     FuncColor: TColor;
     FuncSeries: TFuncSeries;
  end;



implementation

uses main;

{$R *.lfm}

{ TForm2 }

function TForm2.f(x: Real): Real;
begin

end;

{ TGraphicsFrameTemplate }

function TGraphicsFrameTemplate.f(x: Real): Real;
begin
    Parse.NewValue('x', x);
    Result:= Parse.Evaluate();
end;

procedure TGraphicsFrameTemplate.FuncSeriesCalculate(const AX: Double; out
  AY: Double);
begin
    AY:= f( AX )

end;

procedure TGraphicsFrameTemplate.ediFKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not (Key = VK_RETURN) then
     exit;

  with frmGraphics do begin
     if not Assigned( FuncSeries ) then begin
        FuncSeries:= TFuncSeries.Create( charFunction );
        charFunction.AddSeries( FuncSeries );
     end;

     FuncSeries.Pen.Color:= FuncColor;
     FuncSeries.Active:= False;
     Parse:= TparseMath.create;
     Parse.Expression:= ediF.Text;
     Parse.AddVariable( 'x', 0);
     FuncSeries.OnCalculate:= @FuncSeriesCalculate;

     FuncSeries.Active:= True;

     if Self.Tag = frmGraphics.GFMaxPosition then
        frmGraphics.AddGraphics;


  end;

end;

procedure TGraphicsFrameTemplate.FrameClick(Sender: TObject);
begin
  frmGraphics.GFActualPosition:= Self.Tag;
  Panel1.Color:= clGray;
end;

procedure TGraphicsFrameTemplate.cbtnFunSeriesColorColorChanged(Sender: TObject
  );
begin
   FuncColor:= cbtnFunSeriesColor.ButtonColor;
   if Assigned( FuncSeries ) then
      FuncSeries.Pen.Color:= FuncColor;
end;

end.
