UNIT Game_HScore;

INTERFACE

CONST

  TopSize = 10; {high score file size - TOP 10}

  NameMax = 15; { name size }

  ProgressMax = 30 {all levels in game }

  EmptyName = '---------------';

  { потом засунуть в цвета

  col_HScoreTableBorder = White;
  col_HScoreTableHeader = Yellow;
  col_HScoreString      = Green;
  col_HScoreEmptyString = LightGray;
  col_HScoreGoalString  = Red;
}
TYPE

{
  hiscore file string :
  Name - Progress - Score
}

HScoreString=record
  Name:string[NameMax];
  Progress:Integer;
  Score:Word
end;

hsfile=file of HScoreString;

CONST

EmptyHScoreString:HScoreString=
 ( Name     : EmptyName;
   Progress : 0;
   Score    : 0);


IMPLEMENTATION


Procedure ClearHScoreFile(var f:hsfile);
var
  i:Word;
begin
  Seek(f,0);
  for i:=1 to TopSize do
  begin
    Write(f,EmptyHighScoreString);
  end;
end;

Function PosInHighScoreFile(var f: hsfile;CheckedScore:Word):Word;
var

begin
  Seek(f,0);
  repeat
    Read(f,tmp);
  until tmp.Score<CheckedScore or not EoF(hsfile);
  PosInHScoreFile:=tmp.Score;
end;

procedure WriteDirectLine;
begin
  for i:=1 to MaxTableHorSize do
    Write('-');
end;

procedure WriteTableLegend;
begin
  Write('| Name |');
  Write(' Progress |');
  Write(' Score |');
end;

procedure WriteTableString(A:HighScoreString);
var
  InfoColor:Word;

begin
  if A.Score=0 and A.Progress=0 then
    InfoColor:=col_HScoreEmptyString
  else if A.Progress=MaxLevel then
    InfoColor:=col_HScoreGoalString
  else
    InfoColor:=col_HScoreSting;
  Write('|');
  Write(A.Name);
  Write('|');
  Write(A.Progress:4);
  Write('|');
  Write(A.Score:7);
  Write('|');

end;

procedure WriteHSTableHeader;

begin

end;

END.