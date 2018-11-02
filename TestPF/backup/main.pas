unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, uCmdBox, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Grids, Menus, StdCtrls, SENLClass, ParseMath;

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
    procedure FormDestroy(Sender: TObject);
  private
    MetodosSENL: SENLFunciones;
    Parse1: TParseMath;
    function f(x: Real): Real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  h: Real;
begin
  MetodosSENL:= SENLFunciones.create;
  CmdBox1.StartRead(clBlack,clWhite,'Numericus> ',clBlack,clWhite);
  h:=0.001;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  MetodosSENL.Destroy;
end;

function TForm1.f(x: Real): Real;
begin

end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
var
  SENLObject: SENLFunciones;
  iPos,i: Integer;
  StrList: TStringList;
  func,respuesta: string;
begin
  SENLObject:=SENLFunciones.create;
  StrList:= TStringList.Create;
  Input := Trim(Input);
  iPos:= Pos( '(', Input );
  func:= Trim( Copy( Input, 1, iPos - 1 ));
  StrList.Delimiter:=',' ;
  StrList.StrictDelimiter:= true;
  StrList.DelimitedText:= Copy( Input, iPos + 1, Length( Input ) - iPos - 1  );
  CmdBox1.TextColors(clBlack,clWhite);
  case func of
        'root' : begin
          CmdBox1.Writeln('Se detecto la funcion : root');
          CmdBox1.Writeln('funcion :'+StrList[0]);
          SENLObject.fx := StrList[0];

          CmdBox1.Writeln('a :'+StrList[1]);
          SENLObject.a := StrToFloat(StrList[1]);

          CmdBox1.Writeln('b :'+StrList[2]);
          SENLObject.b := StrToFloat(StrList[2]);

          CmdBox1.Writeln('Metodo :'+StrList[3]);
          case StrList[3] of
                '0' :begin
                  respuesta := SENLObject.Biseccion();
                end;
                '1' :begin
                  respuesta := SENLObject.FalsaPosicion();
                end;
                '2' :begin
                  respuesta := SENLObject.Secante();
                end;
          end;

          CmdBox1.Writeln('Uno o Todos :'+StrList[4]);
        end;
        'polyroot' : begin
          CmdBox1.Writeln('Se detecto la funcion : polyroot');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'polynomial' : begin
          CmdBox1.Writeln('Se detecto la funcion : polynomial');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'SENL' : begin
          CmdBox1.Writeln('Se detecto la funcion : SENL');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'plot2d' : begin
          CmdBox1.Writeln('Se detecto la funcion : plot2d');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'intersection' : begin
          CmdBox1.Writeln('Se detecto la funcion : intersection');
          for iPos:= 0 to StrList.Count - 1 do
          begin
            ShowMessage( 'Parámetro ' + IntToStr( iPos + 1 ) + ': ' + StrList[ iPos ] );
          end;
        end;
        'help': CmdBox1.Writeln('NecesitoAyuda');
        'exit': begin
          ShowMessage('vamos a salir');
          Application.Terminate;
        end;
        'plot': begin
          CmdBox1.Writeln('Usted quiere ver el plano cartesiano');
          Chart1.Visible := True;
        end;
        'noplot': begin
          CmdBox1.Writeln('Usted quiere ocultar el plano cartesiano');
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

