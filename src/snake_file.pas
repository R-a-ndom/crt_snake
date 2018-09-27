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

  LevelFile = file of GameField;

{ --- procedures and functions --- }

Procedure CreateNewFile(var lf:LevelFile);

Procedure AddEmptyLevel(var lf:LevelFile;CurrentPos:Word);

Procedure SaveLevel(var lf:LevelFile;A:GameField);


IMPLEMENTATION


Procedure CreateNewFile(var lf:LevelFile);
var
  A:GameField;
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
  NewLevel:GameField;
begin
  Seek(lf,FileSize(lf));
  CreateEmptyLevel(NewLevel);
  Write(lf,NewLevel);
  Seek(lf,CurrentPos);
end;

{ --- }

Procedure SaveLevel(var lf:LevelFile;A:GameField);
begin
  Seek(lf,FilePos(lf)-1);
  Write(lf,A);
end;

END.