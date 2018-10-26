unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

