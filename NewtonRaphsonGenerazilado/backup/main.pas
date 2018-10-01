unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonRunAll: TButton;
    ButtonMandaVar: TButton;
    ButtonMandaFunc: TButton;
    ButtonDefNumDeFuncyVars: TButton;
    ComboBoxSelecVar: TComboBox;
    ComboBoxNumFunc: TComboBox;
    EditError: TEdit;
    EditXsubCero: TEdit;
    EditNumDeFuncs: TEdit;
    EditVarsUsadas: TEdit;
    EditFuncX: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

