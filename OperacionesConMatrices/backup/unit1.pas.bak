unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, CheckLst, ValEdit, ColorBox, mMatrix;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    { private declarations }
    function readMatrix(Grid: TStringGrid): t_matrix;

  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  m1, m2, res: t_matrix;
  deter: Double;
  i,j, rows1,cols1, rows2, cols2: Integer;
  calculator: TMatrix;
  escalar: Double;
  expo: Integer;
begin
  StringGrid3.Clear;
  //StringGrid1.RowCount:=StrToInt(Edit1.Text);
  //StringGrid1.ColCount:=StrToInt(Edit2.Text);
  //StringGrid2.RowCount:=StrToInt(Edit3.Text);
  //StringGrid2.ColCount:=StrToInt(Edit4.Text);

  m1 := readMatrix(StringGrid1);

  //For matrix operations we only need rows of StringGrid1
  //                               and cols of StringGrid2
  rows1 := StringGrid1.RowCount;
  cols1 := StringGrid1.ColCount;
  cols2 := StringGrid2.ColCount;
  rows2 := StringGrid2.RowCount;

  calculator := TMatrix.Create;
  if RadioButton1.Checked then
  begin
     StringGrid3.RowCount:=rows1;
     StringGrid3.RowCount:=cols2;
     m2 := readMatrix(StringGrid2);
     res := calculator.add(m1,m2);
  end;

  if RadioButton2.Checked then
  begin
     StringGrid3.RowCount:=rows1;
     StringGrid3.RowCount:=cols2;
     m2 := readMatrix(StringGrid2);
     res := calculator.subtract(m1,m2);
  end;

  if RadioButton3.Checked then
  begin
     if( cols1 = rows2) then
     begin
       StringGrid3.RowCount:=rows1;
       StringGrid3.ColCount:=cols2;
       m2 := readMatrix(StringGrid2);
       res := calculator.multiply(m1,m2);
     end
     else
         ShowMessage('No se puede multiplicar,Columnas A != Filas B');
  end;
  if RadioButton4.Checked then
  begin
     deter:= calculator.det(m1);
     if( deter = 0) then //verificamos que determinante != 0
     begin
         ShowMessage('Matriz no invertible, Determinante 0');
         exit;
     end
     else
     begin
       if (cols1 <> rows1) then
       begin
         ShowMessage('Matriz no cuadrada!');
         exit;
       end
       else
       begin
           cols2 := StringGrid1.ColCount;
           StringGrid3.RowCount:= rows1;
           StringGrid3.ColCount:= cols1;
           res := calculator.inverse(m1);
       end;
     end;
  end;

  if RadioButton5.Checked then
  begin
    if (cols1 <> rows1) then begin
         ShowMessage('Matriz no cuadrada!');
         exit;
    end
    else
    begin
     cols2 := StringGrid1.ColCount;
     deter := calculator.det(m1);
     ShowMessage('Determinante es: '+FloatToStr(deter));
    end;
  end;

  if RadioButton6.Checked then
  begin
    StringGrid3.ColCount:= rows1;
    StringGrid3.RowCount:= cols1;
    res := calculator.transposed(m1);
    //Memo1.Lines.add('finished transpose');
  end;

  if RadioButton7.Checked then
  begin
    //Memo1.Lines.add('init 7');
    StringGrid3.ColCount:= cols1;
    StringGrid3.RowCount:= rows1;
    escalar:= StrToFloat( Edit5.Text );
    res := calculator.multiplyByNumber(m1,escalar);
    //Memo1.Lines.add('finish 7');
  end;
  if RadioButton8.Checked then
  begin
    if cols1 <> rows1 then
    begin
      ShowMessage('Matriz no cuadrada');
      exit;
    end;
    StringGrid3.ColCount:= cols1;
    StringGrid3.RowCount:= rows1;
    expo := trunc( StrToFloat( Edit5.Text ) );
    res := calculator.powerMatrix(m1,expo);

  end;

  if (not RadioButton5.Checked ) then
  begin
     //Memo1.Lines.add('init filling matrix result');
     // Fill StringGrid3 with matrix res
     //Memo1.Lines.add('filling grid result ['+ IntToStr(Length(res))+' , '+ IntToStr(Length(res[0])));
     //Memo1.Lines.add('filling grid result ['+ IntToStr(StringGrid3.RowCount)+' , '+ IntToStr(StringGrid3.ColCount));
     for i:= 0 to Length(res)-1 do
         for j:=0 to Length(res[0])-1 do
             StringGrid3.Cells[j,i] := FloatToStr(res[i,j]);
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  StringGrid1.RowCount:=StrToInt(Edit1.Text);
  StringGrid1.ColCount:=StrToInt(Edit2.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StringGrid2.RowCount:=StrToInt(Edit3.Text);
  StringGrid2.ColCount:=StrToInt(Edit4.Text);
end;


function TForm1.readMatrix(Grid: TStringGrid): t_matrix;
var
  cols, rows: Integer;
  i,j : Integer;
begin
  cols := Grid.ColCount;
  rows := Grid.RowCount;
  //SetLength(Result,cols, rows);
  SetLength(Result,rows, cols);

  for i:=0 to rows-1 do
  begin
    for j:=0 to cols-1 do
        Result[i,j] := StrToFloat(Grid.Cells[j,i]);
  end;
end;

end.

