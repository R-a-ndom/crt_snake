{   --- CRT_SNAKE LEVEL EDITOR
    --- EDITOR_FILE.PAS

  level file manipulations -
  creating, deleting, moving etc...

  (c) Alexey Sorokin,  2018
}

UNIT Snake_File;


INTERFACE


Uses
  Snake_Base;

TYPE

  LevelFile = file of SnakeLevel;

{ --- procedures and functions --- }

Procedure CreateEmptyLevel(var A:SnakeLevel);

Procedure CreateNewFile(var lf:LevelFile);

Procedure CompressLevel(var Field:GameField;var Level:SnakeLevel);

Procedure DecompressLevel(var Level:SnakeLevel;var Field:GameField);

Procedure AddEmptyLevel(var lf:LevelFile;CurrentPos:Word);

Procedure SaveLevel(var lf:LevelFile;var A:GameField);

Procedure LoadLevel(var lf:LevelFile;var A:GameField);


IMPLEMENTATION


Procedure CreateEmptyLevel(var A:SnakeLevel);
var
  i:Word;
begin
  for i:=1 to LevelSizeOnDisk do
    A[i]:=0;
end;

{ --- }

Procedure CreateNewFile(var lf:LevelFile);
var
  A:SnakeLevel;
begin
{$I-}
  ReWrite(lf);
  CreateEmptyLevel(A);
  Write(lf,A);
{$I+}
end;

{ compress field array into level array  }

Function GetMask(A:CellValue):LevelRow;
begin
  if A=clBrick then
    GetMask:=1
  else
    GetMask:=0;
end;

Procedure CompressLevel(var Field:GameField;var Level:SnakeLevel);
var
  i,j:Word;
  LevelRowValue:LevelRow;
begin
  for i:=0 to FieldHeight do
  begin
    LevelRowValue:=0;
    For j:=0 to FieldWidth-1 do
      LevelRowValue:=(LevelRowValue or GetMask(Field[j,i])) shl 1;
    LevelRowValue := LevelRowValue or GetMask(Field[FieldWidth,i]);
    Level[i+1]:=LevelRowValue;
  end;
end;

{ decompress level array into game field }

Function CheckLastBit(A:LevelRow):CellValue;
begin
  if A mod 2 = 0 then
    CheckLastBit:=clEmpty
  else
    CheckLastBit:=clBrick;
end;

Procedure DecompressLevel(var Level:SnakeLevel;var Field:GameField);
var
  i,j:Word;
  tmp:LevelRow;
begin
  for i:=0 to FieldHeight do
  begin
    tmp:=Level[i+1];
    for j:=FieldWidth downto 1 do
    begin
      Field[j,i]:=CheckLastBit(tmp);
      tmp := tmp shr 1;
    end;
    Field[0,i]:=CheckLastBit(tmp);
  end;
end;

{ --- }

Procedure AddEmptyLevel(var lf:LevelFile;CurrentPos:Word);
var
  NewLevel:SnakeLevel;
begin
  Seek(lf,FileSize(lf));
  CreateEmptyLevel(NewLevel);
  Write(lf,NewLevel);
  Seek(lf,CurrentPos);
end;

{ --- }

Procedure SaveLevel(var lf:LevelFile;var A:GameField);
var
  tmp:SnakeLevel;
begin
  Seek(lf,FilePos(lf)-1);
  CompressLevel(A,tmp);
  Write(lf,tmp);
end;

{ --- }

Procedure LoadLevel(var lf:LevelFile;var A:GameField);
var
  tmp:SnakeLevel;
begin
  Read(lf,tmp);
  DecompressLevel(tmp,A);
end;

{ --- *** --- }

END.