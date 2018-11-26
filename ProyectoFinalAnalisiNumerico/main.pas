unit main;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools,
  uCmdBox, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids, Menus, StdCtrls,
  SENLClass, ParseMath, FuncionesAuxiliares, math, PolyrootClass,
  polynomialClass, NewtonGenClass, matrix, edoClass, integlasclass,
  frame_function, Types, TAChartUtils, TAStyles;
type
  { TForm1 }
  TForm1 = class(TForm)
    Chart1AreaSeries1: TAreaSeries;
    Chart1LineSeriesToClickIntesec: TLineSeries;
    Chart1LineSeriesToArea: TLineSeries;
    Chart1LineSeriesToIntegral: TLineSeries;
    Chart1LineSeriesToIntersection: TLineSeries;
    Chart1LineSeriesToEDO: TLineSeries;
    Chart1LineSeriesToRoot: TLineSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ChartToolset1PanDragTool1: TPanDragTool;
    ChartToolset1ZoomClickTool1: TZoomClickTool;
    ClearHistory: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    CmdBox1: TCmdBox;
    HistoryList: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    TablaDeVarsStrGrid: TStringGrid;

    LineSeries3: TLineSeries;
    AreaSeries3: TAreaSeries;
    Styles3: TChartStyles;
    procedure CreateErrorSeries(var DataSeries: TLineSeries;
                                var ErrorSeries: TAreaSeries;
                                var AStyles: TChartStyles;
                                AColor: TColor; ATitle: String);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool; APoint: TPoint);
    procedure ClearHistoryClick(Sender: TObject);
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
  private
    GraphicFrame: Array of TFrameFunction;
    SENLObject: SENLFunciones;
    SENLObjectTemporal: SENLFunciones;
    Parse1: TParseMath;
    FuncsAuxs: FuncionesAux;
    PolyrootObjt: TPolyroot;
    PolynomialObjt: TInterpolation;
    NewtonGenObjet: TNewtonGen;
    EdoObject: TMethodsDif;
    IntegralObjct: TMethodIntegral;

    fx1,fx2: string;//Functions
    px1,px2: double;//points x
    fcnt: integer;//counter

    function f(x: Real): Real;
  public
    GFMaxPosition,GFActualPosition: Integer;
    procedure AddGraphics;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.CreateErrorSeries(var DataSeries: TLineSeries;
  var ErrorSeries: TAreaSeries; var AStyles: TChartStyles;
  AColor: TColor; ATitle: String);
begin
  // Create line series for the data values y
  DataSeries := TLineSeries.Create(self);
  Chart1.AddSeries(DataSeries);

  // Create a stacked area series for the error band
  ErrorSeries := TAreaSeries.Create(self);
  Chart1.AddSeries(ErrorSeries);

  // Set properties of the line series
  DataSeries.LinePen.Color := Acolor;
  DataSeries.LinePen.Width := 3;
  DataSeries.Transparency := 128;      // Activate transparency
  DataSeries.ListSource.YCount := 1;   // We need 1 y value only
  DataSeries.Title := ATitle;

  // Set properties of the area series
  ErrorSeries.AreaLinesPen.Style := psClear;   // we don't want to see these lines
  ErrorSeries.AreaContourPen.Style := psClear;
  ErrorSeries.Transparency := 190;     // Activate transparency
  ErrorSeries.ListSource.YCount := 2;  // we need y values for the lower and upper error limits
  ErrorSeries.Legend.Visible := false;

  // Styles to colorize the layers of the stacked series
  AStyles := TChartStyles.Create(self);
  with TChartStyle(AStyles.Styles.Add) do begin
    Brush.Style := bsClear;   // lower level must be transparent
    UsePen := false;          // Use (hidden) AreaLinesPen and AreaContourPen of series
  end;
  with TChartStyle(AStyles.Styles.Add) do begin
    Brush.Color := AColor;
    UsePen := false;
  end;
  ErrorSeries.Styles := AStyles;
end;

function TForm1.f(x: Real): Real;
begin
   Parse1.NewValue('x',x);
   f:= Parse1.Evaluate();
end;

procedure TForm1.AddGraphics;
begin
   GFMaxPosition:= GFMaxPosition + 1;
   SetLength( GraphicFrame, GFMaxPosition + 1 );
   GraphicFrame[ GFMaxPosition ]:= TFrameFunction.Create( Panel2 );
   GraphicFrame[ GFMaxPosition ].Name:= 'GF'+ IntToStr( GFMaxPosition );
   GraphicFrame[ GFMaxPosition ].Parent:= Panel2;
   GraphicFrame[ GFMaxPosition ].Align:= alTop;
   GraphicFrame[ GFMaxPosition ].Tag:= GFMaxPosition;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddGraphics;
  Parse1:=TParseMath.create;
  CmdBox1.StartRead(clBlack,clWhite,'Numerico>',clBlack,clWhite);
  //[columna,fila] en StringGrid
  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,1]:='error'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,1]:='0.001'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,1]:='Double'; // [columnas,filas]
  Parse1.AddVariable('error',0.001);

  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,2]:='decimales'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,2]:='2'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,2]:='Double'; // [columnas,filas]
  Parse1.AddVariable('decimales',2);

  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,3]:='ans'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,3]:=''; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,3]:=''; // [columnas,filas]
  Parse1.AddVariable('ans',0);

  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
  TablaDeVarsStrGrid.Cells[0,4]:='n'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[1,4]:='10000'; // [columnas,filas]
  TablaDeVarsStrGrid.Cells[2,4]:='Double'; // [columnas,filas]
  Parse1.AddVariable('n',10000);

  Parse1.AddVariable('x',0);
end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
var
  iPos, i, Iter, Iter2, Iter3, temporalDecimales, temporalInteger: Integer;
  ToSENLtope1, ToSENLtope2, ToSENLtope3: Integer;
  StrFuncList, StrPuntosIni: TStringList;
  StrList,StrListemporal,StrListemporal2: TStringList;
  IntervalsRoots, ArootTemp, BrootTemp: Double;
  StrListParaRoots: TStringList;
  FuncToRootTempo,TemporalRootAns,TemporalRootAns2: String;//La respuesta de los donde estan los roots
  func, VariableName, respuesta, Parche, temporalString: string;
  tempFunc1, tempFunc2:string;
  temporalDouble: Double;
  ResultDelSENL : TMatrix;
  //temporales para los plots
  TemporalFuncToPlot, TemporalRangoAToPlot, TemporalRangoBToPlot, TemporalColorToPlot:string;
  //Temporales para el intersection
  TemporalFmenosG, TemporalA, TemporalB:string;
  //Variables para el area de la integral
  Max, Min, hArea, NewX, NewY: Real;
  IsInIntervalArea: Boolean;
  //Temporales para el area entre 2 funciones
  InicioParaArea, FinParaArea, YParaArea: Double;
  RestaDeFuncionesArea : String;
  //almacen temporal para los edo
  temporalEDO, temporalEDO2: String;
