{   --- EDITOR_MENU.PAS

    --- CRT_SNAKE LEVEL EDITOR ---
console arcade game using CRT unit

editor menu

}

UNIT Editor_menu;


INTERFACE


USES
  CRT,Snake_Base,Editor_Unit;

CONST

  EditorMenuMax=10;

  YesNoMsgWidth=35;
  YesNoMsgHeight=6;

TYPE

  YesNoMsgString=String[YesNoMsgWidth];

  MenuItem=record
    Text:String[15];
    Value:MenuSelection;
    MenuHint:String[45]
  end;

CONST

  EditorMenuContent:array[1..EditorMenuMax] of MenuItem  =
  ((Text:'HELP';Value:mnuShowHelpScreen;
    MenuHint:' | View HELP SCREEN'),

   (Text:'<-';Value:mnuEdNavBackward;
    MenuHint:' | Navigate - BACKWARD'),

   (Text:'->';Value:mnuEdNavForward;
    MenuHint:' | Navigate - FORWARD'),

   (Text:'ADD TO END';Value:mnuEdAddToEnd;
    MenuHint:' | ADD clear level to the end of file'),

   (Text:'CLEAR';Value:mnuEdClearCurrent;
    MenuHint:' | CLEAR edited level'),

   (Text:'SAVE';Value:mnuEdSave;
    MenuHint:' | SAVE edited level'),

   (Text:'DELETE';Value:mnuEdDelete;
    MenuHint:' | DELETE edited level'),

   (Text:'<=';Value:mnuEdMovBackward;
    MenuHint:' | SAVE and MOVE edited level BACKWARD'),

   (Text:'=>';Value:mnuEdMovForward;
    MenuHint:' | SAVE and MOVE edited level FORWARD'),

   (Text:'EXIT';Value:mnuExitRequest;
    MenuHint:' | EXIT from LEVEL EDITOR'));

{ YES_NO confirm messages }

  yesno_Add:YesNoMsgString         = 'ADD empty level to END of file?';
  yesno_Save:YesNoMsgString        = 'SAVE current level?';
  yesno_Delete:YesNoMsgString      = 'DELETE current level?';
  yesno_ConfirmSave:YesNoMsgString = 'Level has been modified. SAVE?';
  yesno_Clear:YesNoMsgString       = 'CLEAR current level?';
  yesno_Exit:YesNoMsgString        = 'Do you wish to EXIT?';

{ hintline messages }

  hint_Main  =
  ' | ARROWS - move cursor | SPACE - draw/erase brick | ESC - editor menu |';
  hint_Menu  =
  ' | EDITOR MENU || LEFT/RIGHT - move cursor | ENTER - select | ESC - resume |';
  hint_HelpScreen =
  ' | HELP SCREEN - press any key to continue';
  hint_YesNoHelp =
  ' | ARROWS / TAB - change | ENTER - select';
  hint_SuccessAdd =
  ' | Successfully ADDED !';
  hint_SuccessClear =
  ' | Successfully CLEARED !';
  hint_SuccessSave =
  ' | Successfully SAVED !';
  hint_SuccessDel =
  ' | Successfully DELETED !';

{ procedures and functions }

Procedure WriteHintLine(HintString:String);

Procedure WriteUnactiveMenu;

Function EditorMenu:MenuSelection;

Function YesNoSelect(MsgLeftTop:Point;Caption:YesNoMsgString):MenuSelection;


IMPLEMENTATION


CONST

{ editor menu constants }

  MenuStart  : Point = ( Col : 3 ; Row : 1 );

  MenuUnselMark=' ';
  MenuSelBeginMark='[';
  MenuSelEndMark=']';

{ yes-no function constants  }

  YesNoSureMsgRel:Point = (Col :12 ; Row : 3);
  YesNoButtonsRel:Point = (Col : 9 ; Row : 5);

  SureMsg='Please confirm! ';
  YesMsg = ' Y E S ';
  NoMsg  = '  N O  ';

{ --- ---- ---- ---- ---- ---- ---- ---- ---- ---- --- }
{ ---  EDITOR_MENU unit procedures and functions   --- }
{ --- ---- ---- ---- ---- ---- ---- ---- ---- ---- --- }

{filling string with SPACR BAR symbols }

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

{ write hint line on screen bottom }

Procedure WriteHintLine(HintString:String);
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_HintLineText);
  GotoXY(1,ScreenHeight);
  Write(HintString);
  FillString(ScreenWidth-1);
  CursorOut;
end;

{ writing button with need color }

Procedure WriteButton(Item:String;SelColor,UnselColor:Word;Selected:Boolean);
begin
  if Selected then
  begin
    TextColor(SelColor);
    Write(MenuSelBeginMark);
  end else
  begin
    TextColor(UnselColor);
    Write(MenuUnselMark);
  end;
  Write(Item);
  If Selected then
    Write(MenuSelEndMark)
  else
    Write(MenuUnselMark);
end;

{ --- --- --- --- --- --- --- --- --- }
{ --- EDITOR MENU select function --- }
{ --- --- --- --- --- --- --- --- --- }

