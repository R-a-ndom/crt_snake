{      --- LEVEL_EDITOR.PAS

       --- CRT_SNAKE LEVEL EDITOR ---
console arcade game on Free pascal using CRT unit

level editor main file

(c) Alexey Sorokin, 2018

}

Program LevelEditor;

USES
  CRT,Snake_Draw,Editor_Unit,Editor_Menu;

{ $I crt_snake.inc }

VAR
  EditedLevel:GameField;
  CursorPos:ScrPos;
  sym:Char;
  ProgramState:MenuSelection;
BEGIN
  ClrScr;
  TextColor(Green);
  DrawFieldBorder;
  CreateEmptyLevel(EditedLevel);
  DrawLevel(EditedLevel);
  CursorPos.Row:=0;
  CursorPos.Col:=0;
  DrawOneCell(EditedLevel,CursorPos,true);
  CursorOut;
  repeat
    sym:=ReadKey;
    case sym of
      kbdUp:
        if CursorPos.Row>0 then
          begin
            MoveCursor(EditedLevel,CursorPos,0,-1); 
            CursorOut;
          end;
      kbdDown:
        if CursorPos.Row<FieldHeight then
          begin
            MoveCursor(EditedLevel,CursorPos,0,1);
            CursorOut;
          end;
      kbdLeft:
        if CursorPos.Col<FieldWidth then
          begin
            MoveCursor(EditedLevel,CursorPos,1,0);
            CursorOut;
          end;
      kbdRight:
        if CursorPos.Col>0 then
          begin
            MoveCursor(EditedLevel,CursorPos,-1,0);
            CursorOut;
          end;
      kbdSpace:
        begin
          if EditedLevel[CursorPos.Col,CursorPos.Row]=clBrick then
            EditedLevel[CursorPos.Col,CursorPos.Row]:=clBrick
          else
            EditedLevel[CursorPos.Col,CursorPos.Row]:=clEmpty;
          DrawOneCell(EditedLevel,CursorPos,true);
          CursorOut;
        end;
      kbdESC:
        begin
          ProgramState:=EditorMenu;
          WriteStatusLine;
        end;
    end; { case }
  until ProgramState<>mnuExit;
  ClrScr;
END.
