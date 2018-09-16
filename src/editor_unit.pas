{    --- EDITOR_UNIT.PAS

     --- CRT_SNAKE LEVEL EDITOR ---

console arcade game on Free Pascal
using CRT unit

Level editor uni }

UNIT Editor_Unit;


INTERFACE


Uses
  CRT,Snake_draw;

const

StatusString=
  '  | ARROWS - move cursor | SPACE - draw/erase brick | ESC - editor menu |';

{ procedures and functions }

Procedure CreateEmptyLevel(var A:GameField);

Procedure WriteStatusLine;

Function Cell2String(s:CellValue):CellString;

Procedure DrawLevel(var A:GameField);

Procedure DrawOneCell(var A:GameField; CellPos:ScrPos ; Selected:Boolean);

Procedure MoveCursor(var A:GameField; CursorPos:ScrPos; ColDir,RowDir:Integer);


IMPLEMENTATION


Procedure CreateEmptyLevel(var A:GameField);
var
  i,j:Word;
begin
  for i:=0 to FieldHeight do
   for j:=0 to FieldWidth do
     A[i,j]:=clEmpty;
end;

Procedure WriteStatusLine;
begin
  TextColor(White);
  GotoXY(1,1);
  Write(StatusString);
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
  TextBackground(Black);
  TextColor(LightGray);
  for i:=0 to FieldHeight do 
  begin
    GotoXY(Field_LeftUp.Col,Field_LeftUp.Row+i);
    for j:=0 to FieldWidth do
      Write(Cell2String(A[i,j]));
  end;
end;

Procedure DrawOneCell(var A:gameField; CellPos:ScrPos ; Selected:Boolean);
begin
  if Selected then
    TextBackground(LightGreen)
  else
    TextBackground(Black);
  GotoXY(ScreenCol(CellPos.Col),ScreenRow(CellPos.Row));
  Write(Cell2String(A[CellPos.Col,CellPos.Row]));
end;

Procedure MoveCursor(var A:GameField; CursorPos:ScrPos; ColDir,RowDir:Integer);
begin
  DrawOneCell(A,CursorPos,false);
  CursorPos.Col:=CursorPos.Col+ColDir;
  CursorPos.Row:=CursorPos.Row+RowDir;
  DrawOneCell(A,CursorPos,true);
end;

END.
