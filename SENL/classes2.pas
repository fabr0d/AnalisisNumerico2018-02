unit classes2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath;

type
  TBiseccion = class
      a,
      b,
      Error,
      x: real;
      fx: string;
      function Execute: Boolean;

    private
      Parse: TParseMath;
      function f( xx: real): Real;
    public
      xn,
      en: TStringList;
      constructor create;
      destructor Destroy; override;
  end;

implementation

function TBiseccion.f( xx: real): Real;
begin
   //Result:= xx*xx - 4;
   Parse.NewValue( 'x', xx);
   Result:= Parse.Evaluate();
end;

function TBiseccion.Execute: Boolean;
var NewError: Real;
    xnn: Real;
begin
   Parse.Expression:= fx;
   x:= Infinity;
   repeat
     xnn:= x;
     x:= (a + b) / 2;
     if f(x) * f(a) < 0 then
        b:= x
     else
        a:=x;
     NewError:= abs(  x - xnn) ;
     xn.Add( FloatToStr(x) );
     en.Add( FloatToStr( NewError ) );
   until (NewError <= Error );
   en.Delete( 0 );
   en.Insert(0, '');
   Result:= true;
end;

constructor TBiseccion.create;
begin
  xn:= TStringList.Create;
  en:= TStringList.Create;
  Parse:= TParseMath.create();
  Parse.AddVariable( 'x', 0);
  Parse.Expression:= 'x';
end;

destructor TBiseccion.Destroy;
begin
  xn.Destroy;
  en.Destroy;
  Parse.destroy;
end;

end.

