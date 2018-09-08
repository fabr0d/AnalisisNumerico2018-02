unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, classes2, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)

    Button1: TButton;
    ediF: TEdit;

    InsertA: TEdit;
    InsertB: TEdit;
    InsertError: TEdit;

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;

    lblIteracionse: TLabel;
    lblRoot: TLabel;
    lblError: TLabel;

    StringGrid1: TStringGrid;

    procedure Button1Click(Sender: TObject);
    //procedure Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure ediFChange(Sender: TObject);
    procedure ediFChange(Sender: TObject);
    //procedure ExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    Parse: TParseMath;
    function f( x: Real): Real;
    //procedure Plot(x: Real);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.f( x: Real): Real;
begin
   Parse.NewValue('x', x );
   Result:= Parse.Evaluate();
end;

procedure TForm1.Button1Click(Sender: TObject);
var Biseccion: TBiseccion;
    i: Integer;
begin
  Parse.Expression:= ediF.Text;
  Biseccion:= TBiseccion.create;
  with Biseccion do begin
       a:= StrToFloat( InsertA.Text );
       b:= StrToFloat( InsertB.Text );
       fx:= ediF.Text;
       Error:= StrToFloat( InsertError.Text );
       Execute;
       StringGrid1.RowCount:= xn.Count;
       StringGrid1.Cols[1].Assign( xn );
       StringGrid1.Cols[2].Assign( en );
       //Plot(x);
       //lblRoot.Caption:= FloatToStr( round( x / Error ) * Error );
       //lblIteracionse.Caption:= IntToStr( xn.Count );
  end;

  Biseccion.Destroy;
  for i:= 0 to StringGrid1.RowCount -1 do
     StringGrid1.Cells[ 0, i ]:= IntToStr( i+1 );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse:= TParseMath.create();
  Parse.AddVariable( 'x', 0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

end.

