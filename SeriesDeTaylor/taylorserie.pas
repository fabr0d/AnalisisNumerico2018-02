unit TaylorSerie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, strutils, math, mResult;

type
    TStringMatrix = array of array of string;

type
    TFunctionTaylor = function(x: double; e: double): TResult;

type
  TTaylorSerie = class
    private
      serie: TStringList;

      //function factorial(a: Integer): Integer;
    public
      constructor create();
      function factorial(a: Integer): Int64;
      function exp(x: Double; errorI: Double): TResult;
      function sin(x: Double; e: Double): TResult;
      function cos(x: Double; e: Double): TResult;
      function ln(x: Double; e: Double): TResult;
      function arctanh(x: Double; e: Double): TResult;
      function sinh(x: Double; e: Double): TResult;

      function radToGrad(x: Double): double;
      function getPresicion(error: Double): Integer;
      function getZerosStr(precision: Integer): string;
      function getSign(grades: double): Integer;
  end;

implementation

constructor TTaylorSerie.create();
begin
end;

function TTaylorSerie.factorial(a: Integer): Int64;
var
  i: Integer;
  res: Integer;
begin
  if( a=0) then
      Result := 1
  else
  begin
    if a<3 then
       Result:=a
    else
    begin
      res:=2;
      for i:=3 to a do
          res := res*i;
      Result:= res;
    end;
  end;
end;

//function TTaylorExpo.taylorexpo(x:Double ;errorI : Double):real;

function TTaylorSerie.exp(x: Double; errorI: Double): TResult;
var
  errorO: double;
    sum:Double;
    error1: Double;
    i:Integer;
    res : Array of array of string;
begin
     errorO:=50;
     sum:=1;
     //writeln('    |       Resultado       |     Err. Absol.       |    Err. Relativo   |      Err. Porcent.    |');
     //writeln('X0  |  ',sum,'  |       -       |       -       |       -       |');
     i:=1;
     error1:=sum;

     SetLength(res,1,3);
     res[0,0] := IntToStr(i);
     res[0,1] := FloatToStr(sum);
     res[0,2] := '-';

     while(errorO>errorI) do
     begin
          sum := sum + (power(x,i)/factorial(i));
          //errorO:=Eabsoluto(error1,sum);
          errorO := abs(sum-error1);
          //writeln('X',i,'  |  ',sum,'  |  ' ,(errorO):0:3 ,'   |   ',ERelativo(errorO,error1):0:2,'  |  ',(errorO/error1*100):0:2,'  |');
          error1:=sum;
          i:=i+1;

          SetLength(res,i,3);
          res[i-1,0] := IntToStr(i);
          res[i-1,1] := FloatToStr(sum);
          res[i-1,2] := FloatToStr(errorO);
     end;
     //taylorexpo:=sum;
     //Result.result:= FloatToStr(sum);
     Result.result:= FormatFloat(getZerosStr(getPresicion(errorI)),sum);
     Result.matrix := res;
end;

{*
function TTaylorSerie.exp(x: Double; e: Double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
begin
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);

  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := power(x,k)/factorial(k);
  res := res + xn;
  SetLength(resMatrix,1,3);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  //resMatrix[0,3] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := power(x,k)/factorial(k);
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,3);
    resMatrix[k,0] := IntToStr(k);
    resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,2] := FloatToStr(eAbs);
    //resMatrix[k,3] := FloatToStr(abs((res - xn_1)/res));
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  //Result.result := FloatToStr( sign*res );
  Result.result := FormatFloat( ePrecisionStr, res);
  Result.matrix := resMatrix;
end;
*}
function TTaylorSerie.sin(x: double; e: double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
  sign: Integer; // it only will take values +1 or -1
begin
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);
  sign:=getSign(x);

  x := trunc(x) mod (180);
  x := radToGrad(x);
  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := ( power(-1,k)/factorial(2*k+1)) * power(x,2*k+1);
  res := res + xn;
  SetLength(resMatrix,1,3);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := ( power(-1,k)/factorial(2*k+1)) * power(x,2*k+1);
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,3);
    resMatrix[k,0] := IntToStr(k);
    //resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,1] := FloatToStr(sign*res);
    resMatrix[k,2] := FloatToStr(eAbs);
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  //Result.result := FloatToStr(sign*res);
  Result.result := FormatFloat( ePrecisionStr, sign*res);
  Result.matrix := resMatrix;
end;

