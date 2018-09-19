{      --- LEVEL_EDITOR.PAS

       --- CRT_SNAKE LEVEL EDITOR ---
console arcade game on Free pascal using CRT unit

level editor main file

(c) Alexey Sorokin, 2018

}

Program LevelEditor;

USES
  CRT,Snake_Draw,Editor_Unit,Editor_Menu;

Procedure RefreshScreen(var A:GameField;CurrentCursorPos:ScrPos);
begin
  ClearYesNoArea;
  WriteUnactiveMenu;
  WriteHintLine(MainHintLine);
  DrawOneCell(A,CurrentCursorPos,true);
end;


VAR
  EditedLevel:GameField;
  CursorPos:ScrPos;
  sym:Char;
  ProgramState:MenuSelection;
  Changed:Boolean;

BEGIN

{ editor initialisation }

  ClrScr;
  TextColor(edcol_FieldBrick);
  DrawFieldBorder;
  CreateEmptyLevel(EditedLevel);
  DrawLevel(EditedLevel);

  CursorPos.Row:=0;
  CursorPos.Col:=0;

  RefreshScreen(EditedLevel,CursorPos);
  Changed:=false;

  WriteStatusLine(CursorPos,Changed);
  CursorOut;

{ main loop }

  repeat
    sym:=ReadKey;
    if sym=#0 then
      sym:=ReadKey;
    case sym of
      kbdUp:  { UP key }
        if CursorPos.Row>0 then
          MoveCursor(EditedLevel,CursorPos,0,-1);

      kbdDown: { DOWN key}
        if CursorPos.Row<FieldHeight then
            MoveCursor(EditedLevel,CursorPos,0,1);

      kbdRight: { RIGHT key}
        if CursorPos.Col<FieldWidth then
            MoveCursor(EditedLevel,CursorPos,1,0);

      kbdLeft: { LEFT key }
        if CursorPos.Col>0 then
            MoveCursor(EditedLevel,CursorPos,-1,0);

      kbdSpace: { drawing / erasing bricks }
        begin
          ChangeCellUnderCursor(EditedLevel,CursorPos);
          if not Changed then
            Changed:=true;
        end;
      kbdESC: { enter to EDITOR MENU }
        begin
          ProgramState:=EditorMenu;
        end;
    end; { case }

    case ProgramState of { editor menu values }
{      mnuEdNavBackward:
        begin
        end;
      mnuEdNavForward:
        begin
        end;
      mnuEdAddToEnd:
        begin
        end;
      mnuEdSave:
        begin
        end;
      mnuEdDelete:
        begin
        end;
      mnuEdMovBackward:
        begin
        end;
      mnuEdMovForward:
        begin
        end;  }
      mnuExitRequest:
        begin
          if (YesNoSelect('Exit:')<>mnuConfirm) then
          begin
            ProgramState:=mnuResume;
            ClearYesNoArea;
            RefreshScreen(EditedLevel,CursorPos);
          end;
        end;
      else
        RefreshScreen(EditedLevel,CursorPos);
    end; { case }

    WriteStatusLine(CursorPos,Changed);
    CursorOut;
  until ProgramState=mnuExitRequest;
  ClrScr;
END.
