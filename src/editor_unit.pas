{    --- EDITOR_UNIT.PAS

     --- CRT_SNAKE LEVEL EDITOR ---

console arcade game on Free Pascal
using CRT unit

Level editor unit }

UNIT Editor_Unit;


INTERFACE


Uses
  CRT,Snake_draw;

{ $I crt_snake.inc}

const


{ editor colors }

edcol_MainBG=Black;
edcol_MainText=LightGray;

edcol_MenuBG=LightCyan;
edcol_MenuUnactive=DarkGray;
edcol_MenuUnSelItem=White;
edcol_MenuSelItem=Yellow;

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

{ hint lines }

MainHintLine  =
  ' | ARROWS - move cursor | SPACE - draw/erase brick | ESC - editor menu |  ';
MenuHintLine  =
  ' EDITOR MENU || LEFT/RIGHT - move cursor | ENTER - select | ESC - resume |';
YesNoHintLine =
  ' UP / DOWN - change || ENTER - select ';

{ screen objects coordinates }

StatusLinePos : ScrPos = (Col : 7 ; Row : 23);
DrawingDelay=50;


{ procedures and functions }

Procedure CreateEmptyLevel(var A:GameField);

Procedure WriteHintLine(HintString:String);

Function Cell2String(s:CellValue):CellString;

Procedure DrawLevel(var A:GameField);

Procedure WriteStatusLine(CursorPos:ScrPos;Changed:Boolean);

Procedure DrawOneCell(var A:GameField; CellPos:ScrPos ; Selected:Boolean);

Procedure MoveCursor(var A:GameField;var CursorPos:ScrPos;
                     ColDir,RowDir:Integer);

Procedure ChangeCellUnderCursor(var A:GameField ; CursorPos:ScrPos);


IMPLEMENTATION


Procedure CreateEmptyLevel(var A:GameField);
var
  i,j:Word;
begin
  for i:=0 to FieldWidth do
   for j:=0 to FieldHeight do
     A[i,j]:=clEmpty;
end;

Procedure WriteHintLine(HintString:String);
var
  i:Word;
begin
  TextBackground(edcol_HintLineBG);
  TextColor(edcol_HintLineText);
  GotoXY(1,ScreenHeight);
  Write(HintString);
  for i:=WhereX to ScreenWidth-1 do
    Write(#32);
  CursorOut;
end;

Function Cell2String(s:CellValue):CellString;
begin
  if s=clEmpty then Cell2String:=imgEmpty;
  if s=clBrick then Cell2String:=imgBrick;
end;

Procedure DrawLevel(var A:GameField);
var
  i,j:Word;
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_MainText);
  for i:=0 to FieldHeight do
  begin
    GotoXY(Field_LeftUp.Col,Field_LeftUp.Row+i);
    for j:=0 to FieldWidth do
    begin
      if A[j,i]=clBrick then
        TextColor(edcol_FieldBrick)
      else
        TextColor(edcol_MainText);
      Write(Cell2String(A[j,i]));
    end;
    Delay(DrawingDelay);
  end;
end;

Procedure WriteStatusLine(CursorPos:ScrPos;Changed:Boolean);
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_StLineActive);
  GotoXY(StatusLinePos.Col,StatusLinePos.Row);
  Write(CursorPos.Col:3,' : ',CursorPos.Row:3);
  if Changed then
    Write('   changed   ')
  else
  begin
    TextColor(edcol_StLineUnactive);
    Write(' not changed ');
  end;

end;

Procedure DrawOneCell(var A:GameField; CellPos:ScrPos ; Selected:Boolean);
var
  AbsPos:ScrPos;
begin
  if Selected then
    TextBackground(edcol_FieldCursor)
  else
    TextBackground(edcol_MainBG);
  if A[CellPos.Col,CellPos.Row]=clEmpty then
    TextColor(edcol_MainText)
  else
    TextColor(edcol_FieldBrick);
  AbsPos.Col:=ScreenCol(CellPos.Col);
  AbsPos.Row:=ScreenRow(CellPos.Row);
  GotoXY(AbsPos.Col,AbsPos.Row);
  Write(Cell2String(A[CellPos.Col,CellPos.Row]));
end;

Procedure MoveCursor(var A:GameField; var CursorPos:ScrPos;
                     ColDir,RowDir:Integer);
begin
  DrawOneCell(A,CursorPos,false);
  CursorPos.Col:=CursorPos.Col+ColDir;
  CursorPos.Row:=CursorPos.Row+RowDir;
  DrawOneCell(A,CursorPos,true);
end;

Procedure ChangeCellUnderCursor(var A:GameField;CursorPos:ScrPos);
begin
  if A[CursorPos.Col,CursorPos.Row]=clBrick then
    A[CursorPos.Col,CursorPos.Row]:=clEmpty
  else
    A[CursorPos.Col,CursorPos.Row]:=clBrick;
  DrawOneCell(A,CursorPos,true);
end;


{ --- *** --- }

END.
