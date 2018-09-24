{
     --- SNAKE_DRAW.PAS

     --- CRT_SNAKE ---
console arcade game on free Pascal
using CRT unit

game objects drawing unit

}

unit Snake_Draw;

INTERFACE

USES
  CRT;

{$I crt_snake.inc}

CONST

{ one cell size in symbols }

  CellWidth=2;

TYPE

{ decart screen position }

  ScrPos=record
    Col,Row:Word
  end;

  ScreenParams=record
{$ifdef EDITOR}
    FieldLeftTop,StLineStart,YesNoMsgLeftTop:ScrPos
{$else}
    FieldLeftTop,YesNoMsgLeftTop:ScrPos
{$endif}
  end;

  CellString=string[CellWidth];

  CellPattern=record
    SymColor: Byte;
    Image:CellString
  end;

CONST

{ Windows CMD screen size }

{$ifdef WINCMD}
  ScreenWidth=80;
  ScreenHeight=25;
{$endif}

  imgEmpty = '::';
  imgBrick = '[]';
  imgFruit = 'OO';
  imgCoin  = '$$';
  imgBody  = '<>';
  imgHead  = '@@';

  pattEmpty : CellPAttern = (SymColor : DarkGray; Image : imgEmpty);
  pattBrick : CellPAttern = (SymColor : White;    Image : imgBrick);
  pattFruit : CellPAttern = (SymColor : Red;      Image : imgFruit);
  pattCoin  : CellPAttern = (SymColor : Yellow;   Image : imgCoin);
  pattBody  : CellPAttern = (SymColor : Magenta;  Image : imgBody);
  pattHead  : CellPAttern = (SymColor : Magenta;  Image : imgHead);

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
  tmp.Row:=( ScreenHeight - ObjHeight) div 2;
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
