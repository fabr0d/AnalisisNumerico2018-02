unit FuncionesAuxiliares;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;
type
  StrMatrix = array of array of string;
  FuncionesAux = class
    TablaDeVarsStrMatrix: StrMatrix;
    function QueTipoEs(x: String): String;
    function ExisteIgualdad(y: String): Integer;
    function BuscarEnTabla(VarABuscar: String ; FilsDeStrGrid: Integer): Boolean;
    constructor create;
  end;

implementation

constructor FuncionesAux.create;
begin
  SetLength(TablaDeVarsStrMatrix,3,3);
end;

function FuncionesAux.QueTipoEs(x: String): String;
var
  temp: Double;
begin
  if ( TryStrToFloat(x,temp)) then
  begin
    ShowMessage('Es un numero');
    Result := 'Double';
  end
  else if (x[1]='[') and (x[x.Length]=']') then
  begin
    ShowMessage('Es una lista');
    Result := 'List';
  end
  else if (x[1]='''') and (x[x.Length]='''') then
  begin
    ShowMessage('Es una funcion matematica');
    Result := 'String';
  end;
  //Si es string
  //Puede ser una operacion de variables
  //Puede ser una funcion
  //puede ser una funcion matematica
  //Puede ser una lista
end;

function FuncionesAux.ExisteIgualdad(y: String): Integer;
begin
  if ( Pos('=',y) = 0 ) then
  begin
    //ShowMessage('No hay igual en el string');
    Result := 0;
  end
  else
  //ShowMessage('Se detecto caracter igual');
  Result := Pos('=',y);

end;

function FuncionesAux.BuscarEnTabla(VarABuscar: String ; FilsDeStrGrid: Integer):Boolean;
var
  i: Integer;
begin
  i:= 0;
  while (i<FilsDeStrGrid) do
  begin
    if( VarABuscar = TablaDeVarsStrMatrix[i,0] ) then
    begin
      //ShowMessage('Se encontro');
      Result := True; //True si lo contontro
      Break;
    end
    else
    i:=i+1;
    //ShowMessage('No se encontro');
    Result := False;//Else si no lo encontro
  end;
end;

end.

//TablaDeVarsStrMatrix[final,columna] en matrices

//dorman and prince
//resolver un sistema de ecuasiones diferenciables de primer orden con runge kutta
//Bajo 5 puntos en la permanente y en el final trabajo opcional: Ver le trabajo del profe aquise e implemetarlo
//con ejemplos
