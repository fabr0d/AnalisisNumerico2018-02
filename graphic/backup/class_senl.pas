unit class_senl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, math, ParseMath;

type
  TSENL = class
    IndexMethodType: Integer;
    Error, ErrorAllowed: Double;
    a, b: Double;
    MethodList, SequenceA, SequenceB, SequenceXn, SequenceN, SequenceError: TStringList;
    MethodFunction: String;
    Parse: TParseMath;

    function isBolzano(variableA: Double; variableB: Double): Boolean;
    function Execute(): Double;
    function getParseResult(x: Double): Double;
    function getFunctionResult(x: Double): Double;
    function BisectionMethod(): Double;

    public
      constructor Create;
      destructor Destroy; override;

  end;

implementation

const
  Top = 100000;

constructor TSENL.Create;
begin
   MethodList:=TStringList.Create;
   MethodList.AddObject( 'Bisección', TObject( 0 ) );
   SequenceN:= TStringList.Create;
   SequenceN.Add('n');
   SequenceA:= TStringList.Create;
   SequenceA.Add('A');
   SequenceB:= TStringList.Create;
   SequenceB.Add('B');
   SequenceXn:= TStringList.Create;
   SequenceXn.Add('Xn');
   SequenceError:= TStringList.Create;
   SequenceError.Add('Error');
   Error:= Top;

end;

destructor TSENL.Destroy;
begin
   SequenceN.Destroy;
   SequenceA.Destroy;
   SequenceB.Destroy;
   SequenceXn.Destroy;
   SequenceError.Destroy;
   MethodList.Destroy;
end;

function Power( b: Double; n: Integer ): Double;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;
end;

function TSENL.Execute(): Double;
begin
   case IndexMethodType of
        0: Result:= BisectionMethod();
   end;
end;

function TSENL.getFunctionResult(x: Double): Double;
begin
   //Insert Function Here
   Result:=(Power(x,2));
end;

function TSENL.getParseResult(x: Double): Double;
begin
   Parse.NewValue('x', x);
   Result:=Parse.Evaluate();
end;

function TSENL.isBolzano(variableA: Double; variableB: Double): Boolean;
begin
   if (getFunctionResult(variableA) * getFunctionResult(variableB) < 0) then
      Result:= True
   else
       Result:=False;
end;

function TSENL.BisectionMethod(): Double;
var xn: Real;
     n: Integer;

begin
   Result:= 0;
   n:= 1;

   //if (isBolzano(a,b) = False) then
   //   Result:=StrToFloat('Nan')
   //else
   //begin

   repeat
     xn:= Result;

     SequenceN.Add(IntToStr(n));
     SequenceA.Add(FloatToStr(a));
     SequenceB.Add(FloatToStr(b));

     Result:= (a+b)/2;

     ShowMessage('GG '+FloatToStr(Result));

     SequenceXn.Add(FloatToStr(Result));

     if (getFunctionResult(a)*getFunctionResult(Result)) < 0 then
        b:=Result
     else
        a:=Result;

     if n > 0 then
        Error:= abs( Result - xn );

     SequenceError.Add( FloatToStr( Error ) );

     n:= n + 1;

   until ( Error <= ErrorAllowed ) or ( n >= Top );

   //end;
end;

end.
