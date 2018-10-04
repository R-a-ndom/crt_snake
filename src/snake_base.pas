{
     --- SNAKE_DRAW.PAS

     --- CRT_SNAKE ---
console arcade game on free Pascal
using CRT unit

game objects drawing unit

}

unit Snake_Base;


INTERFACE


USES
  CRT;

CONST

  { game field size - 30 * 20 }

  FieldWidth=31;
  FieldHeight=19;

  { one cell size in symbols }

  CellWidth=2;

  { keyboard codes }

  kbdLeft  = #75;
  kbdRight = #77;
  kbdUp    = #72;
  kbdDown  = #80;

  kbdF1    = #59;
  kbdESC   = #27;
  kbdTAB   = #9;
  kbdSPACE = #32;
  kbdENTER = #13;

  { game pbject strings }

  imgEmpty = '::';
  imgBrick = '[]';
  imgFruit = 'GO';
  imgCoin  = '$$';
  imgBody  = '<>';
  imgHead  = '@@';

  { level on disk size }

  LevelSizeOnDisk = 20;

TYPE

{ field cell values }

  CellValue = ( clEmpty,  {empty cell}
                clBrick,  {brick cell}
                clFriut,  {friut - for growing}
                clCoin,   {coin - for score}
                clBody,   {snake's body}
                clHead ); {snake's head}

  { game field array }

  GameField = array[0..FieldWidth,0..FieldHeight] of CellValue;

  { level recorded in file }

  LevelRow = LongWord;

  SnakeLevel = array[1..LevelSizeOnDisk] of LevelRow;

 { rectangle screen coordinate }

  ScrPos=record
    Col,Row:Word
  end;

  { string - game object }

  CellString=string[CellWidth];
{
  CellPattern=record
    SymColor: Byte;
    Image:CellString
  end;
}
  { menu selection items }

  MenuSelection = ( mnuBeginGame,      { MAIN - begin game }
                    mnuShowHighScore,  { MAIN - show high score screen }
                    mnuResume,         { PAUSE,EDITOR - resume game/editing }
                    mnuConfirm,        { ALL - confirm }
                    mnuCancel,         { ALL - cancel }
                    mnuShowHelpScreen, { ALL - show help screen }
                    mnuResumeNeedReset,{ ALL - need reset editor screen }
                    mnuExitToMainMenu, { PAUSE - exit to main menu}
                    mnuExitRequest,    { ALL - exit}
                    mnuEdNavForward,   { EDITOR - navigation : forward }
                    mnuEdNavBackward,  { EDITOR - navigation : backward }
                    mnuEdAddToEnd,     { EDITOR - add an empty level to the end }
                    mnuEdSave,         { EDITOR - save level : replace }
                    mnuEdDelete,       { EDITOR - delete level }
                    mnuEdMovForward,   { EDITOR - move level : forward }
                    mnuEdMovBackward); { EDITOR - move level : backward }

{ PROCEDURES AND FUNCTIONS }

{ filling string with SPACE BAR symbols }

Procedure FillString(EndPoint:Word);

{ clearing rectangle screen area }

Procedure ClearRect(LeftTop:ScrPos;DCol,DRow:Word);

{ moving cursor into screen angle }

Procedure CursorOut;

{ evaluating point of object drawing - middle of screen (in symbols) }

Function EvalMiddlePosLeftTop(ObjWidth,ObjHeight:Word):ScrPos;

{ drawing game field border  }

Procedure DrawFieldBorder(LeftTop:ScrPos);

{ evaluating cell's absolute screen position  }

Function AbsCol(LeftTop:ScrPos; HPos:Word):Word;
Function AbsRow(LeftTop:ScrPos; VPos:Word):Word;

{ creating an empty level array }


IMPLEMENTATION


Procedure FillString(EndPoint:Word);
var
  i:Word;
begin
  i:=WhereX;
  While i<=EndPoint do
  begin
    Write(#32);
    inc(i);
  end;
end;

{ --- }

Procedure ClearRect(LeftTop:ScrPos;DCol,DRow:Word);
var
  i:Integer;
begin
  GotoXY(LeftTop.Col,LeftTop.Row);
  for i:=LeftTop.Row to LeftTop.Row+DRow do
  begin
    GotoXY(LeftTop.Col,i);
    FillString(LeftTop.Col+DCol);
  end;
end;

{ --- }

Procedure CursorOut;
begin
  GotoXY(ScreenWidth,1);
end;

{ --- }

Function EvalMiddlePosLeftTop(ObjWidth,ObjHeight:Word):ScrPos;
var
  tmp:ScrPos;
begin
  tmp.Col:=( ScreenWidth - ObjWidth ) div 2;
  tmp.Row:=(( ScreenHeight - ObjHeight) div 2) + 1;
  EvalMiddlePosLeftTop:=tmp;
end;

{ --- }

Procedure DrawFieldBorder(LeftTop:ScrPos);
var
  i:Integer;
begin
  GotoXY(LeftTop.Col - CellWidth,LeftTop.Row - 1);
  for i:=0 to FieldWidth + 2 do
    Write(imgBrick);

  for i:=0 to FieldHeight do
  begin
    GotoXY(LeftTop.Col - CellWidth,LeftTop.Row + i);
    Write(imgBrick);
    GotoXY(LeftTop.Col + (FieldWidth + 1)*CellWidth , LeftTop.Row + i);
    Write(imgBrick);
  end;

  GotoXY(LeftTop.Col - CellWidth,LeftTop.Row+FieldHeight+1);
  for i:=0 to FieldWidth + 2 do
    Write(imgBrick);
end;

{ --- }

Function AbsCol(LeftTop:ScrPos; HPos:Word):Word;
begin
  AbsCol:=LeftTop.Col + HPos*CellWidth;
end;

{ --- }

Function AbsRow(LeftTop:ScrPos; VPos:Word):Word;
begin
  AbsRow:=LeftTop.Row + VPos;
end;

{ --- --- --- --- --- }

END.
