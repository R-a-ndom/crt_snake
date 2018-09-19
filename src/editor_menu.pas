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
  YesNoMsgWidth=13;

TYPE
  YesNoMsgString=String[YesNoMsgWidth];

{ procedures and functions }

Procedure WriteUnactiveMenu;

Function EditorMenu:MenuSelection;

Procedure ClearYesNoArea;

Function YesNoSelect(const Message:YesNoMsgString):MenuSelection;


IMPLEMENTATION

TYPE

  MenuItem=record
    Text:String[15];
    Value:MenuSelection
  end;

{ editor menu constants }

CONST

  MenuStart  : ScrPos=( Col: 3 ; Row:1 );
  YesNoStart : ScrPos=( Col:66 ; Row:10);

  EditorMenuMax=8;

  YesNoMsgHeight=4;


  EditorMenuContent:array[1..EditorMenuMax] of MenuItem  =
  ((Text:'<-';          Value:mnuEdNavBackward),
   (Text:'->';          Value:mnuEdNavForward),
   (Text:'ADD TO END';  Value:mnuEdAddToEnd),
   (Text:'SAVE';        Value:mnuEdSave),
   (Text:'DELETE';      Value:mnuEdDelete),
   (Text:'MOVE <=';     Value:mnuEdMovBackward),
   (Text:'MOVE =>';     Value:mnuEdMovForward),
   (Text:'EXIT';        Value:mnuExitRequest));

  SureMsg='Are you sure? ';
  YesMsg = ' Y E S ';
  NoMsg  = '  N O  ';

  MenuUnselMark=' ';
  MenuSelBeginMark='[';
  MenuSelEndMark=']';

{ --- EDITOR MENU select function --- }

Procedure WriteUnactiveMenu;
var
  i:Word;
begin
  TextBackground(edcol_MenuBG);
  TextColor(edcol_MenuUnactive);
  GotoXY(MenuStart.Col,MenuStart.Row);
  For i:=1 to EditorMenuMax do
    Write(MenuUnselMark,EditorMenuContent[i].Text,MenuUnselMark);
end;

{ --- }

Procedure WriteMenuItem(Item:String;Selected:Boolean);
begin
  if Selected then
  begin
    TextColor(edcol_MenuSelItem);
    Write(MenuSelBeginMark);
  end else
  begin
    TextColor(edcol_MenuUnselItem);
    Write(MenuUnselMark);
  end;
  Write(Item);
  If Selected then
    Write(MenuSelEndMark)
  else
    Write(MenuUnselMark);
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
    WriteMenuItem(EditorMenuContent[i].Text,false);
    inc(i);
  end;
  WriteMenuItem(EditorMenuContent[MenuPos].Text,true);
  inc(i);
  While i<=EditorMenuMax do
  begin
    WriteMenuItem(EditorMenuContent[i].Text,false);
    inc(i);
  end;
  for i:=WhereX to ScreenWidth-1 do
    Write(#32);
end;

{ --- --- }

Function EditorMenu:MenuSelection;
var
  Position:Word;
  ch:Char;
begin
  Position:=1;
  WriteHintLine(MenuHintLine);
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

{ --- YES and NO select function  --- }

Procedure FillString;
var
  i:Word;
begin
  for i:=WhereX to YesNoStart.Col+YesNoMsgWidth do
    Write(#32);
end;

{ --- }

Procedure ClearYesNoArea;
var
  i:Word;
begin
  TextBackground(edcol_MainBG);
  for i:=YesNoStart.Row to YesNoStart.Row+YesNoMsgHeight do
  begin
    GotoXY(YesNoStart.Col,i);
    FillString;
  end;
end;

{ --- }


Procedure WriteYesNoMessage(const Message:YesNOMsgString;YesSelected:Boolean);
var
  i:Word;
begin
  i:=1;
  TextBackground(edcol_YesNoBG);
  TextColor(edcol_YesNoMsgText);
  GotoXY(YesNoStart.Col,YesNoStart.Row);
  Write(Message);
  FillString;
  TextColor(edcol_YesNoUnsel);
  GotoXY(YesNoStart.Col,YesNoStart.Row+i);
  Write(SureMsg);
  inc(i);
  GotoXY(YesNoStart.Col,YesNoStart.Row+i);
  Write(#32#32);
  if YesSelected then
    begin
      TextColor(edcol_YesNoSel);
      Write(MenuSelBeginMark,YesMsg,MenuSelEndMark);
    end
  else
    begin
      TextColor(edcol_YesNoUnsel);
      Write(MenuUnselMark,YesMsg,MenuUnselMark);
    end;
  FillString;
  inc(i);
  GotoXY(YesNoStart.Col,YesNoStart.Row+i);
  Write(#32#32);
  if YesSelected then
    begin
      TextColor(edcol_YesNoUnsel);
      Write(MenuUnselMark,NoMsg,MenuUnselMark);
    end
  else
    begin
      TextColor(edcol_YesNoSel);
      Write(MenuSelBeginMark,NoMsg,MenuSelEndMark);
    end;
  FillString;
  CursorOut;
end;

Function YesNoSelect(const Message:YesNoMsgString):MenuSelection;
var
  ch:Char;
  YesSelected:Boolean;
begin
  YesSelected:=false;
  WriteYesNoMessage(Message,YesSelected);
  WriteHintLine(YesNoHintLine);
  repeat
    ch:=ReadKey;
    case ch of
      kbdUp,kbdDown:
        begin
          if YesSelected then
            YesSelected:=false
          else
            YesSelected:=true;
          WriteYesNoMessage(Message,YesSelected);
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