function TTaylorSerie.cos(x: Double; e: Double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
  sign: Integer; // it only will take values +1 or -1
begin
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);
  sign:=getSign(x);

  x := trunc(x) mod (180);
  x := radToGrad(x);
  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := ( power(-1,k)/factorial(2*k)) * power(x,2*k);
  res := res + xn;
  SetLength(resMatrix,1,4);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  resMatrix[0,3] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := ( power(-1,k)/factorial(2*k)) * power(x,2*k);
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,4);
    resMatrix[k,0] := IntToStr(k);
    //resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,1] := FloatToStr(sign*res);
    resMatrix[k,2] := FloatToStr(eAbs);
    resMatrix[k,3] := FloatToStr(abs((res - xn_1)/res));
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  //Result.result := FloatToStr( sign*res );
  Result.result := FormatFloat( ePrecisionStr, sign*res);
  Result.matrix := resMatrix;
end;

function TTaylorSerie.ln(x: Double; e: Double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
  sign: Integer; // it only will take values +1 or -1
begin
  if (x <= 0) then
  begin
       Result.result:= 'NoDef'; // No cumple con el dominio
       exit;
  end;

  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);
  //sign:=getSign(x);

  //x := trunc(x) mod (180);
  //x := radToGrad(x);
  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := ( 1/(2*k+1)*( power( (power(x,2)-1)/(power(x,2)+1) ,2*k+1)) );
  res := res + xn;
  SetLength(resMatrix,1,4);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := ( 1/(2*k+1)*( power( (power(x,2)-1)/(power(x,2)+1) ,2*k+1)) );
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,4);
    resMatrix[k,0] := IntToStr(k);
    resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,2] := FloatToStr(eAbs);
    resMatrix[k,3] := FloatToStr(abs((res - xn_1)/res));
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  //Result.result := FloatToStr( sign*res );
  Result.result := FormatFloat( ePrecisionStr, res);
  Result.matrix := resMatrix;
end;

function TTaylorSerie.arctanh(x: Double; e: Double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
  sign: Integer; // it only will take values +1 or -1
begin
  if ( abs(x) >= 1) then
  begin
    Result.result:='NoDef'; // no cumple con dominio
    exit;
  end;
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);
  //sign:=getSign(x);

  //x := trunc(x) mod (180);
  //x := radToGrad(x);
  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := ( power(x,2*k+1)/(2*k+1) );
  res := res + xn;
  SetLength(resMatrix,1,4);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  resMatrix[0,3] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := ( power(x,2*k+1)/(2*k+1) );
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,4);
    resMatrix[k,0] := IntToStr(k);
    //resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,2] := FloatToStr(eAbs);
    resMatrix[k,3] := FloatToStr(abs((res - xn_1)/res));
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  //Result.result := FloatToStr( sign*res );
  Result.result := FormatFloat( ePrecisionStr, res);
  Result.matrix := resMatrix;
end;

function TTaylorSerie.sinh(x: Double; e: Double): TResult;
var
  eAbs, res, xn, xn_1: Double;
  k: Integer;
  resMatrix : TStringMatrix;
  digits: Integer; // digits of precision
  ePrecisionStr: string;
  eStr: string;
begin
  digits:= getPresicion(e) ;
  ePrecisionStr:= getZerosStr(digits);

  eAbs := 100000000;
  k:= 0;
  res := 0;
  xn := (power(x,2*k+1)/factorial(2*k+1));
  res := res + xn;
  SetLength(resMatrix,1,3);
  resMatrix[0,0] := '0';
  resMatrix[0,1] := FloatToStr(res);
  resMatrix[0,2] := '-';
  //resMatrix[0,3] := '-';
  k := k+1;
  while( e <= eAbs) do
  begin
    xn_1 := res;
    xn := (power(x,2*k+1)/factorial(2*k+1));
    res := res + xn;
    eAbs := abs(res - xn_1);

    // Filling matrix with data
    SetLength(resMatrix,k+1,3);
    resMatrix[k,0] := IntToStr(k);
    resMatrix[k,1] := FloatToStr(res);
    resMatrix[k,2] := FloatToStr(eAbs);
    //resMatrix[k,3] := FloatToStr(abs((res - xn_1)/res));
    k := k+1;

    //eAbs := StrToFloat( FormatFloat(getZerosStr(digits),eAbs) );
  end;
  //Result.result := FloatToStr( 1000 );
  Result.result := FormatFloat( ePrecisionStr, res);
  Result.matrix := resMatrix;
end;

////
function TTaylorSerie.radToGrad(x: double): double;
begin
  Result:= x*pi/180;
end;

function TTaylorSerie.getPresicion(error: Double): Integer;
var
  digits: Integer;
  eString: string;
begin
     eString:= FloatToStr(error);
     //AnsiPos('.',eString);
     Result := AnsiPos('1',eString)-AnsiPos('.',eString)-1;
end;

//DupeString function needs srtutils library
function TTaylorSerie.getZerosStr(precision: Integer): string;
begin
  Result := DupeString('0',precision);
  Result := '0.'+Result;
end;

function TTaylorSerie.getSign(grades: double): Integer;
begin
  grades := trunc(grades) mod (360);
  if ( grades < 180 ) then
     Result:= 1
  else
      Result := -1;
end;

end.

