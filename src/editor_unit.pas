{    --- EDITOR_UNIT.PAS

     --- CRT_SNAKE LEVEL EDITOR ---

console arcade game on Free Pascal
using CRT unit

Level editor unit }

UNIT Editor_Unit;


INTERFACE


Uses
  CRT,Snake_Base,Snake_File;

TYPE

{
  editor drawing/erasing mode
  modeWall  : drawing bricks during cursor moving;
  modeErase : drawing empty space during cursor moving

  all modes off: pressing Space bar changed cell under cursor
}

EditorMode=record
  Modified,Wall,Erase : boolean
end;


CONST

{ editor colors }

edcol_MainBG=Black;
edcol_MainText=LightGray;
edcol_HelpText=White;
edcol_MenuBG=LightCyan;
edcol_MenuUnactive=DarkGray;
edcol_MenuUnsel=White;
edcol_MenuSel=Yellow;

edcol_WarnBG=Yellow;
edcol_Warn=Red;

edcol_HintLineText=Yellow;

edcol_FieldBrick=Red;

edcol_FieldCursor=LightBlue;

edcol_StLineActive=Magenta;
edcol_StLineUnactive=LightGray;

edcol_YesNoBG=LightRed;
edcol_YesNoMsgText=LightCyan;
edcol_YesNoUnsel=Brown;
edcol_YesNoSel=Yellow;

{ screen objects coordinates }

DrawingDelay=20;

{ procedures and functions }

Function EvalStatusLinePoint(FieldLeftTop:Point):Point;

Function Cell2String(s:CellValue):CellString;

Procedure WriteFullStatusLine
    (var lf:LevelFile; StLineStart,CursorPos:Point; Mode:EditorMode);

Procedure WarningAnimation;

Procedure ShowHelpScreen(LeftTop:Point);

Procedure SwitchModes(var Mode:EditorMode);

Procedure DrawLevel(var A:GameField; LeftTop:Point);

Procedure DrawOneCell
    (var A:GameField; LeftTop,CellPos:Point; Selected:Boolean);

Procedure MoveCursor
    (var A:GameField; var CursorPos:Point;
         Mode:EditorMode;LeftTop:Point; Dir:MovingDir);

Function GetCellValue(OldValue:CellValue;Mode:EditorMode):CellValue;

Procedure ChangeCellUnderCursor
     (var A:GameField; LeftTop,CursorPos:Point);


IMPLEMENTATION


{ initialization procedures and functions }

Function EvalStatusLinePoint(FieldLeftTop:Point):Point;
var
  tmp:Point;
begin
  tmp.Col:=FieldLeftTop.Col+1;
  tmp.Row:=FieldLeftTop.Row+FieldHeight+1;
  EvalStatusLinePoint:=tmp;
end;

{ --- StatusLine procedures --- }

Procedure WriteCursorCoords(CursorPos:Point);
begin
  inc(CursorPos.Col);
  inc(CursorPos.Row);
  TextBackground(edcol_MainBG);
  TextColor(edcol_StLineActive);
  Write(CursorPos.Col:2,' :',CursorPos.Row:2);
  TextColor(edcol_StLineUnactive);
  Write(' || ')
end;

{ --- }

Procedure WriteEditorMode(Mode:EditorMode);
const
  sign_NoModified='-------- ';
  sign_Modified  ='MODIFIED ';
  sign_Wall = ' WALL ';
  sign_Erase= 'ERASE ';
  sign_Manual='MANUAL';
begin
  if Mode.Modified then
  begin
    TextColor(edcol_StLineActive);
    Write(sign_Modified);
  end
  else
  begin
    TextColor(edcol_StLineUnactive);
    Write(sign_NoModified);
  end;

  TextColor(edcol_StLineUnactive);
  Write('| mode- ');

  TextColor(edcol_StLineActive);
  if Mode.Wall then
    Write(sign_Wall)
  else
  if Mode.Erase then
    Write(sign_Erase)
  else
    Write(sign_Manual);

end;

{ --- }

