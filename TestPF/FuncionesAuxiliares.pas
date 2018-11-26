unit FuncionesAuxiliares;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;
type
  TablaDeVars = array of array of string;
  FuncionesAux = class
    VariableLocales: TablaDeVars;
    function EsNumero(x: String; temp: Real): Boolean;
    function ExisteIgualdad(y: String): Integer;
    function BuscarEnTabla(z: TablaDeVars; NombreDeVarABuscar: string): Real;
    constructor create;
  end;

implementation

constructor FuncionesAux.create;
begin
  SetLength(VariableLocales,1,3);
end;

function FuncionesAux.EsNumero(x: String; temp: Real): Boolean;
begin
  if ( TryStrToFloat(x,temp)=false ) then
  begin
    ShowMessage('Es una variable');
    Result := false;
  end
  else
  ShowMessage('Es un numero');
  Result := true;
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

function FuncionesAux.BuscarEnTabla(z:TablaDeVars; NombreDeVarABuscar: string):Real;
begin

end;

end.

//dorman and prince
//resolver un sistema de ecuasiones diferenciables de primer orden con runge kutta
//Bajo 5 puntos en la permanente y en el final trabajo opcional: Ver le trabajo del profe aquise e implemetarlo
//con ejemplos
