{      --- LEVEL_EDITOR.PAS

       --- CRT_SNAKE LEVEL EDITOR ---
console arcade game on Free pascal using CRT unit

level editor main file

(c) Alexey Sorokin, 2018

}

Program LevelEditor;

USES
  CRT,Snake_Draw,Editor_Unit,Editor_Menu;

CONST
  LevelFileName='crt_snake.lvl';

{ main file procedures and functions }

Procedure RefreshScreen(var f:LevelFile;var A:GameField;
                                                CurrentCursorPos:ScrPos);
begin
  ClearYesNoArea;
  WriteUnactiveMenu;
  WriteHintLine(hint_MainHintLine);
  DrawOneCell(A,CurrentCursorPos,true);
  WriteFileInfo(f);
end;

{ --- --- --- }

VAR
  NewLevel,EditedLevel : GameField;
  lvlf:File of GameField;
  tmp_num:Word;
  CursorPos:ScrPos;
  sym:Char;
  ProgramState:MenuSelection;
  Changed:Boolean;

{
  --- MAIN PROGRAM ---
}

BEGIN

{ editor initialisation }

  WriteLn('Running CRT_SNAKE LEVEL EDITOR...');
  Assign(lvlf,LevelFileName);
{$I-}
  Write('Opening CRT_SNAKE.LVL flie...');
  Reset(lvlf);
  if IOResult = 0 then
  begin
    WriteLn('  Successfully open.');
    Seek(lvlf,FileSize(lvlf)-1);
    Read(lvlf,EditedLevel);
  end
  else
  begin
    Rewrite(lvlf);
    Write('  Successfully created !');
    CreateEmptyLevel(EditedLevel);
    Seek(lvlf,0);
    Write(lvlf,Editedlevel);
  end;
{$I+}
  ClrScr;
  TextColor(edcol_FieldBrick);
  DrawFieldBorder;
  DrawLevel(EditedLevel);

  CursorPos.Row:=0;
  CursorPos.Col:=0;
  ProgramState:=mnuResume;

  Changed:=false;

  RefreshScreen(lvlf,EditedLevel,CursorPos);
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

      kbdSpace: { SPACE BAR - drawing / erasing bricks }
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
        end;}

       mnuEdAddToEnd:  { ADDING a new level }
        begin
          if (YesNoSelect('ADD NEW ?')=mnuConfirm) then
          begin
            tmp_num:=FilePos(lvlf);
            Seek(lvlf,FileSize(lvlf));
            CreateEmptyLevel(NewLevel);
            Write(lvlf,NewLevel);
            Seek(lvlf,tmp_num);
            WriteHintLine(hint_SuccessAdd);
          end
          else
          begin
            RefreshScreen(lvlf,EditedLevel,CursorPos);
          end;
            ProgramState:=mnuResume;
        end;

       mnuEdSave: { SAVING edited level }
         begin
           if (YesNoSelect('SAVE LEVEL ?')=mnuConfirm) then
           begin
             Seek(lvlf,FilePos(lvlf)-1);
             Write(lvlf,EditedLevel);
             WriteHintLine(hint_SuccessSave);
             Changed:=false;
           end
           else
           begin
             RefreshScreen(lvlf,EditedLevel,CursorPos);
           end;
             ProgramState:=mnuResume;
         end;
{      mnuEdDelete:
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
          if (YesNoSelect('EXIT ?:')<>mnuConfirm) then
          begin
            ProgramState:=mnuResume;
            RefreshScreen(lvlf,EditedLevel,CursorPos);
          end;
        end;

      else {another STATE}
        begin
          RefreshScreen(lvlf,EditedLevel,CursorPos);
          CursorOut;
        end;
    end; { case }

  until ProgramState=mnuExitRequest;

{ program done }

  Close(lvlf);
  ClrScr;
END.
