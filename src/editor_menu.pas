{   --- EDITOR_MENU.PAS

    --- CRT_SNAKE LEVEL EDITOR ---
console arcade game using CRT unit

editor menu

}

UNIT Editor_menu;


INTERFACE


USES
  CRT,Snake_Draw,Editor_Unit;

CONST

  YesNoMsgWidth=32;
  YesNoMsgHeight=6;

TYPE

  YesNoMsgString=String[YesNoMsgWidth];

CONST

  yesno_Save:YesNoMsgString        = 'Save current level?';
  yesno_Delete:YesNoMsgString      = 'Delete current level?';
  yesno_ConfirmSave:YesNoMsgString = 'Level has been modified. Save?';
  yesno_Clear:YesNoMsgString       = 'Clear current level?';
  yesno_Exit:YesNoMsgString        = 'Do you wish to exit?';

{ procedures and functions }

Procedure WriteHintLine(HintString:String);

Procedure WriteUnactiveMenu;

Function EditorMenu:MenuSelection;

Function YesNoSelect(MsgLeftTop:ScrPos;Caption:YesNoMsgString):MenuSelection;


IMPLEMENTATION


TYPE

  MenuItem=record
    Text:String[15];
    Value:MenuSelection;
    MenuHint:String[45]
  end;

CONST

{ editor menu constants }

  MenuStart  : ScrPos=( Col: 3 ; Row:1 );

  EditorMenuMax=9;

  EditorMenuContent:array[1..EditorMenuMax] of MenuItem  =
  ((Text:'<-';Value:mnuEdNavBackward;
    MenuHint:' | Navigate - BACKWARD'),

   (Text:'->';Value:mnuEdNavForward;
    MenuHint:'Navigate - FORWARD'),

   (Text:'ADD';Value:mnuEdAddToEnd;
    MenuHint:'ADD clear level to the end of file'),

   (Text:'CLEAR';Value:mnuEdAddToEnd;
    MenuHint:'CLEAR edited level'),

   (Text:'SAVE';Value:mnuEdSave;
    MenuHint:'SAVE edited level'),

   (Text:'DELETE';Value:mnuEdDelete;
    MenuHint:'DELETE edited level'),

   (Text:'<=';Value:mnuEdMovBackward;
    MenuHint:'SAVE and MOVE edited level BACKWARD'),

   (Text:'=>';Value:mnuEdMovForward;
    MenuHint:'SAVE and MOVE edited level FORWARD'),

   (Text:'EXIT';Value:mnuExitRequest;
    MenuHint:'EXIT from LEVEL EDITOR'));

  MenuUnselMark=' ';
  MenuSelBeginMark='[';
  MenuSelEndMark=']';

{ yes-no function constants  }

  YesNoSureMsgRel:ScrPos=(Col:3;Row:8);
  YesNoButtonsRel:ScrPos=(Col:4;Row:5);

  SureMsg='Please confirm! ';
  YesMsg = ' Y E S ';
  NoMsg  = '  N O  ';


{ hint line constants }

  hint_MainHintLine  =
  ' | ARROWS - move cursor | SPACE - draw/erase brick | ESC - editor menu |  ';
  hint_MenuHintLine  =
  ' EDITOR MENU || LEFT/RIGHT - move cursor | ENTER - select | ESC - resume |';
  hint_YesNoHintLine =
  ' UP / DOWN - change || ENTER - select ';
  hint_SuccessAdd =
  ' | Successfully ADDED !';
  hint_SuccessSave =
  ' | Successfully SAVED !';
  hint_SuccessDel =
  ' | Successfully DELETED !';


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
  TextBackground(edcol_HintLineBG);
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
  WriteHintLine(EditorMenuContent[i].MenuHint);
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

Function YesNoMsgAbsBegin(MsgLeftTop:ScrPos;Leng:Word):ScrPos;
var
  tmp:ScrPos;
begin
  tmp.Col:=MsgLeftTop.Col+((yesNoMsgWidth-Leng) div 2);
  tmp.Row:=MsgLeftTop.Row+2;
  YesNoMsgAbsBegin:=tmp;
end;

{ write YES-NO message base }

Procedure WriteYesNoMsgBase(MsgLeftTop:ScrPos;Msg:YesNoMsgString);
var
  MsgAbsPoint:ScrPos;
begin
  TextBackground(edcol_YesNoBG);
  TextColor(edcol_YesNoMsgText);
  ClearRect(MsgLeftTop,YesNoMsgWidth,YesNoMsgHeight);
  MsgAbsPoint:=YesNoMsgAbsBegin(MsgLeftTop,Length(Msg));
  GotoXY(MsgAbsPoint.Col,MsgAbsPoint.Row);
  Write(Msg);
  GotoXY(MsgLeftTop.Col+YesNoSureMsgRel.Col,
                             MsgLeftTop.Row+YesNoSureMsgRel.Row);
  Write(SureMsg);
end;

{ write buttons YES and NO }

Procedure WriteYesNoButtons(MsgLeftTop:ScrPos;YesSelected:boolean);
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
end;

{ --- }
Function YesNoSelect(MsgLeftTop:ScrPos;Caption:YesNoMsgString):MenuSelection;
var
  ch:Char;
  YesSelected:Boolean;
begin
  YesSelected:=false;
  WriteYesNoMsgBase(MsgLeftTop,Caption);
  WriteHintLine(hint_YesNoHintLine);
  WriteYesNoButtons(MsgLeftTop,YesSelected);
  repeat
    ch:=ReadKey;
    case ch of
      kbdLeft,kbdRight:
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
