unit PolyrootClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, ParseMath, Dialogs;
type
  TPolyroot=class
    points: array of string;
    tam: Integer;
    public
      constructor create(n:Integer);
      function getPolinomy():String;
  end;

implementation

constructor TPolyroot.create(n:Integer);
begin
  tam:=n;
  SetLength(points, n);
end;

function TPolyroot.getPolinomy(): String;
var
   i : Integer;
begin
  for i:=0 to tam-1 do
  begin
       Result:='';
       Result := Result+'(x-('+points[i]+'))';
       if i <> tam-1 then
       Result := Result + '*';
  end;
  ShowMessage(Result);
  Result:=''''+Result+'''';
end;

end.

