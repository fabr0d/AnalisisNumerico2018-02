program FinalProyectNA;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, tachartlazaruspkg, cmdbox, parseConsola, ParseMath, SENLClass,
  FuncionesAuxiliares, PolyrootClass, polynomialClass, NewtonGenClass, edoClass,
  integlasclass, matrix, frame_function;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