Procedure WriteFileInfo(var lf:LevelFile);
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_StLineUnactive);
  Write('|| levels: CURRENT-');
  TextColor(edcol_StLineActive);
  Write(FilePos(lf):2);
  TextColor(edcol_StLineUnactive);
  Write(' ALL-');
  TextColor(edcol_StLineActive);
  Write(FileSize(lf):2,#32);
end;

{ --- }

Procedure WriteFullStatusLine
        (var lf:LevelFile; StLineStart,CursorPos:Point; Mode:EditorMode);
begin
  GotoXY(StLineStart.Col,StLineStart.Row);
  WriteCursorCoords(CursorPos);
  WriteEditorMode(Mode);
  WriteFileInfo(lf);
  CursorOut;
end;

{ animation in screen bottom - if action is impossible }

Procedure WarningAnimation;
const
  AnimationDelay=5;
  PauseDelay=50;
var
  i:Word;
begin
  TextBackground(edcol_WarnBG);
  TextColor(edcol_Warn);
  GotoXY(1,ScreenHeight);
  for i:=1 to ScreenWidth-1 do
  begin
    Write('>');
    Delay(AnimationDelay);
  end;
  Delay(PauseDelay);
end;

{ --- HELP screen --- }

Procedure ShowHelpScreen(LeftTop:Point);
begin
  TextColor(edcol_FieldBrick);
  DrawFieldBorder(LeftTop);

  TextBackground(edcol_MainBG);
  TextColor(edcol_HelpText);
  ClearRect(LeftTop, FieldWidth*CellWidth+1, FieldHeight);
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('   CRT_SNAKE level editor - HELP screen');

  LeftTop.Row:=LeftTop.Row+1;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('------------------------------------------');

  LeftTop.Row:=LeftTop.Row+2;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('ARROW KEYS - moving cursor ');

  LeftTop.Row:=LeftTop.Row+2;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('TAB - switch draw modes:');

  LeftTop.Row:=LeftTop.Row+1;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('---------------------------');

  LeftTop.Row:=LeftTop.Row+1;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('DRAW mode - draws bricks');

  LeftTop.Row:=LeftTop.Row+1;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('ERASE mode - erases all');

  LeftTop.Row:=LeftTop.Row+1;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('MANUAL mode - drawing brick/empty space on pressing SPACE BAR');

  LeftTop.Row:=LeftTop.Row+2;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('ESC - enter to EDITOR MENU');

  LeftTop.Row:=LeftTop.Row+2;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('ARROW KEYS - moving cursor ');

 { LeftTop.Row:=LeftTop.Row+2;
  GotoXY(LeftTop.Col,LeftTop.Row);
  Write('Press any key to continue...');}

  CursorOut;
  repeat
  until KeyPressed;
end;

{swithing modes WALL on ERASE off >> WALL off ERASE on >> all off >> ...}

Procedure SwitchModes(var Mode:EditorMode);
begin
  with Mode do
  begin
    if Wall then
    begin
      Wall:= false ; Erase := true ;
    end
    else if Erase then
      Erase := false
    else
      Wall := true;
  end;
end;

{ --- }

Function Cell2String(s:CellValue):CellString;
begin
  if s=clEmpty then Cell2String:=imgEmpty;
  if s=clBrick then Cell2String:=imgBrick;
end;

{ fast drawing level after loading }

Procedure DrawLevel(var A:GameField;LeftTop:Point);
var
  i,j:Word;
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_MainText);
  for i:=0 to FieldHeight do
  begin
    GotoXY(LeftTop.Col,LeftTop.Row+i);
    for j:=0 to FieldWidth do
    begin
      if A[j,i]=clBrick then
        TextColor(edcol_FieldBrick)
      else
        TextColor(edcol_MainText);
      Write(Cell2String(A[j,i]));
    end;
{$ifdef DEBUG}
    Delay(DrawingDelay);
{$endif}
  end;
end;

{ drawing one cell during level editing }

Procedure DrawOneCell
         (var A:GameField;LeftTop,CellPos:Point ; Selected:Boolean);
var
  AbsolutePos:Point;
begin
  if Selected then
    TextBackground(edcol_FieldCursor)
  else
    TextBackground(edcol_MainBG);
  if A[CellPos.Col,CellPos.Row]=clEmpty then
    TextColor(edcol_MainText)
  else
    TextColor(edcol_FieldBrick);
  AbsolutePos.Col:=AbsCol(LeftTop,CellPos.Col);
  AbsolutePos.Row:=AbsRow(LeftTop,CellPos.Row);
  GotoXY(AbsolutePos.Col,AbsolutePos.Row);
  Write(Cell2String(A[CellPos.Col,CellPos.Row]));
end;

{ getting cell value depending on editor mode }

Function GetCellValue(OldValue:CellValue;Mode:EditorMode):CellValue;
begin
  if Mode.Wall then
    GetCellValue:=clBrick
  else
  if Mode.Erase then
    GetCellValue:=clEmpty
  else
    GetCellValue:=OldValue;
end;

{moving cursor, drawing in depending on editor mode}

Procedure MoveCursor
    (var A:GameField; var CursorPos:Point;
         Mode:EditorMode;LeftTop:Point; Dir:MovingDir);
var
  NewPos:Point;
begin
  DrawOneCell(A,LeftTop,CursorPos,false);
  with NewPos do begin
    Col := CursorPos.Col + Dir.move_LR;
    Row := CursorPos.Row + Dir.move_UD;
  end;
  A[NewPos.Col,NewPos.Row]:=GetCellValue(A[NewPos.Col,NewPos.Row],Mode);
  CursorPos:=NewPos;
  DrawOneCell(A,LeftTop,CursorPos,true);
end;

{ changing cell under cursor after SPACE BAR pressing }

Procedure ChangeCellUnderCursor
     (var A:GameField; LeftTop,CursorPos:Point);
begin
  if A[CursorPos.Col,CursorPos.Row]=clBrick then
    A[CursorPos.Col,CursorPos.Row]:=clEmpty
  else
    A[CursorPos.Col,CursorPos.Row]:=clBrick;
  DrawOneCell(A,LeftTop,CursorPos,true);
end;

{ --- *** --- }

END.
