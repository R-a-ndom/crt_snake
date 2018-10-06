{      --- EDITOR_MAIN.PAS ---

       --- CRT_SNAKE LEVEL EDITOR ---
console arcade game on Free pascal using CRT unit

level editor main file

(c) Alexey Sorokin, 2018 }

Program LevelEditor;

USES
  CRT,Snake_Base,Snake_File,Editor_Unit,Editor_Menu;

TYPE
  ScreenParams=record
    FieldLeftTop,StLinePos,YesNoLeftTop:ScrPos;
  end;

CONST
  LevelFileName='crt_snake.lvl';

{ main file PROCEDURES AND FUNCTIONS }

{$ifdef DEBUG}
Procedure WriteScreenParams(A:ScreenParams);
begin
  GotoXY(2,ScreenHeight-1);
  Write('** DEBUG OUT :');
  Write('SCREEN : ',ScreenWidth:3,ScreenHeight:3);
  Write(' FIELD  : ',A.FieldLeftTop.Col:3,A.FieldLeftTop.Row:3);
  Write(' STLINE : ',A.StLinePos.Col:3,A.StLinePos.Row:3);
  Write(' YES_NO : ',A.YesNoLeftTop.Col:3,A.YesNoLeftTop.Row:3);
end;
{$endif}

{ exit with error }

Procedure ErrorExit;
begin
  WriteLn(stderr,'Program will be closed.');
  Halt(1);
end;

{ evaluating output coords }

Procedure GetScreenParams(var A:ScreenParams);
begin
  A.FieldLeftTop:=EvalMiddlePosLeftTop
                  (FieldWidth*CellWidth + 1,FieldHeight+1);
  A.StLinePos   :=EvalStatusLinePoint(A.FieldLeftTop);
  A.YesNoLeftTop:=EvalMiddlePosLeftTop(YesNoMsgWidth,YesNoMsgHeight);
end;

{ editor initialisation }

Procedure EditorInit(var lf:LevelFile;
                     var A:ScreenParams);
begin
  WriteLn('Running CRT_SNAKE LEVEL EDITOR...');
  Assign(lf,LevelFileName);
{$I-}
  WriteLn('Opening or creating CRT_SNAKE.LVL flie...');
  Reset(lf);
  if IOResult <> 0 then
    Begin
      Write(stderr,'FAIL open... Trying to create.');
      CreateNewFile(lf);
      if IOResult <> 0 then
      begin
        Write(stderr,'FAIL creating...');
        ErrorExit;
      end
    end;
  WriteLn(' Successfully. Levels in file:',FileSize(lf));
{$I+}
  Delay(1000);
  GetScreenParams(A);
end;

{ reset editor screen }

Procedure ResetEditorScreen
        (var f:LevelFile; var A:GameField;
         Mode:EditorMode;CursorPos:ScrPos;Param:ScreenParams);
begin
  WriteUnactiveMenu;
  DrawLevel(A,Param.FieldLeftTop);
  WriteHintLine(hint_Main);
  DrawOneCell(A,Param.FieldLeftTop,CursorPos,true);
  WriteFullStatusLine(f,Param.StLinePos,CursorPos,Mode);
end;

{ confirm saving function }

Procedure SaveIfNeed(var lf:LevelFile;var A:GameField;var Mode:EditorMode;YesNoLeftTop:ScrPos);
begin
  if ( (Mode.Modified=true) and
     (YesNoSelect(YesNoLeftTop,yesno_ConfirmSave)=mnuConfirm) )
  then
    SaveLevel(lf,A);
    Mode.Modified:=false;    
end;

{ --- --- --- }

VAR
  EditedLevel : GameField;
  lvlf:LevelFile;
  Mode:EditorMode=(Modified:False;Wall:False;Erase:False);
  tmp_num:Word;
  ScrPar:ScreenParams;
  CursorPos:ScrPos;
  sym:Char;
  ProgramState:MenuSelection;

{ --------------------
  --- MAIN PROGRAM ---
  --------------------
}

BEGIN

  EditorInit(lvlf,ScrPar);
  Seek(lvlf,FileSize(lvlf)-1);
  LoadLevel(lvlf,EditedLevel);

  CursorPos.Row:=0;
  CursorPos.Col:=0;

  ClrScr;
  TextColor(edcol_FieldBrick);

{ $ifdef DEBUG
  WriteScreenParams(ScrPar);
 $ endif}

  DrawFieldBorder(ScrPar.FieldLeftTop);
  ProgramState:=mnuResume;
  ResetEditorScreen(lvlf,EditedLevel,Mode,CursorPos,ScrPar);
  CursorOut;