begin
  try
  StrList:= TStringList.Create;
  StrFuncList:= TStringList.Create;
  StrPuntosIni:= TStringList.Create;
  StrListemporal:= TStringList.Create;
  StrListemporal2:= TStringList.Create;
  StrListParaRoots:=TStringList.Create;
  //Nota:Un string empieza con el indice 1
  CmdBox1.TextColors(clBlack,clWhite);//Color para el input en la consola
  Input := Trim(Input);
  Input := StringReplace(Input,' ',',',[rfReplaceAll, rfIgnoreCase]);//Cambia los espacios por las comas
  if FuncsAuxs.ExisteIgualdad(Input) = 0 then
  begin
    Parche:='ans=';
    Input:=Concat(Parche,Input);
  end;
  if FuncsAuxs.ExisteIgualdad(Input) <> 0 then
  begin
    VariableName := Copy(Input,1,FuncsAuxs.ExisteIgualdad(Input)-1);//Nombre de la variable a asignar
    Input := Copy(Input,FuncsAuxs.ExisteIgualdad(Input)+1,Length(Input));//Todo lo de la derecha es el nuevo imput
    if FuncsAuxs.QueTipoEs(Input)='Double' then
    begin
      Iter:=0;
      while Iter<=TablaDeVarsStrGrid.RowCount-1 do
      begin
        if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
        begin
          TablaDeVarsStrGrid.Cells[1,Iter]:=Input; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
          Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
          Break;
        end
        else if Iter = TablaDeVarsStrGrid.RowCount-1 then
        begin
          if VariableName='x' then
          begin
            TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
            TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
            TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=Input; // [columnas,filas]
            TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
            Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
            Break;
          end
          else
          TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
          TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=Input; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
          Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
          Break;
        end;
        Iter:=Iter+1;
      end;
    end;
    if FuncsAuxs.QueTipoEs(Input)='List' then
    begin
      Iter:=0;
      while Iter<=TablaDeVarsStrGrid.RowCount-1 do
      begin
        if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
        begin
            TablaDeVarsStrGrid.Cells[1,Iter]:=Input; // [columnas,filas]
            TablaDeVarsStrGrid.Cells[2,Iter]:='List'; // [columnas,filas]
            Break;
        end
        else if Iter = TablaDeVarsStrGrid.RowCount-1 then
        begin
          TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
          TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=Input; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='List'; // [columnas,filas].
          Break;
        end;
        Iter:=Iter+1;
      end;
    end;
    if FuncsAuxs.QueTipoEs(Input)='String' then
    begin
      Iter:=0;
      while Iter<=TablaDeVarsStrGrid.RowCount-1 do
      begin
        if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
        begin
          TablaDeVarsStrGrid.Cells[1,Iter]:=Input; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,Iter]:='String'; // [columnas,filas]
          Break;
        end
        else if Iter = TablaDeVarsStrGrid.RowCount-1 then
        begin
          TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
          TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=Input; // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='String'; // [columnas,filas].
          Break;
        end;
        Iter:=Iter+1;
      end;
    end;
    if FuncsAuxs.QueTipoEs(Input)='Func' then
    begin
      iPos:= Pos( '(', Input );
      func:= Trim( Copy( Input, 1, iPos - 1 ));
      StrList.Delimiter:=',' ;
      StrList.StrictDelimiter:= true;
      StrList.DelimitedText:= Copy( Input, iPos + 1, Length( Input ) - iPos - 1  );
      case func of
            'root' : begin
              SENLObject:=SENLFunciones.create;
              SENLObjectTemporal:=SENLFunciones.create;
              CmdBox1.Writeln('Se detecto el comando : root');
              //Busquede de los 3 primeros aprametros en la tabla
              //Asignacion de la funcion buscando en la lista variables
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                  SENLObject.fx := temporalString;
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  temporalString:=StringReplace(StrList[0],'''','',[rfReplaceAll, rfIgnoreCase]);
                  SENLObject.fx := temporalString;
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignacion de el parametro A buscando la lista de variables
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  SENLObject.a := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  SENLObject.a := StrToFloat(StrList[1]);
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignacion del parametro B buscando en la lista de variables
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  SENLObject.b := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  SENLObject.b := StrToFloat(StrList[2]);
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignacion del error en base a la tabla
              SENLObject.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
              //PLOTEO DE LA FUNCION
              Chart1.Visible := True;
              GraphicFrame[GFMaxPosition].PlotFunc(SENLObject.fx,FloatToStr(SENLObject.a),FloatToStr(SENLObject.b),'clBlue');
              //Caso de que hay 4 parametros, se pasa a verificar si se pide todos o una raiz
              //Si es False solo se quiere 1 si es True se quieren todos los roots
              if(StrList.Count=4) then
              begin
                //Caso que solo se pide un root
                if StrList[3]='False' then
                begin
                respuesta := SENLObject.Secante();
                CmdBox1.Writeln('La respuesta es :'+respuesta);
                //Dibujar el punto
                Parse1.Expression:=SENLObject.fx;
                Chart1LineSeriesToRoot.AddXY(StrToFloat(respuesta),f(StrToFloat(respuesta)));
                Chart1LineSeriesToRoot.ShowPoints := True;
                Chart1LineSeriesToRoot.LinePen.Style := psClear;
                //Termina el proceso de dibujo

                //Asignacion de tamaño de decimales a la variable temporalDecimales
                temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                temporalDouble:=StrToFloat(respuesta);
                respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                //Termina de asignar la respuesta con la aproximacion de decimales globales

                //Inicio de buscar y asignar a la respuesta a la variable asignada
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                    TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                    Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                  //Si no se encontro la variable inicial se crea una
                    TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                    TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                    TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                    TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                    Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                  //Acaba la busqueda y asignacion
                end
                else
                //Inicio de que si el booleano es True, la respuesta sera List y sera con metodo de la secante
                begin
                  FuncToRootTempo:='[';//En FuncToRootTempo se guardara la respuesta
                  IntervalsRoots:=0.01;
                  ArootTemp:=SENLObject.a;
                  BrootTemp:=SENLObject.b;
                  while ArootTemp<=SENLObject.b do
                  begin
                    SENLObjectTemporal.fx:=SENLObject.fx;
                    SENLObjectTemporal.a:=ArootTemp;
                    SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                    SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                    TemporalRootAns := SENLObjectTemporal.Secante();
                    temporalDouble:=StrToFloat(TemporalRootAns);
                    temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                    TemporalRootAns:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                    if (TemporalRootAns<>'')and(
                        (StrToFloat(TemporalRootAns)>=SENLObjectTemporal.a)and
                        (StrToFloat(TemporalRootAns)<=SENLObjectTemporal.b)
                    ) then
                    begin
                      FuncToRootTempo:=FuncToRootTempo+TemporalRootAns;
                      FuncToRootTempo:=FuncToRootTempo+',';
                    end;
                    ArootTemp:=ArootTemp+IntervalsRoots;
                  end;
                  FuncToRootTempo[Length(FuncToRootTempo)]:=']';
                  CmdBox1.Writeln('La respuesta es : '+FuncToRootTempo);
                  //Inicio de la busqueda y asignacion de la respuesta a una variable que sera un List
                  Iter:=0;
                  while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                  begin
                    if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                    begin
                        TablaDeVarsStrGrid.Cells[1,Iter]:=FuncToRootTempo; // [columnas,filas]
                        TablaDeVarsStrGrid.Cells[2,Iter]:='List'; // [columnas,filas]
                        Break;
                    end
                    else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                      TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                      TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                      TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=FuncToRootTempo; // [columnas,filas]
                      TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='List'; // [columnas,filas].
                      Break;
                    end;
                    Iter:=Iter+1;
                  end;
                  //Termino de busqueda y asignacion
                  //Ploteo de todos los puntos de la respuesta
                  iPos:= Pos( '[', FuncToRootTempo );
                  StrListParaRoots.Delimiter:=',' ;
                  StrListParaRoots.StrictDelimiter:= true;
                  StrListParaRoots.DelimitedText:= Copy( FuncToRootTempo, iPos + 1, Length( FuncToRootTempo ) - iPos - 1  );
                  for Iter:=0 to StrListParaRoots.Count-1 do
                  begin
                    Parse1.Expression:=SENLObject.fx;
                    Chart1LineSeriesToRoot.AddXY(StrToFloat(StrListParaRoots[Iter]),f(StrToFloat(StrListParaRoots[Iter])));
                    Chart1LineSeriesToRoot.ShowPoints := True;
                    Chart1LineSeriesToRoot.LinePen.Style := psClear;
                  end;
                  //////////////////////////////////////////////////////////////////
                end;
              end
              else
              //cuando hay 5 parametros
              begin
                //Cuando el boleano es False osea que se quiere solo un root y se le asigna el metodo
                if StrList[3]='False' then
                begin
                  case StrList[4] of
                        '0' :begin
                          respuesta := SENLObject.Biseccion();
                          if respuesta='' then
                          ShowMessage('No se puede asignar a nada')
                          else
                          begin
                            Parse1.Expression:=SENLObject.fx;
                            Chart1LineSeriesToRoot.AddXY(StrToFloat(respuesta),f(StrToFloat(respuesta)));
                            Chart1LineSeriesToRoot.ShowPoints := True;
                            Chart1LineSeriesToRoot.LinePen.Style := psClear;
                            temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                            temporalDouble:=StrToFloat(respuesta);
                            respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                            //Asignacion de larespuesta a una variable asignacda al principio
                            Iter := 0;
                            while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                            begin
                              if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                              begin
                                TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                                Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                                Break;
                              end
                              else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                              begin
                                TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                                TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                                Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
                                Break;
                              end;
                              Iter:=Iter+1;
                            end;
                          end;
                          CmdBox1.Writeln('La respuesta es :'+respuesta);
                        end;
                        '1' :begin
                          respuesta := SENLObject.FalsaPosicion();
                          if respuesta='' then
                          ShowMessage('No se puede asignar a nada')
                          else
                          begin
                            Parse1.Expression:=SENLObject.fx;
                            Chart1LineSeriesToRoot.AddXY(StrToFloat(respuesta),f(StrToFloat(respuesta)));
                            Chart1LineSeriesToRoot.ShowPoints := True;
                            Chart1LineSeriesToRoot.LinePen.Style := psClear;
                            temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                            temporalDouble:=StrToFloat(respuesta);
                            respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                            //Asignacion de la rspuesta a la variable
                            Iter := 0;
                            while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                            begin
                              if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                              begin
                                TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                                Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                                Break;
                              end
                              else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                              begin
                                TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                                TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                                Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
                                Break;
                              end;
                              Iter:=Iter+1;
                            end;
                          end;
                          CmdBox1.Writeln('La respuesta es :'+respuesta);
                        end;
                        '2' :begin
                          //ShowMessage('Boleano false con asignacion de metodo 0: biseccion');
                          respuesta := SENLObject.Secante();
                          if respuesta='' then
                          ShowMessage('No se puede asignar a nada')
                          else
                          begin
                            Parse1.Expression:=SENLObject.fx;
                            Chart1LineSeriesToRoot.AddXY(StrToFloat(respuesta),f(StrToFloat(respuesta)));
                            Chart1LineSeriesToRoot.ShowPoints := True;
                            Chart1LineSeriesToRoot.LinePen.Style := psClear;
                            temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                            temporalDouble:=StrToFloat(respuesta);
                            respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                            //Asignacion de la respuesta a la variable
                            Iter := 0;
                            while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                            begin
                              if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                              begin
                                TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                                Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                                Break;
                              end
                              else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                              begin
                                TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                                TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                                Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
                                Break;
                              end;
                              Iter:=Iter+1;
                            end;
                          end;
                          CmdBox1.Writeln('La respuesta es :'+respuesta);
                        end;
                end;
              end
              else
              begin //cuando son todas las raices pero con la seleccion del metodo
                case StrList[4] of
                      '0' :begin
                          FuncToRootTempo:='[';
                          IntervalsRoots:=0.01;
                          ArootTemp:=SENLObject.a;
                          BrootTemp:=SENLObject.b;
                          SENLObjectTemporal.fx:=SENLObject.fx;
                          SENLObjectTemporal.a:=ArootTemp;
                          SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                          SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                          TemporalRootAns2 := SENLObjectTemporal.Biseccion();
                          while ArootTemp<=SENLObject.b do
                          begin
                            SENLObjectTemporal.a:=ArootTemp;
                            SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                            SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                            TemporalRootAns := SENLObjectTemporal.Biseccion();
                            if(TemporalRootAns<>'')and(TemporalRootAns<>TemporalRootAns2) then
                            begin
                                temporalDouble:=StrToFloat(TemporalRootAns);
                                temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                                TemporalRootAns:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                                FuncToRootTempo:=FuncToRootTempo+TemporalRootAns;
                                FuncToRootTempo:=FuncToRootTempo+',';
                                TemporalRootAns2:=TemporalRootAns;
                            end;
                            ArootTemp:=ArootTemp+IntervalsRoots;
                          end;
                          FuncToRootTempo[Length(FuncToRootTempo)]:=']';
                          //Asignacion de la respuesta a la variable
                          Iter:=0;
                          while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                          begin
                            if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                            begin
                                TablaDeVarsStrGrid.Cells[1,Iter]:=FuncToRootTempo; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,Iter]:='List'; // [columnas,filas]
                                Break;
                            end
                            else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                            begin
                              TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                              TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                              TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=FuncToRootTempo; // [columnas,filas]
                              TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='List'; // [columnas,filas].
                              Break;
                            end;
                            Iter:=Iter+1;
                          end;
                          //Ploteo de puntos si te pide todos dentro de un intervalo
                          iPos:= Pos( '[', FuncToRootTempo );
                          StrListParaRoots.Delimiter:=',' ;
                          StrListParaRoots.StrictDelimiter:= true;
                          StrListParaRoots.DelimitedText:= Copy( FuncToRootTempo, iPos + 1, Length( FuncToRootTempo ) - iPos - 1  );
                          for Iter:=0 to StrListParaRoots.Count-1 do
                          begin
                            Parse1.Expression:=SENLObject.fx;
                            Chart1LineSeriesToRoot.AddXY(StrToFloat(StrListParaRoots[Iter]),f(StrToFloat(StrListParaRoots[Iter])));
                            Chart1LineSeriesToRoot.ShowPoints := True;
                            Chart1LineSeriesToRoot.LinePen.Style := psClear;
                          end;
                          CmdBox1.Writeln('La respuesta es :'+FuncToRootTempo);
                          //////////////////////////////////////////////////////////////////
                      end;
                      '1':begin
                          FuncToRootTempo:='[';
                          IntervalsRoots:=0.01;
                          ArootTemp:=SENLObject.a;
                          BrootTemp:=SENLObject.b;
                          SENLObjectTemporal.fx:=SENLObject.fx;
                          SENLObjectTemporal.a:=ArootTemp;
                          SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                          SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                          TemporalRootAns2 := SENLObjectTemporal.FalsaPosicion();
                          while ArootTemp<=SENLObject.b do
                          begin
                            SENLObjectTemporal.a:=ArootTemp;
                            SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                            SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                            TemporalRootAns := SENLObjectTemporal.Biseccion();
                            if(TemporalRootAns<>'')and(TemporalRootAns<>TemporalRootAns2) then
                            begin
                                temporalDouble:=StrToFloat(TemporalRootAns);
                                temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                                TemporalRootAns:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                                FuncToRootTempo:=FuncToRootTempo+TemporalRootAns;
                                FuncToRootTempo:=FuncToRootTempo+',';
                                TemporalRootAns2:=TemporalRootAns;
                            end;
                            ArootTemp:=ArootTemp+IntervalsRoots;
                          end;
                          FuncToRootTempo[Length(FuncToRootTempo)]:=']';
                          //Asignacion de la respuesta a la variable a asignar
                          Iter:=0;
                          while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                          begin
                            if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                            begin
                                TablaDeVarsStrGrid.Cells[1,Iter]:=FuncToRootTempo; // [columnas,filas]
                                TablaDeVarsStrGrid.Cells[2,Iter]:='List'; // [columnas,filas]
                                Break;
                            end
                            else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                            begin
                              TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                              TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                              TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=FuncToRootTempo; // [columnas,filas]
                              TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='List'; // [columnas,filas].
                              Break;
                            end;
                            Iter:=Iter+1;
                          end;
                          //Ploteo de puntos si te pide todos dentro de un intervalo
                          iPos:= Pos( '[', FuncToRootTempo );
                          StrListParaRoots.Delimiter:=',' ;
                          StrListParaRoots.StrictDelimiter:= true;
                          StrListParaRoots.DelimitedText:= Copy( FuncToRootTempo, iPos + 1, Length( FuncToRootTempo ) - iPos - 1  );
                          for Iter:=0 to StrListParaRoots.Count-1 do
                          begin
                            Parse1.Expression:=SENLObject.fx;
                            Chart1LineSeriesToRoot.AddXY(StrToFloat(StrListParaRoots[Iter]),f(StrToFloat(StrListParaRoots[Iter])));
                            Chart1LineSeriesToRoot.ShowPoints := True;
                            Chart1LineSeriesToRoot.LinePen.Style := psClear;
                          end;
                          CmdBox1.Writeln('La respuesta es :'+FuncToRootTempo);
                          //////////////////////////////////////////////////////////////////
                      end;
                      '2':begin
                        FuncToRootTempo:='[';
                        IntervalsRoots:=0.01;
                        ArootTemp:=SENLObject.a;
                        BrootTemp:=SENLObject.b;
                        while ArootTemp<=SENLObject.b do
                        begin
                          SENLObjectTemporal.fx:=SENLObject.fx;
                          SENLObjectTemporal.a:=ArootTemp;
                          SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                          SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                          TemporalRootAns := SENLObjectTemporal.Secante();
                          temporalDouble:=StrToFloat(TemporalRootAns);
                          temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                          TemporalRootAns:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                          if (TemporalRootAns<>'')and(
                              (StrToFloat(TemporalRootAns)>=SENLObjectTemporal.a)and
                              (StrToFloat(TemporalRootAns)<=SENLObjectTemporal.b)
                          ) then
                          begin
                            FuncToRootTempo:=FuncToRootTempo+TemporalRootAns;
                            FuncToRootTempo:=FuncToRootTempo+',';
                          end;
                          ArootTemp:=ArootTemp+IntervalsRoots;
                        end;
                        FuncToRootTempo[Length(FuncToRootTempo)]:=']';
                        //Asignacion de la respuesta a una variable de la tabla de variables
                        Iter:=0;
                        while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                        begin
                          if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                          begin
                              TablaDeVarsStrGrid.Cells[1,Iter]:=FuncToRootTempo; // [columnas,filas]
                              TablaDeVarsStrGrid.Cells[2,Iter]:='List'; // [columnas,filas]
                              Break;
                          end
                          else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                          begin
                            TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                            TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                            TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=FuncToRootTempo; // [columnas,filas]
                            TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='List'; // [columnas,filas].
                            Break;
                          end;
                          Iter:=Iter+1;
                        end;
                        //Ploteo de puntos si te pide todos dentro de un intervalo
                          iPos:= Pos( '[', FuncToRootTempo );
                          StrListParaRoots.Delimiter:=',' ;
                          StrListParaRoots.StrictDelimiter:= true;
                          StrListParaRoots.DelimitedText:= Copy( FuncToRootTempo, iPos + 1, Length( FuncToRootTempo ) - iPos - 1  );
                          for Iter:=0 to StrListParaRoots.Count-1 do
                          begin
                            Parse1.Expression:=SENLObject.fx;
                            Chart1LineSeriesToRoot.AddXY(StrToFloat(StrListParaRoots[Iter]),f(StrToFloat(StrListParaRoots[Iter])));
                            Chart1LineSeriesToRoot.ShowPoints := True;
                            Chart1LineSeriesToRoot.LinePen.Style := psClear;
                          end;
                          //////////////////////////////////////////////////////////////////
                          CmdBox1.Writeln('La respuesta es :'+FuncToRootTempo);
                      end;
                end;
              end;
              end;
              SENLObject.Destroy;
              SENLObjectTemporal.Destroy;
            end;
            'polyroot' : begin
              CmdBox1.Writeln('Se detecto la funcion : polyroot');
              PolyrootObjt:=TPolyroot.create(StrList.Count);
              if StrList.Count=1 then
              begin
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                //Busco la variable dentro de la funcion en la tabla de variables
                  if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'[','',[rfReplaceAll, rfIgnoreCase]);
                    temporalString:=StringReplace(temporalString,']','',[rfReplaceAll, rfIgnoreCase]);
                    StrListemporal.Delimiter:=',' ;
                    StrListemporal.StrictDelimiter:= true;
                    StrListemporal.DelimitedText:= temporalString;
                    PolyrootObjt.create(StrListemporal.Count);
                    for Iter2:=0 to StrListemporal.Count-1 do
                    begin
                        PolyrootObjt.points[Iter2]:=StrListemporal[Iter2];
                    end;
                    //Busco el nombre de la variable que se igualo en el principio y le asigno la respuesta
                    Iter:=0;
                    while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                     begin
                     if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                     begin
                       TablaDeVarsStrGrid.Cells[1,Iter]:=PolyrootObjt.getPolinomy(); // [columnas,filas]
                       CmdBox1.Writeln('La respuesta es :'+TablaDeVarsStrGrid.Cells[1,Iter]);
                       TablaDeVarsStrGrid.Cells[2,Iter]:='String'; // [columnas,filas]
                       Break;
                     end
                     else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                     begin
                       TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                       TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=PolyrootObjt.getPolinomy(); // [columnas,filas]
                       CmdBox1.Writeln('La respuesta es :'+TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]);
                       TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='String'; // [columnas,filas]
                       Break;
                     end;
                     Iter:=Iter+1;
                     end;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
              end else
              begin
              //caso que le metes los puntos defrente
              StrList[0]:=StringReplace(StrList[0],'[','',[rfReplaceAll, rfIgnoreCase]);
              StrList[StrList.Count-1]:=StringReplace(StrList[StrList.Count-1],']','',[rfReplaceAll, rfIgnoreCase]);
              Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    PolyrootObjt.create(StrList.Count);
                    for Iter2:=0 to StrList.Count-1 do
                    begin
                        PolyrootObjt.points[Iter2]:=StrList[Iter2];
                    end;
                    TablaDeVarsStrGrid.Cells[1,Iter]:=PolyrootObjt.getPolinomy();
                    CmdBox1.Writeln('La respuesta es :'+TablaDeVarsStrGrid.Cells[1,Iter]);
                    TablaDeVarsStrGrid.Cells[2,Iter]:='String';
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    PolyrootObjt.create(StrList.Count);
                    for Iter2:=0 to StrList.Count-1 do
                    begin
                        PolyrootObjt.points[Iter2]:=StrList[Iter2];
                    end;
                    TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                    TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                    TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=PolyrootObjt.getPolinomy(); // [columnas,filas]
                    CmdBox1.Writeln('La respuesta es :'+TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]);
                    TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='String'; // [columnas,filas]
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
              end;
            end;
            'polynomial' : begin
              CmdBox1.Writeln('Se detecto la funcion : polynomial');
              //2 variables de la tabla
              if StrList.Count = 2 then
              begin
                //Busqueda y optencion de la primera lista de numeros
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                        if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                        begin
                          StrListemporal.Delimiter:=',' ;
                          StrListemporal.StrictDelimiter:= true;
                          temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'[','',[rfReplaceAll, rfIgnoreCase]);
                          temporalString:=StringReplace(temporalString,']','',[rfReplaceAll, rfIgnoreCase]);
                          StrListemporal.DelimitedText:= temporalString;// [columnas,filas]
                          Break;
                        end;
                        Iter:=Iter+1;
                end;
                //Busqueda y optencion de la segunda lista de numeros
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                        if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                        begin
                          StrListemporal2.Delimiter:=',' ;
                          StrListemporal2.StrictDelimiter:= true;
                          temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'[','',[rfReplaceAll, rfIgnoreCase]);
                          temporalString:=StringReplace(temporalString,']','',[rfReplaceAll, rfIgnoreCase]);

                          StrListemporal2.DelimitedText:= temporalString;// [columnas,filas]
                          Break;
                        end;
                        Iter:=Iter+1;
                end;
                //ShowMessage('paso la busqueda de las variables y su asignacion a listas diferentes');
                PolynomialObjt:=TInterpolation.create(StrListemporal2.Count);
                for Iter:=0 to StrListemporal2.Count-1 do
                begin
                  PolynomialObjt.arrPoints[Iter].x:=StrToFloat(StrListemporal[Iter]);
                  PolynomialObjt.arrPoints[Iter].y:=StrToFloat(StrListemporal2[Iter]);
                end;
                respuesta:=PolynomialObjt.getPolinomy();
                //respuesta := StringReplace(StringReplace(respuesta, #10, ' ', [rfReplaceAll]), #13, ' ', [rfReplaceAll]);
                CmdBox1.Writeln('La respuesta es :'+respuesta);
                //Asignacion a la variable iniciada al principio
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                     if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                     begin
                       TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[2,Iter]:='String'; // [columnas,filas]
                       Break;
                     end
                     else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                     begin
                       TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                       TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='String'; // [columnas,filas]
                       Break;
                     end;
                     Iter:=Iter+1;
                end;
              end
              else
              begin
                //caso de que se le pongas los 2 campos manuales

                //Borro las [] de cada elemento
                PolynomialObjt:=TInterpolation.create(Round((StrList.Count)/2));
                ShowMessage(IntToStr(PolynomialObjt.tp));
                for Iter:=0 to StrList.Count-1 do
                begin
                  StrList[Iter]:=StringReplace(StrList[Iter],'[','',[rfReplaceAll, rfIgnoreCase]);
                  StrList[Iter]:=StringReplace(StrList[Iter],']','',[rfReplaceAll, rfIgnoreCase]);
                end;
                PolynomialObjt:=TInterpolation.create(Round((StrList.Count)/2));
                //ShowMessage(IntToStr(PolynomialObjt.tp));
                //Asignacion de las variables
                for Iter:=0 to Round((StrList.Count)/2)-1 do
                begin
                  PolynomialObjt.arrPoints[Iter].x:=StrToFloat(StrList[Iter]);
                end;
                Iter2:=0;
                for Iter:=Round((StrList.Count)/2) to (StrList.Count)-1 do
                begin
                  PolynomialObjt.arrPoints[Iter2].y:=StrToFloat(StrList[Iter]);
                  Iter2:=Iter2+1;
                end;
                respuesta:=PolynomialObjt.getPolinomy();
                CmdBox1.Writeln('La respuesta es :'+respuesta);
                //Asignacion a la variable iniciada al principio
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                     if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                     begin
                       TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[2,Iter]:='String'; // [columnas,filas]
                       Break;
                     end
                     else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                     begin
                       TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                       TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='String'; // [columnas,filas]
                       Break;
                     end;
                     Iter:=Iter+1;
                end;
              end;
            end;
            'eval' : begin
              CmdBox1.Writeln('Se detecto la funcion : eval');
              //Busqueda y obtencion del valor de la varable a buscar
              Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                        if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                        begin
                          temporalString:=TablaDeVarsStrGrid.Cells[1,Iter];
                          temporalString:=StringReplace(temporalString,'''','',[rfReplaceAll, rfIgnoreCase]);
                          Parse1.Expression:=temporalString;
                          Break;
                        end;
                        Iter:=Iter+1;
                end;
              //Asignacion a la variable iniciada al principio
                Iter:=0;
                temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                     if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                     begin
                       TablaDeVarsStrGrid.Cells[1,Iter]:=FloatToStrF(Parse1.Evaluate(),ffFixed,11,temporalDecimales);// [columnas,filas]
                       CmdBox1.Writeln('La respuesta es :'+TablaDeVarsStrGrid.Cells[1,Iter]);
                       TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                       Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                       Break;
                     end
                     else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                     begin
                       TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                       TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                       TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=FloatToStrF(Parse1.Evaluate(),ffFixed,11,temporalDecimales); // [columnas,filas]
                       CmdBox1.Writeln('La respuesta es :'+TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]);
                       TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                       Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
                       Break;
                     end;
                     Iter:=Iter+1;
                end;
            end;
            'senl' : begin
              CmdBox1.Writeln('Se detecto la funcion : SENL');
              for Iter:=0 to StrList.Count-1 do
              begin
                StrList[Iter]:=StringReplace(StrList[Iter],'[','',[rfReplaceAll, rfIgnoreCase]);
                StrList[Iter]:=StringReplace(StrList[Iter],']','',[rfReplaceAll, rfIgnoreCase]);
              end;
              //Identificar cuantos variables,funciones,tamaño del punto incial
              temporalInteger:=Round(StrList.Count/3);
              ToSENLtope1:=Round(StrList.Count/3)-1;//fininicio [2]
              ToSENLtope2:=Round(StrList.Count/3)*2-1;//medio[5]
              ToSENLtope3:=StrList.Count-1;//[StrList.Count-1] osea [8]
              //tratado de las variables a usar
              for Iter:=0 to StrList.Count-1 do
              begin
                //le borro comillas a las variables del inicio para juntarlas y las funciones
                StrList[Iter]:=StringReplace(StrList[Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
              end;
              temporalString:='';
              for Iter:=0 to ToSENLtope1 do
              begin
                // aca esta el string con el las variables a usar para meter la funcion newtonGen
                temporalString:=temporalString+StrList[Iter];
              end;
              //temporalString Contiene la lista de variables
              NewtonGenObjet:=TNewtonGen.create(temporalInteger,temporalInteger);
              initVariables(temporalInteger,temporalString);
              initArrFunctions(temporalInteger,temporalInteger);
              //----------------Ahora vere las funciones------------------
              //Buscar primera en las variables de la tabla y si no las encuentra añadade el string ferente
              Iter3:=0;
              for Iter2:=ToSENLtope1+1 to ToSENLtope2 do
              begin
                //Buscar en las variables definidas
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[Iter2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    //borrar las ''
                    temporalString:=TablaDeVarsStrGrid.Cells[1,Iter];
                    temporalString:=StringReplace(temporalString,'''','',[rfReplaceAll, rfIgnoreCase]);
                    arrFunctions[Iter3].Expression:=TablaDeVarsStrGrid.Cells[1,Iter];
                    Iter3:=Iter3+1;
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    arrFunctions[Iter3].Expression:=StrList[Iter2];
                    Iter3:=Iter3+1;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
              end;
              //---------------Ahora se veran los puntos iniciales--------------
              Iter3:=0;
              for Iter2:=ToSENLtope2+1 to ToSENLtope3 do
              begin
                //Buscar en las variables definidas
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[Iter2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    NewtonGenObjet.Xo.setElement(Iter3,0,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                    Iter3:=Iter3+1;
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    NewtonGenObjet.Xo.setElement(Iter3,0,StrToFloat(StrList[Iter2]));
                    Iter3:=Iter3+1;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
              end;
              //Calcular con newtonGen
              ResultDelSENL:= NewtonGenObjet.calculate(StrToFloat(TablaDeVarsStrGrid.Cells[1,1]));
              temporalString:='[';
              //Valores decimales
              temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
              for iPos:=0 to temporalInteger-1 do
              begin
                temporalString:=temporalString+FloatToStrF(ResultDelSENL.getElement(iPos,0),ffFixed,11,temporalDecimales);
                if iPos<>temporalInteger-1 then
                temporalString:=temporalString+','
              end;
              temporalString:=temporalString+']';//aca esta la respuesta
              CmdBox1.Writeln('La Respuesta es :'+temporalString);
              Iter:=0;
              while Iter<=TablaDeVarsStrGrid.RowCount-1 do
              begin
                if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                    TablaDeVarsStrGrid.Cells[1,Iter]:=temporalString; // [columnas,filas]
                    TablaDeVarsStrGrid.Cells[2,Iter]:='List'; // [columnas,filas]
                    Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                  TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                  TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=temporalString; // [columnas,filas]
                  TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='List'; // [columnas,filas].
                  Break;
                end;
                Iter:=Iter+1;
              end;
            end;
            'edo' : begin
              CmdBox1.Writeln('Se detecto la funcion : edo');
              //Creacion del objeto de la classe que contiene los metodos de edo
              EdoObject:=TMethodsDif.create();
              EdoObject.h:=StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
              //Buscar si una variable tiene la funcion
              //ShowMessage('Inicio de busqueda de la funcion en la tabla');
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                  EdoObject.setExpression(temporalString);
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  temporalString:=StringReplace(StrList[0],'''','',[rfReplaceAll, rfIgnoreCase]);
                  EdoObject.setExpression(temporalString);
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignar el xo
              //ShowMessage('Inicio de la busqueda en variables de X0');
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  EdoObject.X0 := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                  temporalEDO:=TablaDeVarsStrGrid.Cells[1,Iter];
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  EdoObject.X0 := StrToFloat(StrList[1]);
                  temporalEDO := StrList[1];
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignar el y0
              //ShowMessage('Inicio de buscado en las variables de Y0');
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  EdoObject.Y0 := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  EdoObject.Y0 := StrToFloat(StrList[2]);
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignar el Xn
              //ShowMessage('Inicio de buscado en las variables de Xn');
              Iter:=0;
              while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
              begin
                if StrList[3]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    EdoObject.n :=
                    Trunc( abs( StrToFloat( TablaDeVarsStrGrid.Cells[1,Iter] )-EdoObject.X0)/StrToFloat(TablaDeVarsStrGrid.Cells[1,1]));
                    Break;
                  end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                    EdoObject.n :=
                    Trunc( abs( StrToFloat( StrList[3] )-EdoObject.X0)/StrToFloat(TablaDeVarsStrGrid.Cells[1,1]));
                    Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignar el metodo
              //ShowMessage('Asignacion del metodo');
              Iter:=0;
              if StrList.Count=4 then
              begin
                EdoObject.methodType:=3;
              end
              else begin
                EdoObject.methodType:=StrToInt(StrList[4]);
              end;

              //Ahora iniciar Procedimiento y guardarlo en la variable del primcipio
              //Busco el nombre de la variable que se igualo en el principio y le asigno la respuesta
              Iter:=0;
              //ShowMessage('Calculo de la respuesta');
              temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
              temporalDouble:=EdoObject.Execute();
              respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
              CmdBox1.Writeln('La Respuesta es :'+respuesta);
              //////////////////////////////
              //ShowMessage('Asignacion de la respuesta a la variable a asignar');
              Iter := 0;
              while Iter<=TablaDeVarsStrGrid.RowCount-1 do
              begin
                if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                  TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                  Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                  TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                  TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta;
                  Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));// [columnas,filas]
                  TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //METODO 0
              //ShowMessage('Inicio de la impresion de puntos metodo 0');
              temporalDouble:=EdoObject.X0;
              Iter2:=1;
              if(EdoObject.methodType=0) then
              begin
                Chart1.Visible := True;
                Chart1LineSeriesToEDO.Clear;
                while(temporalDouble<=EdoObject.Y0) do
                begin
                  Chart1LineSeriesToEDO.AddXY(temporalDouble,StrToFloat(EdoObject.table[0][Iter2]));
                  Chart1LineSeriesToEDO.ShowPoints := True;
                  Chart1LineSeriesToEDO.LinePen.Style := psSolid;
                  temporalDouble:=temporalDouble+StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                  Iter2:=Iter2+1;
                end;
              end;
              //METODO 1
              //ShowMessage('Inicio de la impresion de puntos metodo 1');
              temporalDouble:=EdoObject.X0;
              Iter2:=1;
              if(EdoObject.methodType=1) then
              begin
                Chart1.Visible := True;
                Chart1LineSeriesToEDO.Clear;
                while(temporalDouble<=EdoObject.Y0) do
                begin
                  Chart1LineSeriesToEDO.AddXY(temporalDouble,StrToFloat(EdoObject.table[1][Iter2]));
                  Chart1LineSeriesToEDO.ShowPoints := True;
                  Chart1LineSeriesToEDO.LinePen.Style := psSolid;
                  temporalDouble:=temporalDouble+StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                  Iter2:=Iter2+1;
                end;
              end;
              //METODO 2
              //ShowMessage('Inicio de la impresion de puntos metodo 2');
              temporalDouble:=EdoObject.X0;
              Iter2:=1;
              if(EdoObject.methodType=2) then
              begin
                Chart1.Visible := True;
                Chart1LineSeriesToEDO.Clear;
                while(temporalDouble<=EdoObject.Y0) do
                begin
                  Chart1LineSeriesToEDO.AddXY(temporalDouble,StrToFloat(EdoObject.table[0][Iter2]));
                  Chart1LineSeriesToEDO.ShowPoints := True;
                  Chart1LineSeriesToEDO.LinePen.Style := psSolid;
                  temporalDouble:=temporalDouble+StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                  Iter2:=Iter2+1;
                end;
              end;
              //METODO 3
              //ShowMessage('Inicio de la impresion de puntos metodo 3');
              temporalDouble:=EdoObject.X0;
              Iter2:=1;
              if(EdoObject.methodType=3) then
              begin
                Chart1.Visible := True;
                Chart1LineSeriesToEDO.Clear;
                while(temporalDouble<=EdoObject.Y0) do
                begin
                  Chart1LineSeriesToEDO.AddXY(temporalDouble,StrToFloat(EdoObject.table[0][Iter2]));
                  Chart1LineSeriesToEDO.ShowPoints := True;
                  Chart1LineSeriesToEDO.LinePen.Style := psSolid;
                  temporalDouble:=temporalDouble+StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                  Iter2:=Iter2+1;
                end;
              end;
            end;
            'integral' : begin
              Chart1.Visible := True;
              CmdBox1.Writeln('Se detecto la funcion : integral');
              IntegralObjct:=TMethodIntegral.create();
              IntegralObjct.n:=StrToInt(TablaDeVarsStrGrid.Cells[1,4]);//Ingreso del n
              //asignacion de la funcion
              Iter:=0;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                    ShowMessage('f: '+temporalString);
                    IntegralObjct.setExpr(temporalString);
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    temporalString:=StringReplace(StrList[0],'''','',[rfReplaceAll, rfIgnoreCase]);
                    ShowMessage('f: '+temporalString);
                    IntegralObjct.setExpr(temporalString);
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignar el a
                Iter:=0;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    IntegralObjct.a := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    IntegralObjct.a := StrToFloat(StrList[1]);
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignar el b
                Iter:=0;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    IntegralObjct.b := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    IntegralObjct.b := StrToFloat(StrList[2]);
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignar el metodo
                Iter:=0;
                if StrList.Count=3 then
                begin
                  IntegralObjct.methodType:=2;
                end
                else begin
                  IntegralObjct.methodType:=StrToInt(StrList[3]);
                end;
                //Ahora iniciar Procedimiento y guardarlo en la variable del primcipio
                //Busco el nombre de la variable que se igualo en el principio y le asigno la respuesta
                Iter:=0;
                temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                temporalDouble:=IntegralObjct.Evaluate();
                respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                CmdBox1.Writeln('La Respuesta es :'+respuesta);
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                    if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                    begin
                      TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                      Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
                      TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                      Break;
                    end
                    else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                      TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                      TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                      TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta;
                      Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));// [columnas,filas]
                      TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                      Break;
                    end;
                    Iter:=Iter+1;
                end;
                //Ploteo de la Funcion y la sombra bajo de ella;
                //aca tendo la funcion temporalString
                ShowMessage(temporalString);
                GraphicFrame[GFMaxPosition].PlotFunc(temporalString,FloatToStr(IntegralObjct.a),FloatToStr(IntegralObjct.b),'clBlue');
                //ahora el area
                Parse1.Expression := temporalString;
                Chart1AreaSeries1.Clear;
                Chart1AreaSeries1.Active:= False;
                Max:=  IntegralObjct.b;
                Min:=  IntegralObjct.a ;
                hArea:= abs( ( Max - Min )/( 100 * Max ) );
                NewX:= IntegralObjct.a ;
                //darle color
                while NewX < Max do begin
                   NewY:= f( NewX );
                   IsInIntervalArea:= ( NewX >= IntegralObjct.a ) and (  NewX <= IntegralObjct.b) ;
                   if IsInIntervalArea then
                      Chart1AreaSeries1.AddXY( NewX, NewY );
                   NewX:= NewX + hArea;
                end;
                Chart1AreaSeries1.Active:= true;
            end;
            'area' : begin
              CmdBox1.Writeln('Se detecto la funcion : area');
              Chart1.Visible := True;
              IntegralObjct:=TMethodIntegral.create();
              IntegralObjct.n:=StrToInt(TablaDeVarsStrGrid.Cells[1,4]);//Ingreso del n
              IntegralObjct.FindArea:=true;//que le tome valor absoluto
              //asignacion de la funcion que son 2 pero las resto
              Iter:=0;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                    tempFunc1:=temporalString;
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    temporalString:=StringReplace(StrList[0],'''','',[rfReplaceAll, rfIgnoreCase]);
                    tempFunc1:=temporalString;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                    tempFunc2:=temporalString;
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    temporalString:=StringReplace(StrList[1],'''','',[rfReplaceAll, rfIgnoreCase]);
                    tempFunc2:=temporalString;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Envio de las 2 funciones restadas
                temporalString:=tempFunc1+'-('+tempFunc2+')';
                IntegralObjct.setExpr(temporalString);
                //Asignar el a
                Iter:=0;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    IntegralObjct.a := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    IntegralObjct.a := StrToFloat(StrList[2]);
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignar el b
                Iter:=0;
                while (Iter<=TablaDeVarsStrGrid.RowCount-1) do
                begin
                  if StrList[3]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    IntegralObjct.b := StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]);
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                    IntegralObjct.b := StrToFloat(StrList[3]);
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Ploteo de las funciones
                GraphicFrame[GFMaxPosition].PlotFunc(tempFunc2,FloatToStr(IntegralObjct.a),FloatToStr(IntegralObjct.b),'clBlue');
                GraphicFrame[GFMaxPosition].PlotFunc(tempFunc1,FloatToStr(IntegralObjct.a),FloatToStr(IntegralObjct.b),'clBlue');
                //--------------------------------------------------------
                //Ploteo del area entre funciones
                AreaSeries3.Clear;
                AreaSeries3.Active:= False;
                CreateErrorSeries(LineSeries3, AreaSeries3, Styles3, clGreen, 'Dataset 3');

                InicioParaArea := IntegralObjct.a;
                FinParaArea := IntegralObjct.b;
                while InicioParaArea<FinParaArea do
                begin
                  Parse1.Expression := tempFunc2;//funcion 2
                  YParaArea := f(InicioParaArea);
                  InicioParaArea := InicioParaArea+0.001;
                  Parse1.Expression := temporalString;//funcion 1
                  AreaSeries3.AddXY(InicioParaArea,YParaArea,f(InicioParaArea))//f2-f1
                end;
                  AreaSeries3.Active:= true;
                //-------------------------------------------------------
                //Asignar el metodo
                Iter:=0;
                if StrList.Count=4 then
                begin
                  IntegralObjct.methodType:=0;
                end
                else begin
                  IntegralObjct.methodType:=StrToInt(StrList[4]);
                end;
                //Ahora iniciar Procedimiento y guardarlo en la variable del primcipio
                //Busco el nombre de la variable que se igualo en el principio y le asigno la respuesta
                Iter:=0;
                temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                //temporalDecimales:=-temporalDecimales;
                temporalDouble:=IntegralObjct.Evaluate();
                respuesta:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                CmdBox1.Writeln('La Respuesta es :'+respuesta);
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                    if VariableName = TablaDeVarsStrGrid.Cells[0,Iter] then
                    begin
                      TablaDeVarsStrGrid.Cells[1,Iter]:=respuesta; // [columnas,filas]
                      TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
                      Break;
                    end
                    else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                      TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
                      TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
                      TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=respuesta; // [columnas,filas]
                      TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
                      Break;
                    end;
                    Iter:=Iter+1;
                end;
            end;
            'plot2d' : begin
              Chart1.Visible := True;
              //le borro comillas a las funciones o bueno a todo xD
              for Iter:=0 to StrList.Count-1 do
              begin
                StrList[Iter]:=StringReplace(StrList[Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
              end;
              //Asignacion de la funcion dentro del frame
              Iter:=0;
              while Iter<=TablaDeVarsStrGrid.RowCount-1 do
              begin
                if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                  TemporalFuncToPlot := temporalString;
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                  TemporalFuncToPlot:=StrList[0];
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignacion de la a
              Iter:=0;
              while Iter<=TablaDeVarsStrGrid.RowCount-1 do
              begin
                if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  TemporalRangoAToPlot := TablaDeVarsStrGrid.Cells[1,Iter];
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                  TemporalRangoAToPlot:=StrList[1];
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignacion de la b
              Iter:=0;
              while Iter<=TablaDeVarsStrGrid.RowCount-1 do
              begin
                if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  TemporalRangoBToPlot := TablaDeVarsStrGrid.Cells[1,Iter];
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                  begin
                  TemporalRangoBToPlot:=StrList[2];
                  Break;
                end;
                Iter:=Iter+1;
              end;
              //Asignacion del color
              CmdBox1.Writeln('Se detecto la funcion : plot2d');
              GraphicFrame[GFMaxPosition].PlotFunc(TemporalFuncToPlot,TemporalRangoAToPlot,TemporalRangoBToPlot,StrList[3]);
            end;
            'intersection' : begin
              Chart1.Visible := True;
              //Borrado de comillas ' '
              for Iter:=0 to StrList.Count-1 do
              begin
                StrList[Iter]:=StringReplace(StrList[Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
              end;
              //Asignacion de la funcion dentro del frame
              Iter:=0;
              while Iter<=TablaDeVarsStrGrid.RowCount-1 do
              begin
                if StrList[0]=TablaDeVarsStrGrid.Cells[0,Iter] then
                begin
                  temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                  TemporalFuncToPlot := temporalString;
                  TemporalFmenosG:=TemporalFuncToPlot;
                  Break;
                end
                else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                begin
                  TemporalFuncToPlot:=StrList[0];
                  TemporalFmenosG:=TemporalFuncToPlot;
                  Break;
                end;
                Iter:=Iter+1;
              end;
                //Asignacion de la a de la primera funcion
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    TemporalRangoAToPlot := TablaDeVarsStrGrid.Cells[1,Iter];
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                    TemporalRangoAToPlot:=StrList[2];
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignacion de la b de la primera funcion
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[3]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    TemporalRangoBToPlot := TablaDeVarsStrGrid.Cells[1,Iter];
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                    TemporalRangoBToPlot:=StrList[3];
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                GraphicFrame[GFMaxPosition].PlotFunc(TemporalFuncToPlot,TemporalRangoAToPlot,TemporalRangoBToPlot,StrList[4]);
                ////////////////////////Termino el plot de la primera funcion//////////////////////////////
                //----------------Ahora la segunda funcion--------------------------
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[1]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    temporalString:=StringReplace(TablaDeVarsStrGrid.Cells[1,Iter],'''','',[rfReplaceAll, rfIgnoreCase]);
                    TemporalFuncToPlot := temporalString;
                    TemporalFmenosG:=TemporalFmenosG+'-('+TemporalFuncToPlot+')';
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                    TemporalFuncToPlot:=StrList[1];
                    TemporalFmenosG:=TemporalFmenosG+'-('+TemporalFuncToPlot+')';
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignacion de la a de la segunda funcion
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[2]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    TemporalRangoAToPlot := TablaDeVarsStrGrid.Cells[1,Iter];
                    TemporalA:=TemporalRangoAToPlot;
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                    TemporalRangoAToPlot:=StrList[2];
                    TemporalA:=TemporalRangoAToPlot;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignacion de la b de la segunda funcion
                Iter:=0;
                while Iter<=TablaDeVarsStrGrid.RowCount-1 do
                begin
                  if StrList[3]=TablaDeVarsStrGrid.Cells[0,Iter] then
                  begin
                    TemporalRangoBToPlot := TablaDeVarsStrGrid.Cells[1,Iter];
                    TemporalB:=TemporalRangoBToPlot;
                    Break;
                  end
                  else if Iter = TablaDeVarsStrGrid.RowCount-1 then
                    begin
                    TemporalRangoBToPlot:=StrList[3];
                    TemporalB:=TemporalRangoBToPlot;
                    Break;
                  end;
                  Iter:=Iter+1;
                end;
                //Asignacion del color
                GraphicFrame[GFMaxPosition].PlotFunc(TemporalFuncToPlot,TemporalRangoAToPlot,TemporalRangoBToPlot,StrList[5]);
                ////////////////////////Termino el plot de la segunda funcion//////////////////////////////////
                //Usar TemporalFmenosG ,TemporalA y TemporalB
                //Empieza la ejecucion de falsa posicion para hallar todas las raices de una funcion
                SENLObject:=SENLFunciones.create;
                SENLObjectTemporal:=SENLFunciones.create;

                SENLObject.fx := TemporalFmenosG;
                SENLObject.a := StrToFloat(TemporalA);
                SENLObject.b := StrToFloat(TemporalB);

                FuncToRootTempo:='[';
                IntervalsRoots:=0.1;
                ArootTemp:=SENLObject.a;
                BrootTemp:=SENLObject.b;
                SENLObjectTemporal.fx:=SENLObject.fx;
                SENLObjectTemporal.a:=ArootTemp;
                SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                TemporalRootAns2 := SENLObjectTemporal.Secante();
                while ArootTemp<=SENLObject.b do
                begin
                  SENLObjectTemporal.a:=ArootTemp;
                  SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
                  SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
                  TemporalRootAns := SENLObjectTemporal.Secante();
                  if(TemporalRootAns<>'')and(TemporalRootAns<>TemporalRootAns2) and (
                        (StrToFloat(TemporalRootAns)>=SENLObjectTemporal.a)and
                        (StrToFloat(TemporalRootAns)<=SENLObjectTemporal.b)
                    ) then
                  begin
                    temporalDouble:=StrToFloat(TemporalRootAns);
                    temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
                    TemporalRootAns:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
                    FuncToRootTempo:=FuncToRootTempo+TemporalRootAns;
                    FuncToRootTempo:=FuncToRootTempo+',';
                    TemporalRootAns2:=TemporalRootAns;
                  end;
                  ArootTemp:=ArootTemp+IntervalsRoots;
                end;
                FuncToRootTempo[Length(FuncToRootTempo)]:=']';
                //Ploteo de puntos si te pide todos dentro de un intervalo
                iPos:= Pos( '[', FuncToRootTempo );
                StrListParaRoots.Delimiter:=',' ;
                StrListParaRoots.StrictDelimiter:= true;
                StrListParaRoots.DelimitedText:= Copy( FuncToRootTempo, iPos + 1, Length( FuncToRootTempo ) - iPos - 1  );
                for Iter:=0 to StrListParaRoots.Count-1 do
                begin
                  Parse1.Expression:=TemporalFuncToPlot;
                  Chart1LineSeriesToIntersection.AddXY(StrToFloat(StrListParaRoots[Iter]),f(StrToFloat(StrListParaRoots[Iter])));
                  Chart1LineSeriesToIntersection.ShowPoints := True;
                  Chart1LineSeriesToIntersection.LinePen.Style := psClear;
                end;
                //////////////////////////////////////////////////////////////////
            end;
            'clearplot': begin
              CmdBox1.Writeln('Limpiando');
              Chart1LineSeriesToClickIntesec.Clear;
              Chart1LineSeriesToArea.Clear;
              Chart1LineSeriesToEDO.Clear;
              Chart1LineSeriesToIntegral.Clear;
              Chart1LineSeriesToIntersection.Clear;
              Chart1LineSeriesToRoot.Clear;

              //LineSeries3.Clear;
              AreaSeries3.Clear;

              for Iter := 1 to GFMaxPosition-1 do
              begin
                GraphicFrame[Iter].cleanFrame();
              end;
              Chart1AreaSeries1.Clear;
              //Chart1.Visible := False;
            end;
            'chartRange':begin
              Chart1.Visible := True;
              Chart1.Extent.UseXMin:=True;
              Chart1.Extent.UseXMax:=True;
              Chart1.Extent.UseYMin:=True;
              Chart1.Extent.UseYMax:=True;
              Chart1.Extent.XMin:=-StrToInt(StrList[0]);
              Chart1.Extent.XMax:=StrToInt(StrList[1]);
              Chart1.Extent.YMin:=-StrToInt(StrList[2]);
              Chart1.Extent.YMax:=StrToInt(StrList[3]);
            end;
      end;
    end;
    if (FuncsAuxs.QueTipoEs(Input)<>'Double')and(FuncsAuxs.QueTipoEs(Input)<>'String')and
    (FuncsAuxs.QueTipoEs(Input)<>'List')and(FuncsAuxs.QueTipoEs(Input)<>'Func') then
    //aca es la op de vars
    begin
      Iter:=0;
      while Iter<=TablaDeVarsStrGrid.RowCount-1 do
      begin
        if VariableName=TablaDeVarsStrGrid.Cells[0,Iter] then
        begin
          Parse1.Expression:=Input;
          TablaDeVarsStrGrid.Cells[1,Iter]:=FloatToStr(Parse1.Evaluate()); // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,Iter]:='Double'; // [columnas,filas]
          Parse1.NewValue(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,Iter]));
          Break;
        end
        else if Iter = TablaDeVarsStrGrid.RowCount-1 then
        begin
          TablaDeVarsStrGrid.RowCount:=TablaDeVarsStrGrid.RowCount+1;
          TablaDeVarsStrGrid.Cells[0,TablaDeVarsStrGrid.RowCount-1]:=VariableName; // [columnas,filas]
          Parse1.Expression:=Input;
          TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]:=FloatToStr(Parse1.Evaluate()); // [columnas,filas]
          TablaDeVarsStrGrid.Cells[2,TablaDeVarsStrGrid.RowCount-1]:='Double'; // [columnas,filas]
          Parse1.AddVariable(VariableName,StrToFloat(TablaDeVarsStrGrid.Cells[1,TablaDeVarsStrGrid.RowCount-1]));
          Break;
        end;
        Iter:=Iter+1;
      end;
    end;
  end;
  CmdBox1.StartRead(clBlack,clWhite,'Numerico>',clBlack,clWhite);
  HistoryList.Clear;
  for i:=0 to CmdBox1.HistoryCount-1 do HistoryList.Items.Add(CmdBox1.History[i]);

  except
    CmdBox1.StartRead(clBlack,clWhite,'Numerico>',clBlack,clWhite);
  end;
end;

procedure TForm1.ClearHistoryClick(Sender: TObject);
begin
  CmdBox1.ClearHistory;
  HistoryList.Clear;
end;


procedure TForm1.ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
  APoint: TPoint);
