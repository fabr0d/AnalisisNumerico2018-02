unit MetodosDeIntegracion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;

type
  FuncionesMetodosIntegracion = class
    MethodList: TStringList;
    MethodType: Integer;
    fx: String;
    a: Real;
    b: Real;
    n: Integer;  //numero de intervalos
    TipodeMetodo: Real;
    function f(x:Real): Real;
    function Execute(): String;
    private
      Parse: TParseMath;
      function trapecio(): String;
      function simpson34(): String;
    public
      constructor create;
      destructor Destroy; override;
  end;
  const
    EsTrapecio = 0;
    EsSimpson = 1;

implementation

constructor FuncionesMetodosIntegracion.create;
begin
  MethodList:= TStringList.Create;
  MethodList.AddObject('Trapecio',TObject(EsTrapecio));
  MethodList.AddObject('Simpson3/4',TObject(EsSimpson));
  Parse:=TParseMath.create();
  Parse.AddVariable('x',0);
  Parse.Expression:= 'x';
end;

destructor FuncionesMetodosIntegracion.Destroy;
begin
  MethodList.Destroy;
  Parse.destroy;
end;

function FuncionesMetodosIntegracion.Execute(): String;
begin
  case MethodType of
        EsTrapecio: Result:=trapecio();
        EsSimpson: Result:=simpson34();
  end;
end;

function FuncionesMetodosIntegracion.f(x: Real):Real;
begin
  Parse.NewValue('x',x);
  f:=Parse.Evaluate();
end;

function FuncionesMetodosIntegracion.trapecio():String;
var
  h,Sumatoria : Real;
  i,j,tam : Integer;
  puntos: array of Real;
begin
  Parse.Expression:= fx;
  tam := n+1;
  Sumatoria := 0;
  SetLength(puntos,tam);
  h :=(b-a)/n;
  ShowMessage(FloatToStr(h));
  puntos[0] := a;
  for i := 1 to tam-1 do
  begin
    puntos[i] := puntos[i-1]+h;
  end;
  //Sumatoria de los valores medios
  for j := 1 to tam-2 do
  begin
    Sumatoria := Sumatoria+f(puntos[j]);
  end;
  Result := FloatToStr( h * (( ( f(puntos[0]) + f(puntos[tam-1]) )/2) )+Sumatoria);
end;

function FuncionesMetodosIntegracion.simpson34():String;
begin

end;

end.