{ main loop }

  repeat
    sym:=ReadKey;
    if sym=#0 then
      sym:=ReadKey;
    case sym of
      kbdUp:  { UP key }
        if CursorPos.Row>0 then
        begin
          MoveCursor(EditedLevel,CursorPos,ScrPar.FieldLeftTop,0,-1);
          WriteFullStatusLine(lvlf,ScrPar.StLinePos,CursorPos,Mode);
        end;

      kbdDown: { DOWN key}
        if CursorPos.Row<FieldHeight then
        begin
          MoveCursor(EditedLevel,CursorPos,ScrPar.FieldLeftTop,0,1);
          WriteFullStatusLine(lvlf,ScrPar.StLinePos,CursorPos,Mode);
        end;

      kbdRight: { RIGHT key}
        if CursorPos.Col<FieldWidth then
        begin
          MoveCursor(EditedLevel,CursorPos,ScrPar.FieldLeftTop,1,0);
          WriteFullStatusLine(lvlf,ScrPar.StLinePos,CursorPos,Mode);
        end;

      kbdLeft: { LEFT key }
        if CursorPos.Col>0 then
        begin
          MoveCursor(EditedLevel,CursorPos,ScrPar.FieldLeftTop,-1,0);
          WriteFullStatusLine(lvlf,ScrPar.StLinePos,CursorPos,Mode);
        end;

      kbdTab:  { TAB key }
        begin
          SwitchModes(Mode);
          WriteFullStatusLine(lvlf,ScrPar.StLinePos,CursorPos,Mode);
        end;

      kbdSpace: { SPACE BAR - drawing / erasing bricks }
        if (not Mode.Wall) and (not Mode.Erase) then        
        begin
          ChangeCellUnderCursor(EditedLevel,ScrPar.FieldLeftTop,CursorPos);
          if not Mode.Modified then
            Mode.Modified:=true;
          WriteFullStatusLine(lvlf,ScrPar.StLinePos,CursorPos,Mode);
        end;

      kbdESC: { enter to EDITOR MENU }
        begin
          ProgramState:=EditorMenu;
          WriteUnactiveMenu;
        end;
    end; { case }

    case ProgramState of { editor menu values }

      mnuShowHelpScreen:
        begin
          WriteHintLine(hint_HelpScreen);
          ShowHelpScreen(ScrPar.FieldLeftTop);
          ProgramState:=mnuResumeNeedReset;
        end;

      mnuEdNavBackward:  { viewing file - BACKWARD }
        begin
          if FilePos(lvlf)>1 then
          begin
            SaveIfNeed(lvlf,EditedLevel,Mode,ScrPar.YesNoLeftTop);
            Seek(lvlf,FilePos(lvlf)-2);
            LoadLevel(lvlf,EditedLevel);
            Mode.Modified:=false;
            ProgramState:=mnuResumeNeedReset;
          end
          else
          begin
            WarningAnimation;
            WriteHintLine(hint_Main);
            ProgramState:=mnuResume;
          end;
        end;

      mnuEdNavForward:  { viewing file - FORWARD }
        begin
          if FilePos(lvlf)<FileSize(lvlf) then
          begin
            SaveIfNeed(lvlf,EditedLevel,Mode,ScrPar.YesNoLeftTop);
            LoadLevel(lvlf,EditedLevel);
            Mode.Modified:=false;
            ProgramState:=mnuResumeNeedReset;
          end
          else
          begin
            WarningAnimation;  
            WriteHintLine(hint_Main);
            ProgramState:=mnuResume;
          end;
        end;

       mnuEdAddToEnd:  { ADDING a new level }
        begin
          if (YesNoSelect(ScrPar.YesNoLeftTop,yesno_Add)=mnuConfirm) then
          begin
            tmp_num:=FilePos(lvlf);
            AddEmptyLevel(lvlf,tmp_num);
          end;
          ProgramState:=mnuResumeNeedReset;
        end;

       mnuEdSave: { SAVING edited level }
         begin
           if (YesNoSelect(ScrPar.YesNoLeftTop,yesno_Save)=mnuConfirm) then
           begin
             SaveLevel(lvlf,EditedLevel);
             Mode.Modified:=false;
           end;
           ProgramState:=mnuResumeNeedReset;
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
          if (YesNoSelect(ScrPar.YesNoLeftTop,yesno_Exit)<>mnuConfirm) then
            ProgramState:=mnuResumeNeedReset
          else
            SaveIfNeed(lvlf,EditedLevel,Mode,ScrPar.YesNoLeftTop);
        end;

    end; { case }
    if ProgramState=mnuResumeNeedReset then
      begin
        ResetEditorScreen(lvlf,EditedLevel,Mode,CursorPos,ScrPar);
        ProgramState:=mnuResume;
        CursorOut;
      end;
  until ProgramState=mnuExitRequest;

{ program done }

  Close(lvlf);
  ClrScr;
END.
