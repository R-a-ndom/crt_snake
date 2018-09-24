{    --- EDITOR_UNIT.PAS

     --- CRT_SNAKE LEVEL EDITOR ---

console arcade game on Free Pascal
using CRT unit

Level editor unit }

UNIT Editor_Unit;


INTERFACE


Uses
  CRT,Snake_draw;

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

edcol_MenuBG=LightCyan;
edcol_MenuUnactive=DarkGray;
edcol_MenuUnsel=White;
edcol_MenuSel=Yellow;

edcol_HintLineBG=Black;
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

Function EvalStatusLinePoint(FieldLeftTop:ScrPos):ScrPos;

Procedure CreateEmptyLevel(var A:GameField);

Function Cell2String(s:CellValue):CellString;

Procedure WriteFullStatusLine
    (var lf:LevelFile; StLineStart,CursorPos:ScrPos; Mode:EditorMode);

Procedure SwitchModes(var Mode:EditorMode);

Procedure DrawLevel(var A:GameField; LeftTop:ScrPos);

Procedure DrawOneCell
    (var A:GameField; LeftTop,CellPos:ScrPos; Selected:Boolean);

Procedure MoveCursor
         (var A:GameField; var CursorPos:ScrPos;
          LeftTop:ScrPos; ColDir,RowDir:Integer);

Procedure ChangeCellUnderCursor(var A:GameField; LeftTop,CursorPos:ScrPos);


IMPLEMENTATION


{ initialization procedures and functions }

Function EvalStatusLinePoint(FieldLeftTop:ScrPos):ScrPos;
var
  tmp:ScrPos;
begin
  tmp.Col:=FieldLeftTop.Col+2;
  tmp.Row:=FieldLeftTop.Row+FieldHeight+1;
  EvalStatusLinePoint:=tmp;
end;

{ --- }

Procedure CreateEmptyLevel(var A:GameField);
var
  i,j:Word;
begin
  for i:=0 to FieldWidth do
   for j:=0 to FieldHeight do
     A[i,j]:=clEmpty;
end;

{ --- StatusLine procedures --- }

Procedure WriteCursorCoords(CursorPos:ScrPos);
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_StLineActive);
  Write(CursorPos.Col:3,' : ',CursorPos.Row:3);
end;

{ --- }

Procedure WriteEditorMode(Mode:EditorMode);
const
  sign_NoModified='| not mod |';
  sign_Modified  ='|   MOD   |';
  sign_Wall = ' WALL  ';
  sign_Erase= ' ERASE ';
begin
  if Mode.Modified then
  begin
    TextColor(edcol_StLineUnactive);
    Write(sign_NoModified);
  end
  else
  begin
    TextColor(edcol_StLineActive);
    Write(sign_Modified);
  end;

  if Mode.Wall then
    TextColor(edcol_StLineActive)
  else
    TextColor(edcol_StLineUnactive);
  Write(sign_Wall);

  if Mode.Erase then
    TextColor(edcol_StLineActive)
  else
    TextColor(edcol_StLineUnactive);
  Write(sign_Erase);
end;

{ --- }

Procedure WriteFileInfo(var lf:LevelFile);
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_StLineUnactive);
  Write(' Current : ');
  TextColor(edcol_StLineActive);
  Write(FilePos(lf):2);
  TextColor(edcol_StLineUnactive);
  Write(' | All : ');
  TextColor(edcol_StLineActive);
  Write(FileSize(lf):2,#32);
end;

{ --- }

Procedure WriteFullStatusLine
        (var lf:LevelFile; StLineStart,CursorPos:ScrPos; Mode:EditorMode);
begin
  GotoXY(StLineStart.Col,StLineStart.Row);
  WriteCursorCoords(CursorPos);
  WriteEditorMode(Mode);
  WriteFileInfo(lf);
  CursorOut;
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

Procedure DrawLevel(var A:GameField;LeftTop:ScrPos);
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

Procedure DrawOneCell(var A:GameField;
                   LeftTop,CellPos:ScrPos ; Selected:Boolean);
var
  AbsolutePos:ScrPos;
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

{ moving cursor during level editing }

Procedure MoveCursor
         (var A:GameField; var CursorPos:ScrPos;
          LeftTop:ScrPos; ColDir,RowDir:Integer);
begin
  DrawOneCell(A,LeftTop,CursorPos,false);
  CursorPos.Col:=CursorPos.Col+ColDir;
  CursorPos.Row:=CursorPos.Row+RowDir;
  DrawOneCell(A,LeftTop,CursorPos,true);
end;

{ change cell under cursor under SPACE BAR pressing  }

Procedure ChangeCellUnderCursor(var A:GameField;LeftTop,CursorPos:ScrPos);
begin
  if A[CursorPos.Col,CursorPos.Row]=clBrick then
    A[CursorPos.Col,CursorPos.Row]:=clEmpty
  else
    A[CursorPos.Col,CursorPos.Row]:=clBrick;
  DrawOneCell(A,LeftTop,CursorPos,true);
end;

{ --- *** --- }

END.
