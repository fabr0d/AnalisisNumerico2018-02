unit class_taylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TTaylor = class
     x: Real;
     function seno(): Real;
     function cose(): Real;
     function exp(): Real;
     function ln(): Double;
     function arctan(): Real;
     function arcsen(): Real;
     private

     public
        Error: Real;
        constructor create();
        destructor Destroy; override;
  end;

implementation

function Potencia( y: Real; n: Integer ): Real;
var i: Integer;
begin
    Result:= 1;
    for i:= 1 to n do
        Result:= Result * y;
end;

function factorial( n: Integer ): LongInt;
begin
   case n of
        0, 1: Result:= 1;
        else Result:= n * factorial( n - 1 );
   end;
end;

constructor TTaylor.create();
begin
   Error:= 0.1;
   x:= 0;
end;

destructor TTaylor.Destroy;
begin
  //
end;

function TTaylor.seno(): Real;
var n: Integer = 0;
    NewError,
    xn, xnn: Real;
begin
   Result:= 0;
   xn:= 10000000;
   repeat
     xnn:= xn;
     Result:= Result + ( Potencia( -1, n )/ factorial( 2*n + 1)) * Potencia( x, 2*n + 1 );
     xn:= Result;
     NewError:= abs( xn - xnn );
     n:= n + 1;
   until ( ( NewError <= Error ) or ( n > 6 ) );
end;

function TTaylor.cose(): Real;
var n: Integer = 0;
    NewError,
    xn, xnn: Real;
begin
   Result:= 0;
   xn:= 10000000;
   repeat
     xnn:= xn;
     Result:= Result + ( Potencia( -1, n )/ factorial( 2*n)) * Potencia( x, 2*n );
     xn:= Result;
     NewError:= abs( xn - xnn );
     n:= n + 1;
   until ( ( NewError <= Error ) or ( n > 6 ) );
end;

function TTaylor.exp(): Real;
var n: Integer = 0;
    NewError,
    xn, xnn: Real;
begin
   Result:= 0;
   xn:= 10000000;
   repeat
     xnn:= xn;
     Result:= Result + ( Potencia( x, n )/ factorial( n ));
     xn:= Result;
     NewError:= abs( xn - xnn );
     n:= n + 1;
   until ( ( NewError <= Error ) or ( n > 6 ) );
end;

function TTaylor.ln(): Double;
var n: Integer = 0;
    NewError,
    xn, xnn: Real;
begin
   Result:= 0;
   xn:= 10000000;
   repeat
     xnn:= xn;
     Result:= Result + (1/2*n+1)*Power(2*n+1,(x-1)/(x+1));
     xn:= 2*Result;
     NewError:= abs( xn - xnn );
     n:= n + 1;
   until ( ( NewError <= Error ) or ( n > 6 ) );
end;

function TTaylor.arcsen(): Real;
var n: Integer = 0;
    NewError,
    xn, xnn: Real;
begin
   Result:= 0;
   xn:= 10000000;
   repeat
     xnn:= xn;
     Result:= Result + (factorial(2*n)/Power(4,n)*Power(factorial(n),2)*(2*n+1))*Power(x,2*n+1);
     xn:= 2*Result;
     NewError:= abs( xn - xnn );
     n:= n + 1;
   until ( ( NewError <= Error ) or ( n > 6 ) );
end;

function TTaylor.arctan(): Real;
var n: Integer = 0;
    NewError,
    xn, xnn: Real;
begin
   Result:= 0;
   xn:= 10000000;
   repeat
     xnn:= xn;
     Result:= Result + (Power(-1,n)/(2*n+1))*Power(x,2*n+1);
     xn:= 2*Result;
     NewError:= abs( xn - xnn );
     n:= n + 1;
   until ( ( NewError <= Error ) or ( n > 6 ) );
end;

end.

