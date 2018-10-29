unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, uCmdBox, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Grids, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    CmdBox1: TCmdBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  CmdBox1.StartRead(clBlack,clWhite,'Numericus> ',clBlack,clWhite)
end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
begin
  case Input of
        'help': ShowMessage('NecesitoAyuda');
        'exit': begin
          ShowMessage('vamos a salir');
          Application.Terminate;
        end;
        'plot': Chart1.Visible := True;
        'noplot': Chart1.Visible := False;
  end;
  CmdBox1.StartRead(clBlack,clWhite,'numerico>',clBlack,clWhite);
end;

end.

