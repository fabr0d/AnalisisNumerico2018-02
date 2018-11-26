unit SENLClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;

type
  SENLFunciones = class
  ErrorAllowed: Real;
  a: Real;
  b: Real;
  xi: Real;
  fx: String;
  ItersMax: Integer;
  Contador: Integer;
  function f(x: Real): Real;
  function df(x: Real): Real;
  //function Execute(): String;
  function Biseccion(): String;
  function FalsaPosicion(): String;
  function Secante(): String;
  public
      ParseRoot: TParseMath;
      constructor create;
      destructor Destroy; override;
  end;

implementation

constructor SENLFunciones.create;
begin
  ParseRoot:= TParseMath.create();
  ParseRoot.AddVariable('x',0);
end;

destructor SENLFunciones.Destroy;
begin
  ParseRoot.destroy;
end;

function SENLFunciones.f(x: Real): Real;
begin
  ParseRoot.NewValue('x',x);
  f:= ParseRoot.Evaluate();
end;

function SENLFunciones.df(x: Real): Real;
var h: Real;
begin
  h:= 0.00000001;
  df:= ((f(x+h)-f(x-h))/(2*h))
end;

function SENLFunciones.Biseccion(): string;
var Error: Real;
    xn: Real;
begin
   ParseRoot.Expression:= fx;
   //ShowMessage(FloatToStr(a));
   //ShowMessage(FloatToStr(b));
   //ShowMessage(fx);
   xi:= Infinity;
   if (f(a)*f(b)) >= 0 then //ShowMessage('NoCumpleBolzano')
   else
   begin
   repeat
     xn:= xi;
     xi:= (a + b) / 2;
     if f(xi) * f(a) < 0 then
        b:= xi
     else
        a:= xi;
     Error:= abs(xi - xn) ;
   until (Error <= ErrorAllowed );
   Result:= FloatToStr(xi);
   end;
end;

function SENLFunciones.FalsaPosicion(): string;
var Error: Real;
    xn: Real;
begin
   Parse.Expression:= fx;
   xi:= Infinity;
   if f(a)*f(b) >= 0 then
      begin
        //ShowMessage('NoCumpleBolzano');
      end
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
       until (Error <= ErrorAllowed );
       Result:= FloatToStr(xi);
     end;
end;

function SENLFunciones.Secante(): string;
var Error: Real;
    xn: Real;
    h: Real;
begin
   ItersMax:=100000;
   Contador:=0;
   Parse.Expression:= fx;
   h:= ErrorAllowed/10;
   xi:= (a+b)/2;
   repeat
     xn:= xi;
     xi:= xn - ((2*h*f(xn))/(f(xn+h)-f(xn-h)));
     Error:= abs(xi - xn) ;
     Contador:=Contador+1;
     if Contador>=ItersMax then
     begin
        Break;
     end;
     //ShowMessage(FloatToStr(Error)+' <= '+FloatToStr(ErrorAllowed));
   until (Error <= ErrorAllowed );
   Result:= FloatToStr(xi);
end;

end.

