unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, uCmdBox, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Grids, Menus, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ClearHistory: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    CmdBox1: TCmdBox;
    Label1: TLabel;
    HistoryList: TListBox;
    Panel1: TPanel;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    procedure ClearHistoryClick(Sender: TObject);
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
var
  iPos,i: Integer;
  StrList: TStringList;
  func: string;
begin
  StrList:= TStringList.Create;
  Input := Trim(Input);
  iPos:= Pos( '(', Input );
  func:= Trim( Copy( Input, 1, iPos - 1 ));
  StrList.Delimiter:=',' ;
  StrList.StrictDelimiter:= true;
  StrList.DelimitedText:= Copy( Input, iPos + 1, Length( Input ) - iPos - 1  );
  case func of
        'root' : begin
          ShowMessage('Se detecto la funcion root');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'polyroot' : begin
          ShowMessage('Se detecto la funcion polyroot');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'polynomial' : begin
          ShowMessage('Se detecto la funcion polynomial');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'SENL' : begin
          ShowMessage('Se detecto la funcion SENL');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'plot2d' : begin
          ShowMessage('Se detecto la funcion plot2d');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'intersection' : begin
          ShowMessage('Se detecto la funcion intersection');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'help': ShowMessage('NecesitoAyuda');
        'exit': begin
          ShowMessage('vamos a salir');
          Application.Terminate;
        end;
        'plot': begin
          ShowMessage('Usted quiere ver el plano cartesiano');
          Chart1.Visible := True;
        end;
        'noplot': begin
          ShowMessage('Usted quiere ocultar el plano cartesiano');
          Chart1.Visible := False;
        end;
  end;
  CmdBox1.StartRead(clBlack,clWhite,'Numericus>',clBlack,clWhite);
  HistoryList.Clear;
  for i:=0 to CmdBox1.HistoryCount-1 do HistoryList.Items.Add(CmdBox1.History[i]);
end;

procedure TForm1.ClearHistoryClick(Sender: TObject);
begin
  CmdBox1.ClearHistory;
  HistoryList.Clear;
end;

end.

