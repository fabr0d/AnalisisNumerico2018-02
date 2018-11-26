unit polinomios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type
  TRoot = class
    x : Real;
  end;
  TPolis = class
    arrRoots : array of TRoot;
    tp: Integer;
    public
      constructor create(n:Integer);
      function getPolinomy():String;
  end;

implementation

constructor TPolis.create(n:Integer);
var
   i:Integer;
begin
     self.tp:=n;
     SetLength(arrRoots, n);
     for i:=0 to n-1 do
         arrRoots[i] := TRoot.create();
end;

function TPolis.getPolinomy(): String;
var
   i : Integer;
begin
     for i:=0 to tp-1 do begin
       Result := Result + '(x-(' + FloatToStr( arrRoots[i].x ) + '))';
       if i <> tp-1 then
       Result := Result + '*';
     end;

end;

end.

