unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  class_taylor;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnExecute: TButton;
    ediX: TEdit;
    ediError: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    memResult: TMemo;
    procedure btnExecuteClick(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnExecuteClick(Sender: TObject);
var Taylor: TTaylor;
begin
   Taylor:= TTaylor.Create;
  Taylor.Error:= StrToFloat( ediError.Text );
  Taylor.x:= StrToFloat( ediX.Text );
  memResult.Lines.Add( 'Sen(' + ediX.Text + ') = ' + FloatToStr( Taylor.seno() ) );
  Taylor.Destroy;

end;



end.

