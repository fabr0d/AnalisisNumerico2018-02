unit classes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TBiseccion = class
    function general(x:Real): Real;
    function bolzano(): Real;
    function xn() :Real;
    function bisec() :Real;

    private

    public
      iter: Real;
      a: Real;
      b: Real;
      Error: Real;
      constructor create();
      destructor Destroy ; override;
  end;

implementation

constructor TBiseccion.create();
begin
  iter:= 0;
end;

destructor TBiseccion.Destroy;
begin
  //
end;

function TBiseccion.general(x:Real):Real;
begin
  Result:=Power(x,2)-sin(x)+8-x;
end;

function TBiseccion.bolzano():Real;
begin
  Result:=general(a)*general(b);
end;

function TBiseccion.xn():Real;
begin
  Result:=(a+b)/2;
end;

function TBiseccion.

end.

