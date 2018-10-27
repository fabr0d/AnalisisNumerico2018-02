unit MetodosDeIntegracionClass;

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
  Parse.Expression:= fx; // parse de la funcion
  tam := n+1; // asignacion del tamaño del array que contendra los puntos
  Sumatoria := 0; //variable que guardara
  SetLength(puntos,tam);
  h :=(b-a)/n; //calculo de h
  //ShowMessage('h: '+FloatToStr(h));
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
  Result := FloatToStr( h * ((((f(puntos[0])+ f(puntos[tam-1]))/2))+Sumatoria));
end;

function FuncionesMetodosIntegracion.simpson34():String;
var
  h,SumatoriaPar,SumatoriaImpar : Real;
  i,j,k,tam : Integer;
  puntos: array of Real;
begin
  Parse.Expression:= fx; // parse de la funcion
  tam := 2*n+1; // asignacion del tamaño del array que contendra los puntos
  SumatoriaPar := 0; //variables que guardaran sumatoria de pares e impares
  SumatoriaImpar := 0;
  SetLength(puntos,tam);
  h :=(b-a)/(2*n); //calculo de h
  //ShowMessage('h: '+FloatToStr(h));
  puntos[0] := a;
  for i := 1 to tam-1 do
  begin
    puntos[i] := puntos[i-1]+h;
  end;
  //Sumatoria de los valores pares
  j := 1;
  while j*2 <= (tam-2) do
  begin
    SumatoriaPar := SumatoriaPar+f(puntos[j*2]);
    j := j+1;
  end;
  //Sumatoria de los valores impares
  k := 0;
  while (k*2)+1 <= (tam-2) do
  begin
    SumatoriaImpar := SumatoriaImpar+f(puntos[(k*2)+1]);
    k := k+1;
  end;
  Result := FloatToStr( (h/3)*( f(puntos[0])+ f(puntos[tam-1])+(SumatoriaPar*2)+(SumatoriaImpar*4)) );
end;

end.

