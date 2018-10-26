unit SENL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;

type
    SENLFunciones = class
    ErrorAllowed: Real;
    ValuesA, ValuesB, Sequence, NError, MethodList: TStringList;
    MethodType: Integer;
    a: Real;
    b: Real;
    xi: Real;
    fx: String;
    FunctionType: String;
    function f(x: Real): Real;
    function df(x: Real): Real;
    function Execute(): String;
    private
      Parse: TParseMath;
      function Biseccion(): String;
      function FalsaPosicion(): String;
      function Newton(): String;
      function Secante(): String;
      function PuntoFijo(): String;
    public
      constructor create;
      destructor Destroy; override;

  end;

const
  EsBiseccion = 0;
  EsFalsaPosicion = 1;
  EsNewton = 2;
  EsSecante = 3;
  EsPuntoFijo = 4;

implementation

constructor SENLFunciones.create;
begin
  ValuesA:= TStringList.Create;
  ValuesB:= TStringList.Create;
  Sequence:= TStringList.Create;
  NError:= TStringList.Create;
  MethodList:= TStringList.Create;
  MethodList.AddObject('Biseccion',TObject(EsBiseccion));
  MethodList.AddObject('FalsePosition',TObject(EsFalsaPosicion));
  MethodList.AddObject('Newton',TObject(EsNewton));
  MethodList.AddObject('Secante',TObject(EsSecante));
  MethodList.AddObject('PuntoFijo',TObject(EsPuntoFijo));
  ValuesA.Add('');
  ValuesB.Add('');
  Sequence.Add('');
  NError.Add('');
  Parse:= TParseMath.create();
  Parse.AddVariable('x',0);
  Parse.Expression:= 'x';

end;

destructor SENLFunciones.Destroy;
begin
  ValuesA.Destroy;
  ValuesB.Destroy;
  Sequence.Destroy;
  NError.Destroy;
  MethodList.Destroy;
  Parse.destroy;
end;

function SENLFunciones.Execute(): String;
begin
  case MethodType of
       EsBiseccion: Result:= Biseccion();
       EsFalsaPosicion: Result:= FalsaPosicion();
       EsNewton: Result:= Newton();
       EsSecante: Result:= Secante();
       EsPuntoFijo: Result:= PuntoFijo();
  end;
end;

function SENLFunciones.f(x: Real): Real;
begin
  Parse.NewValue('x',x);
  f:= Parse.Evaluate();
end;

function SENLFunciones.df(x: Real): Real;
var h: Real;
begin
  h:= 0.00000001;
  df:= ((f(x+h)-f(x-h))/(2*h))
end;

function SENLFunciones.Biseccion(): String;
var Error: Real;
    xn: Real;
begin
   Parse.Expression:= fx;
   xi:= Infinity;
   if f(a)*f(b) >= 0 then ShowMessage('no cumple')
   else
   begin
   repeat
     ValuesA.Add(FloatToStr(a));
     ValuesB.Add(FloatToStr(b));
     xn:= xi;
     xi:= (a + b) / 2;
     if f(xi) * f(a) < 0 then
        b:= xi
     else
        a:= xi;
     Error:= abs(xi - xn) ;
     Sequence.Add(FloatToStr(xi));
     NError.Add(FloatToStr(Error));
   until (Error <= ErrorAllowed );
   NError.Delete(1);
   NError.Insert(1,'');
   Result:= FloatToStr(xi);
   end;
end;

function SENLFunciones.FalsaPosicion(): string;
var Error: Real;
    xn: Real;
begin
   Parse.Expression:= fx;
   xi:= Infinity;
   if f(a)*f(b) >= 0 then Result:= 'NoCumpleBolzano'
   else
     begin
       repeat
         xn:= xi;
         xi:= a - (f(a)*((b-a)/(f(b)-f(a))));
         if f(xi) * f(a) < 0 then
            b:= xi
         else
            a:= xi;
         Error:= abs(xi - xn) ;
         Sequence.Add(FloatToStr(xi));
         NError.Add(FloatToStr(Error));
       until (Error <= ErrorAllowed );
       NError.Delete(1);
       NError.Insert(1,'');
       Result:= FloatToStr(xi);
     end;
end;

function SENLFunciones.Newton(): string;
var Error: Real;
    xn: Real;
begin
   Parse.Expression:= fx;
   xi:= a;
   repeat
     xn:= xi;
     xi:= xn - (f(xn)/df(xn));
     Error:= abs(xi - xn) ;
     Sequence.Add(FloatToStr(xi));
     NError.Add(FloatToStr(Error));
   until (Error <= ErrorAllowed );
   NError.Delete(1);
   NError.Insert(1,'');
   Result:= FloatToStr(xi);
end;

function SENLFunciones.Secante(): string;
var Error: Real;
    xn: Real;
    h: Real;
    Error2: Real;
begin
   Parse.Expression:= fx;
   h:= ErrorAllowed/10;
   xi:= a;
   repeat
     xn:= xi;
     //ShowMessage(FloatToStr(xn));
     xi:= xn - ((2*h*f(xn))/(f(xn+h)-f(xn-h)));
     Error:= abs(xi - xn) ;
     ShowMessage(FloatToStr(Error));
     Sequence.Add(FloatToStr(xi));
     NError.Add(FloatToStr(Error));
   until (Error <= ErrorAllowed );
   NError.Delete(1);
   NError.Insert(1,'');
   Result:= FloatToStr(xi);
end;

function SENLFunciones.PuntoFijo(): string;
var Error: Real;
    xn: Real;
    Error2: Real;
begin
   Parse.Expression:= fx;
   xi:= a;
   repeat
     xn:= xi;
     xi:= f(xn) + xn;
     Error:= abs(xi - xn) ;
     Sequence.Add(FloatToStr(xi));
     NError.Add(FloatToStr(Error));
   until (Error <= ErrorAllowed );
   NError.Delete(1);
   NError.Insert(1,'');
   Result:= FloatToStr(xi);
end;

end.
