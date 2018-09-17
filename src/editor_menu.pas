{   --- EDITOR_MENU.PAS

    --- CRT_SNAKE LEVEL EDITOR ---
console arcade game using CRT unit

editor menu

}

UNIT Editor_menu;


INTERFACE


USES
  CRT,Snake_Draw,Editor_Unit;

TYPE

  MenuItem=record
    Text:String[15];
    Value:MenuSelection
  end;

{ editor menu constants }

CONST

  MenuStart:ScrPos=( Col:3 ; Row:1 );

  EditorMenuMax=9;

  EditorMenuContent:array[1..EditorMenuMax] of MenuItem  =
  ((Text:'<-';     Value:mnuEdNavBackward),
   (Text:'->';     Value:mnuEdNavForward),
   (Text:'NEW';         Value:mnuEdNew),
   (Text:'SAVE<>REPLACE'; Value:mnuEdReplace),
   (Text:'SAVE<>INSERT';  Value:MnuEdInsert),
   (Text:'DELETE';      Value:mnuEdDelete),
   (Text:'MOVE <=';     Value:mnuEdMvBackward),
   (Text:'MOVE =>';     Value:mnuEdMvForward),
   (Text:'EXIT';        Value:mnuExit));

  MenuUnselMark=' ';
  MenuSelBeginMark='[';
  MenuSelEndMark=']';

Procedure WriteUnactiveMenu;

Function EditorMenu:MenuSelection;

IMPLEMENTATION

Procedure WriteUnactiveMenu;
var
  i:Word;
begin
  TextBackground(edcol_MainBG);
  TextColor(edcol_MenuUnactive);
  GotoXY(MenuStart.Col,MenuStart.Row);
  For i:=1 to EditorMenuMax do
    Write(MenuUnselMark,EditorMenuContent[i].Text,MenuUnselMark);
end;


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

Procedure WriteAllMenu(MenuPos:Word);
var
  i:Word;
begin
  i:=1;
  TextBackground(edcol_MainBG);
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
  CursorOut;
end;

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

END.