var
  Expression: string;
  DPoint: TDoublePoint;
  FuncToRootTempo, TemporalRootAns2, TemporalRootAns, TemporalFuncToPlot: string;
  IntervalsRoots, ArootTemp, BrootTemp, temporalDouble: Double;
  iPos, temporalDecimales, Iter: Integer;
  StrListParaRoots : TStringList;
begin
  try
  StrListParaRoots:=TStringList.Create;
  Chart1LineSeriesToClickIntesec.Clear;
  CmdBox1.TextColors(clBlack,clWhite);
  //fx1 es la funcion 1  //fx2 es la funcion 2  //fcnt es el contador de funciones clickeadas
  //px1 es el intervalo 1  //px2 es el intervalo 2
   DPoint:= Chart1.ImageToGraph(APoint);
   with ATool as TDataPointClickTool do
   begin
     if Series is TFuncSeries then
     begin
       Expression:= GraphicFrame[TFuncSeries(Series).Tag].EditF.Text;
       if fcnt=0 then
       begin
         fx1:= GraphicFrame[TFuncSeries(Series).Tag].EditF.Text;
         px1:= DPoint.X;
         CmdBox1.Writeln('Funcion 1 a evaluar: '+fx1);
         CmdBox1.Writeln('IntervaloA a evaluar: '+FloatToStr(px1));

         fcnt:= 1;
       end
       else if fcnt=1 then//cuando se hace el 2do click tengo que reasignar la primera funcion
       begin

         fx2:= GraphicFrame[TFuncSeries(Series).Tag].EditF.Text;
         px2:= DPoint.X;

         CmdBox1.Writeln('Funcion 2 a evaluar: '+fx2);
         CmdBox1.Writeln('IntervaloB a evaluar: '+FloatToStr(px2));
         /////////////////////////////////////////////////////////////////////////////////
         SENLObject:=SENLFunciones.create;
         SENLObjectTemporal:=SENLFunciones.create;

         SENLObject.fx := fx1+'-('+fx2+')';
         SENLObject.a := px1;
         SENLObject.b := px2;

         IntervalsRoots:=0.01;
         ArootTemp:=SENLObject.a;
         BrootTemp:=SENLObject.b;
         SENLObjectTemporal.fx:=SENLObject.fx;
         SENLObjectTemporal.a:=ArootTemp;
         SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
         SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
         TemporalRootAns2 := SENLObjectTemporal.Biseccion();
         while ArootTemp<=SENLObject.b do
         begin
           SENLObjectTemporal.a:=ArootTemp;
           SENLObjectTemporal.b:=ArootTemp+IntervalsRoots;
           SENLObjectTemporal.ErrorAllowed := StrToFloat(TablaDeVarsStrGrid.Cells[1,1]);
           TemporalRootAns := SENLObjectTemporal.Biseccion();
           if(TemporalRootAns<>'')and(TemporalRootAns<>TemporalRootAns2) then
           begin
             temporalDouble:=StrToFloat(TemporalRootAns);
             temporalDecimales:=StrToInt(TablaDeVarsStrGrid.Cells[1,2]);
             TemporalRootAns:=FloatToStrF(temporalDouble,ffFixed,11,temporalDecimales);
             FuncToRootTempo:=FuncToRootTempo+TemporalRootAns;
             FuncToRootTempo:=FuncToRootTempo+',';
             TemporalRootAns2:=TemporalRootAns;
           end;
           ArootTemp:=ArootTemp+IntervalsRoots;
         end;
         FuncToRootTempo[Length(FuncToRootTempo)]:=']';
         //-------------------Ploteo de puntos-----------------------
         iPos:= Pos( '[', FuncToRootTempo );
         StrListParaRoots.Delimiter:=',' ;
         StrListParaRoots.StrictDelimiter:= true;
         StrListParaRoots.DelimitedText:= Copy( FuncToRootTempo, iPos + 1, Length( FuncToRootTempo ) - iPos - 1  );

         for Iter:=0 to StrListParaRoots.Count-1 do
         begin
           Parse1.Expression:=fx1;
           Chart1LineSeriesToClickIntesec.AddXY(StrToFloat(StrListParaRoots[Iter]),f(StrToFloat(StrListParaRoots[Iter])));
           Chart1LineSeriesToClickIntesec.ShowPoints := True;
           Chart1LineSeriesToClickIntesec.LinePen.Style := psClear;
         end;
         //////////////////////////////////////////////////////////////////
         //Se calculo las intersecciones
         fcnt:= 0;
       end;
     end;
   end;
  except
    fcnt:= 0;
    CmdBox1.StartRead(clBlack,clWhite,'Numerico>',clBlack,clWhite);
  end;
end;


end.

