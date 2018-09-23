{   --- CRT_SNAKE LEVEL EDITOR
    --- EDITOR_FILE.PAS

  level file manipulations -
  creating, deleting,moving etc

  (c) Alexey Sorokin,  2018
}

UNIT Editor_File;


INTERFACE


Uses
  Snake_Draw,Editor_Unit;

{ --- procedures and functions --- }

Procedure CreateNewFile(var lf:LevelFile);


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

END.