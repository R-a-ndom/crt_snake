{   --- CRT_SNAKE LEVEL EDITOR
    --- EDITOR_FILE.PAS

  level file manipulations -
  creating, deleting,moving etc

  (c) Alexey Sorokin,  2018
}

UNIT Snake_File;


INTERFACE


Uses
  Snake_Base;

TYPE

  LevelFile = file of SnakeLevel;

{ --- procedures and functions --- }

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

{ compress field array into level array  }

Procedure CompressLevel(var Field:GameField;var Level:SnakeLevel);
var
  i,j:Word;
  UnitValue,Mask:LevelUnit;
begin
  for i:=0 to FieldHeight do
  begin
    UnitValue:=0;
    For j:=0 to FieldWidth do
    begin
      if Field[j,i]=clBrick then
        Mask:=1
      else
        Mask:=0;
      UnitValue:=(UnitValue or Mask) shl 1;
    end;
    Level[i+1]:=UnitValue;
  end;
end;

{ --- }

Procedure DecompressLevel(var Level:SnakeLevel;var Field:GameField);
var
  i,j:Word;
  tmp:LevelUnit;
begin
  for i:=0 to FieldHeight do
  begin
    tmp:=Level[i+1];
    for j:=FieldWidth downto 1 do
    begin
      if tmp mod 2 = 0 then
        Field[j,i]:=clEmpty
      else
        Field[j,i]:=clBrick;
    tmp := tmp shr 1;
    end;
    if tmp mod 2 = 0 then
      Field[j,i]:=clEmpty
    else
      Field[j,i]:=clBrick;
  end;
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

END.