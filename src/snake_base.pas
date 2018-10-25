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

  Point=record
    Col,Row:Word
  end;

  { direction of moving cursor etc... }

  MovingDir = record
    move_UD,move_LR:Integer
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
                    mnuEdAddToEnd,     { EDITOR - add an empty lvl to the end }
                    mnuEdClearCurrent, { EDITOR - clear current level }
                    mnuEdSave,         { EDITOR - save level : replace }
                    mnuEdDelete,       { EDITOR - delete level }
                    mnuEdMovForward,   { EDITOR - move level : forward }
                    mnuEdMovBackward); { EDITOR - move level : backward }


CONST

  move_Left  : MovingDir = (move_UD: 0 ; move_LR:-1);
  move_Right : MovingDir = (move_UD: 0 ; move_LR: 1);
  move_Up    : MovingDir = (move_UD:-1 ; move_LR: 0);
  move_Down  : MovingDir = (move_UD: 1 ; move_LR: 0);


{ PROCEDURES AND FUNCTIONS }

{ filling string with SPACE BAR symbols }

Procedure FillString(EndPoint:Word);

{ clearing rectangle screen area }

Procedure ClearRect(LeftTop:Point;DCol,DRow:Word);

{ moving cursor into screen angle }

Procedure CursorOut;

{ evaluating point of object drawing - middle of screen (in symbols) }

Function EvalMiddlePosLeftTop(ObjWidth,ObjHeight:Word):Point;

{ drawing game field border  }

Procedure DrawFieldBorder(LeftTop:Point);

{ evaluating cell's absolute screen position  }

Function AbsCol(LeftTop:Point; HPos:Word):Word;
Function AbsRow(LeftTop:Point; VPos:Word):Word;

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

Procedure ClearRect(LeftTop:Point;DCol,DRow:Word);
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

Function EvalMiddlePosLeftTop(ObjWidth,ObjHeight:Word):Point;
var
  tmp:Point;
begin
  tmp.Col:=( ScreenWidth - ObjWidth ) div 2;
  tmp.Row:=(( ScreenHeight - ObjHeight) div 2) + 1;
  EvalMiddlePosLeftTop:=tmp;
end;

{ --- }

Procedure DrawFieldBorder(LeftTop:Point);
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

Function AbsCol(LeftTop:Point; HPos:Word):Word;
begin
  AbsCol:=LeftTop.Col + HPos*CellWidth;
end;

{ --- }

Function AbsRow(LeftTop:Point; VPos:Word):Word;
begin
  AbsRow:=LeftTop.Row + VPos;
end;

{ --- --- --- --- --- }

END.
