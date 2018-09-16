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

  MenuStart:ScrPos=( Col:5 ; Row:1 );

  MenuMax=9;

  EditorMenuContent:array[1..MenuMax] of MenuItem  =
  ((Text:'<--';            Value:mnuEdNavBackward),
   (Text:'-->';            Value:mnuEdNavForward),
   (Text:'NEW';            Value:mnuEdNew),
   (Text:'SAVE | REPLACE'; Value:mnuEdReplace),
   (Text:'SAVE | INSERT';  Value:MnuEdInsert),
   (Text:'DELETE';         Value:mnuEdDelete),
   (Text:'<== MOVE';       Value:mnuEdMvBackward),
   (Text:'MOVE ==>';       Value:mnuEdMvForward),
   (Text:'EXIT';           Value:mnuExit));

  MenuUnselMark='  ';
  MenuSelBeginMark='[ ';
  MenuSelEndMark=' ] ';

Function EditorMenu:MenuSelection;

IMPLEMENTATION

Procedure WriteMenuItem(Item:String;Selected:Boolean);
begin
  if Selected then
  begin
    TextColor(Yellow);
    Write(MenuSelBeginMark);
  end else
  begin
    TextColor(LightGray);
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
  GotoXY(MenuStart.Col,MenuStart.Row);
  For i:=1 to MenuPos do
    WriteMenuItem(EditorMenuContent[i].Text,false);
  Write(EditorMenuContent[MenuPos].Text,true);
  For i:=MenuPos+1 to MenuMax do
    WriteMenuItem(EditorMenuContent[i].Text,false);
end;

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
      kbdLeft:
        if Position<MenuMax then
          begin
            inc(Position);
            WriteAllMenu(Position);
          end;
      kbdRight:
        if Position>1 then
          begin
            inc(Position);
            WriteAllMenu(Position);
          end;
      kbdEsc:
        EditorMenu:=mnuResume;
      kbdEnter:
        EditorMenu:=EditorMenuContent[Position].Value;
    end;
  until (ch=kbdEnter) or (ch=kbdESC);
end;

END.
