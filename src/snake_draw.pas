{
     ---SNAKE_DRAW.PAS

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
  CellWidth=2;

TYPE

  CellString=string[CellWidth];

  CellPattern=record
    SymColor: Byte;
    Image:CellString
  end;

CONST
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

  Field_LeftUp:ScrPos=( Col : 6 ; Row : 3 );

{
  procedures and functions
}

Procedure CursorOut;

Procedure DrawFieldBorder;

Function ScreenCol(HPos:Word):Word;

Function ScreenRow(VPos:Word):Word;

IMPLEMENTATION

Procedure CursorOut;
begin
  GotoXY(1,ScreenHeight);
end;

Procedure DrawFieldBorder;
var
  i:Integer;
begin
  GotoXY(Field_LeftUp.Col - CellWidth,Field_LeftUp.Row - 1);
  for i:=0 to FieldWidth + 2 do
    Write(imgBrick);

  for i:=0 to FieldHeight do
  begin
    GotoXY(Field_LeftUp.Col - CellWidth,Field_LeftUp.Row + i);
    Write(imgBrick);
    GotoXY(Field_LeftUp.Col + (FieldWidth + 1)*CellWidth , Field_LeftUp.Row + i);
    Write(imgBrick);
  end;

  GotoXY(Field_LeftUp.Col - CellWidth,Field_LeftUp.Row+FieldHeight+1);
  for i:=0 to FieldWidth + 2 do
    Write(imgBrick);
end;

Function ScreenCol(HPos:Word):Word;
begin
  ScreenCol:=Field_LeftUp.Col + HPos*CellWidth;
end;

Function ScreenRow(VPos:Word):Word;
begin
  ScreenRow:=Field_LeftUp.Row + VPos;
end;

END.
