unit FuncionesAuxiliares;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;
type
  FuncionesAux = class
    function ExisteIgualdad(y: String): Integer;
    function QueTipoEs(x: String): String;
  end;

implementation

function FuncionesAux.QueTipoEs(x: String): String;
var
  iPos: Integer;
  temp: Double;
  func: String;
begin
  if ( TryStrToFloat(x,temp)) then
  begin
    //ShowMessage('Es un numero');
    Result := 'Double';
  end
  else if (x[1]='[') and (x[x.Length]=']') then
  begin
    //ShowMessage('Es una lista');
    Result := 'List';
  end
  else if (x[1]='''') and (x[x.Length]='''') then
  begin
    //ShowMessage('Es una funcion matematica');
    Result := 'String';
  end
  else
  iPos:= Pos( '(', x );
  func:= Trim( Copy( x, 1, iPos - 1 ));
  if (func='root') or (func='polyroot') or (func='polynomial') or (func='eval') or (func='senl') or (func='edo') or
  (func='integral') or (func='area') or (func='plot2d') or (func='intersection') or (func='exit') or (func='clearplot') or (func=chartRange) then
  begin
    //ShowMessage('Es una funcion de la app');
    Result := 'Func';
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

end.

//dorman and prince
//resolver un sistema de ecuasiones diferenciables de primer orden con runge kutta
//Bajo 5 puntos en la permanente y en el final trabajo opcional: Ver le trabajo del profe aquise e implemetarlo
//con ejemplos
