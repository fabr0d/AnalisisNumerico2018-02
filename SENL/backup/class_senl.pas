unit class_methods;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath;

type
  CAMethods = class
    ErrorAllowed: Real;
    ValuesA,
    ValuesB,
    Sequence,
    NError,
    MethodList: TStringList;
    MethodType: Integer;
    a: Real;
    b: Real;
    xi: Real;
    fx: String;
    FunctionType: String;
    function f(x: Real): Real;
    function df(x: Real): Real;
    private
      Parse: TParseMath;
      function Bisection(): String;
      function FalsePosition(): String;
      function NewtonRaphson(): String;
      function Secant(): String;
      function FixedPoint(): String;
    public
      constructor create;
      destructor Destroy; override;

  end;

const
  IsBisection = 0;
  IsFalsePosition = 1;
  IsNewtonRaphson = 2;
  IsSecant = 3;
  IsFixedPoint = 4;

implementation

constructor CAMethods.create;
begin
  ValuesA:= TStringList.Create;
  ValuesB:= TStringList.Create;
  Sequence:= TStringList.Create;
  NError:= TStringList.Create;
  ValuesA.Add('');
  ValuesB.Add('');
  Sequence.Add('');
  NError.Add('');
  Parse:= TParseMath.create();
  Parse.AddVariable('x',0);
  Parse.Expression:= 'x';

end;

destructor CAMethods.Destroy;
begin
  ValuesA.Destroy;
  ValuesB.Destroy;
  Sequence.Destroy;
  NError.Destroy;
  MethodList.Destroy;
  Parse.destroy;
end;

function CAMethods.f(x: Real): Real;
begin
  Parse.NewValue('x',x);
  f:= Parse.Evaluate();
end;

function CAMethods.df(x: Real): Real;
var h: Real;
begin
  h:= 0.00000001;//lim
  df:= ((f(x+h)-f(x-h))/(2*h))
  //df:= str;
end;

function CAMethods.Bisection(): String;
var Error: Real;
    xn: Real;
begin
   Parse.Expression:= fx;
   xi:= Infinity;
   if f(a)*f(b) >= 0 then Result:= 'NoBolzano'
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

function CAMethods.FalsePosition(): string;
var Error: Real;
    xn: Real;
begin
   Parse.Expression:= fx;
   xi:= Infinity;
   if f(a)*f(b) >= 0 then Result:= 'NoBolzano'
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

function CAMethods.NewtonRaphson(): string;
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

function CAMethods.Secant(): string;
var Error: Real;
    xn: Real;
    h: Real;
begin
   Parse.Expression:= fx;
   h:= ErrorAllowed/10;
   xi:= a;
   repeat
     xn:= xi;
     xi:= xn - ((2*h*f(xn))/(f(xn+h)-f(xn-h)));
     Error:= abs(xi - xn) ;
     Sequence.Add(FloatToStr(xi));
     NError.Add(FloatToStr(Error));
   until (Error <= ErrorAllowed );
   NError.Delete(1);
   NError.Insert(1,'');
   Result:= FloatToStr(xi);
end;

function CAMethods.FixedPoint(): string;
var Error: Real;
    xn: Real;
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

