unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, uCmdBox, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, Grids, Menus, StdCtrls, SENLClass, ParseMath,FuncionesAuxiliares;

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
    TablaDeVarsStrGrid: TStringGrid;
    procedure ClearHistoryClick(Sender: TObject);
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    MetodosSENL: SENLFunciones;
    Parse1: TParseMath;
    FuncsAuxs: FuncionesAux;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  MetodosSENL:= SENLFunciones.create;
  FuncsAuxs:= FuncionesAux.create;
  CmdBox1.StartRead(clBlack,clWhite,'Numerico> ',clBlack,clWhite);

  //[final,columna] en matrices
  //[columna,fila] en StringGrid

  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,1]:='error'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,1]:='0.001'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,1]:='Double'; // [columnas,filas]
  FuncsAuxs.TablaDeVarsStrMatrix[0,0]:=TablaDeVarsStrGrid.Cells[0,1];
  FuncsAuxs.TablaDeVarsStrMatrix[0,1]:=TablaDeVarsStrGrid.Cells[1,1];
  FuncsAuxs.TablaDeVarsStrMatrix[0,2]:=TablaDeVarsStrGrid.Cells[2,1];

  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,2]:='decimales'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,2]:='0.2'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,2]:='Integer'; // [columnas,filas]
  FuncsAuxs.TablaDeVarsStrMatrix[1,0]:=TablaDeVarsStrGrid.Cells[0,2];
  FuncsAuxs.TablaDeVarsStrMatrix[1,1]:=TablaDeVarsStrGrid.Cells[1,2];
  FuncsAuxs.TablaDeVarsStrMatrix[1,2]:=TablaDeVarsStrGrid.Cells[2,2];

  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,3]:='ans'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,3]:=''; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,3]:=''; // [columnas,filas]
  FuncsAuxs.TablaDeVarsStrMatrix[2,0]:=TablaDeVarsStrGrid.Cells[0,3];
  FuncsAuxs.TablaDeVarsStrMatrix[2,1]:=TablaDeVarsStrGrid.Cells[1,3];
  FuncsAuxs.TablaDeVarsStrMatrix[2,2]:=TablaDeVarsStrGrid.Cells[2,3];

  //ShowMessage(IntToStr(TablaDeVarsStrGrid.RowCount)) = 4
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  MetodosSENL.Destroy;
end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
var
  iPos, i: Integer;
  StrList: TStringList;
  func, VariableName, VariableValue, respuesta: string;
begin
  CmdBox1.TextColors(clBlack,clWhite);//Color para el input en la consola
  StrList:= TStringList.Create;
  //Nota:Un string empieza con el indice 1

  Input := Trim(Input);
  Input := StringReplace(Input,' ',',',[rfReplaceAll, rfIgnoreCase]);//Cambia los espacios por las comas

  //Hay 3 casos
  //Una variable que se iguala a una funcion "string" como 'x^2' se tiene que verificar si ya existe o no
  //Una variable que se iguale a un numero
  //Una variable que se iguale un metodo y que el resultado se guarde en este y en el metodo se tiene que
  //verificar las variables si son imputs directos o son defrente
  if FuncsAuxs.ExisteIgualdad(Input) <> 0 then
  begin
    VariableName := Copy(Input,1,FuncsAuxs.ExisteIgualdad(Input)-1);
    if (FuncsAuxs.BuscarEnTabla(VariableName,TablaDeVarsStrGrid.RowCount)=True) then
    begin
      ShowMessage('se encontro la variable');
      VariableValue := Copy(Input,FuncsAuxs.ExisteIgualdad(Input)+1,Length(Input));
      ShowMessage(FuncsAuxs.QueTipoEs(VariableValue));
    end
    else
    ShowMessage('no se encontro la variable');
    VariableValue := Copy(Input,FuncsAuxs.ExisteIgualdad(Input)+1,Length(Input));
    ShowMessage(FuncsAuxs.QueTipoEs(VariableValue));
    Input := Copy(Input,FuncsAuxs.ExisteIgualdad(Input)+1,Length(Input));
  end;

  iPos:= Pos( '(', Input );
  func:= Trim( Copy( Input, 1, iPos - 1 ));
  StrList.Delimiter:=',' ;
  StrList.StrictDelimiter:= true;
  StrList.DelimitedText:= Copy( Input, iPos + 1, Length( Input ) - iPos - 1  );
  case func of
        'root' : begin
          //QuotedStr();
          CmdBox1.Writeln('Se detecto el comando : root');
          StrList[0]:= StringReplace(StrList[0],'''','',[rfReplaceAll, rfIgnoreCase]);//Borra las comillas de la funcion
          CmdBox1.Writeln('Funcion :'+StrList[0]);
          MetodosSENL.fx := StrList[0];//La funcion
          MetodosSENL.a := StrToFloat(StrList[1]);//Parametro a
          MetodosSENL.b := StrToFloat(StrList[2]);//Parametro b
          MetodosSENL.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1])       ;//Asignacion de la h
          CmdBox1.Writeln('numero de parametros en la funcion: '+IntToStr(StrList.Count));
          if(StrList.Count=3) then
          begin
            respuesta := MetodosSENL.Secante();
            CmdBox1.Writeln('La respuesta es: '+respuesta);
          end
          else
          begin
            CmdBox1.Writeln('Metodo :'+StrList[3]);
            CmdBox1.Writeln('Uno o Todos :'+StrList[4]); // ver como se hace luego
            case StrList[3] of //Numero del metodo
                  '0' :begin
                    respuesta := MetodosSENL.Biseccion();
                    CmdBox1.Writeln('Biseccion');
                    CmdBox1.Writeln('La respuesta es: '+respuesta);
                  end;
                  '1' :begin
                    respuesta := MetodosSENL.FalsaPosicion();
                    CmdBox1.Writeln('FalsaPosicion');
                    CmdBox1.Writeln('La respuesta es: '+respuesta);
                  end;
                  '2' :begin
                    respuesta := MetodosSENL.Secante();
                    CmdBox1.Writeln('Secante');
                    CmdBox1.Writeln('La respuesta es: '+respuesta);
                  end;
            end;
          end
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
  CmdBox1.StartRead(clBlack,clWhite,'Numerico>',clBlack,clWhite);
  HistoryList.Clear;
  for i:=0 to CmdBox1.HistoryCount-1 do HistoryList.Items.Add(CmdBox1.History[i]);
end;

procedure TForm1.ClearHistoryClick(Sender: TObject);
begin
  CmdBox1.ClearHistory;
  HistoryList.Clear;
end;

end.

