program MetodoDelTrapecio;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, ParseMath, MetodosDeIntegracionClass
  { you can add units after this };

{$R *.res}

begin
  Application.Title := 'MetodosdeIntegracion-1';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