Procedure WriteUnactiveMenu;
var
  i:Word;
begin
  TextBackground(edcol_MenuBG);
  TextColor(edcol_MenuUnactive);
  GotoXY(MenuStart.Col,MenuStart.Row);
  For i:=1 to EditorMenuMax do
    Write(MenuUnselMark,EditorMenuContent[i].Text,MenuUnselMark);
  FillString(ScreenWidth-1);
end;

{ --- }

Procedure WriteAllMenu(MenuPos:Word);
var
  i:Word;
begin
  i:=1;
  TextBackground(edcol_MenuBG);
  GotoXY(MenuStart.Col,MenuStart.Row);
  While i<MenuPos do
  begin
    WriteButton(EditorMenuContent[i].Text,
                                    edcol_MenuSel,edcol_MenuUnsel,false);
    inc(i);
  end;
  WriteButton(EditorMenuContent[MenuPos].Text,
                                    edcol_MenuSel,edcol_MenuUnsel,true);
  inc(i);
  While i<=EditorMenuMax do
  begin
    WriteButton(EditorMenuContent[i].Text,
                                    edcol_MenuSel,edcol_MenuUnsel,false);
    inc(i);
  end;
  FillString(ScreenWidth);
  WriteHintLine(EditorMenuContent[MenuPos].MenuHint);
end;

{ --- --- }

Function EditorMenu:MenuSelection;
var
  Position:Word;
  ch:Char;
begin
  Position:=1;
  WriteAllMenu(Position);
  repeat
    ch:=ReadKey;
    case ch of

      kbdRight:
        if Position<EditorMenuMax then
          inc(Position)
        else
          Position:=1;

      kbdLeft:
        if Position>1 then
          dec(Position)
        else
          Position:=EditorMenuMax;

      kbdEsc:
        EditorMenu:=mnuResume;

      kbdEnter:
        EditorMenu:=EditorMenuContent[Position].Value;

    end; { case }
    WriteAllMenu(Position);
  until (ch=kbdEnter) or (ch=kbdESC);
end;

{ --- --- --- --- --- --- --- --- --- }
{ --- YES and NO select function  --- }
{ --- --- --- --- --- --- --- --- --- }

Function YesNoMsgAbsBegin(MsgLeftTop:Point;Leng:Word):Point;
var
  tmp:Point;
begin
  tmp.Col:=MsgLeftTop.Col+((yesNoMsgWidth-Leng) div 2)+1;
  tmp.Row:=MsgLeftTop.Row+2;
  YesNoMsgAbsBegin:=tmp;
end;

{ write YES-NO message base }

Procedure WriteYesNoMsgWindow(MsgLeftTop:Point;Msg:YesNoMsgString);
var
  MsgAbsPoint:Point;
begin
  TextBackground(edcol_YesNoBG);
  TextColor(edcol_YesNoMsgText);
  ClearRect(MsgLeftTop,YesNoMsgWidth+2,YesNoMsgHeight);
  MsgAbsPoint:=YesNoMsgAbsBegin(MsgLeftTop,Length(Msg));
  GotoXY(MsgAbsPoint.Col,MsgAbsPoint.Row);
  Write(Msg);
  GotoXY(MsgLeftTop.Col+YesNoSureMsgRel.Col,
                             MsgLeftTop.Row+YesNoSureMsgRel.Row);
  Write(SureMsg);
end;

{ write buttons YES and NO }

Procedure WriteYesNoButtons(MsgLeftTop:Point;YesSelected:boolean);
begin
  GotoXY(MsgLeftTop.Col+YesNoButtonsRel.Col,
                                    MsgLeftTop.Row+YesNoButtonsRel.Row);
  If YesSelected then
  begin
    WriteButton(YesMsg,edcol_YesNoSel,edcol_YesNoUnsel,true);
    WriteButton(NoMsg,edcol_YesNoSel,edcol_YesNoUnsel,false);
  end else
  begin
    WriteButton(YesMsg,edcol_YesNoSel,edcol_YesNoUnsel,false);
    WriteButton(NoMsg,edcol_YesNoSel,edcol_YesNoUnsel,true);
  end;
  CursorOut;
end;

{ --- }

Function YesNoSelect(MsgLeftTop:Point;Caption:YesNoMsgString):MenuSelection;
var
  ch:Char;
  YesSelected:Boolean;
begin
  YesSelected:=false;
  WriteYesNoMsgWindow(MsgLeftTop,Caption);
  WriteHintLine(hint_YesNoHelp);
  WriteYesNoButtons(MsgLeftTop,YesSelected);
  repeat
    ch:=ReadKey;
    case ch of
      kbdLeft,kbdRight,kbdTAB:
        begin
          if YesSelected then
            YesSelected:=false
          else
            YesSelected:=true;
          WriteYesNoButtons(MsgLeftTop,YesSelected);
        end;
      kbdEnter:
        if YesSelected then
          YesNoSelect:=mnuConfirm
        else
          YesNoSelect:=mnuCancel;
    end; { case }
  until ch = kbdEnter;
end;

END.
