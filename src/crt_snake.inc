{        - CRT_SNAKE.INC

       --- CRT_SNAKE ---
console arcade game on Free Pascal
using CRT unit

 - base types and constants
 including to INTERFACE section }

{$ifndef CRT_SNAKE_INC}
{$define CRT_SNAKE_INC}

CONST

  { game field size - 30 * 20 }

  FieldWidth=29;
  FieldHeight=19;

  { keyboard codes }

  kbdLeft=#75;
  kbdRight=#77;
  kbdUp=#72;
  kbdDown=#80;
  
  kbdESC=#27;
  kbdSpace=#32;
  kbdENTER=#13;

TYPE


{ field cell values }

  CellValue=( clEmpty,  {empty cell}
              clBrick,  {brick cell}
              clFriut,  {friut - for growing}
              clCoin,   {coin - for score}
              clBody,   {snake's body}
              clHead ); {snake's head}

{ game field array }

  GameField=array[0..FieldHeight,0..FieldWidth] of CellValue;

{ menu selection items }

  MenuSelection = ( mnuBeginGame,     { MAIN - begin game }
                    mnuShowHighScore, { MAIN - show high score screen }
                    mnuResume,        { PAUSE,EDITOR - resume game/editing }
                    mnuExitToMainMenu,{ PAUSE - exit to main menu}
                    mnuExit,          { ALL - exit}
                    mnuEdNavForward,  { EDITOR - navigation : forward }
                    mnuEdNavBackward, { EDITOR - navigation : backward }
                    mnuEdNew,         { EDITOR - new level }
                    mnuEdReplace,     { EDITOR - save level : replace }
                    mnuEdInsert,      { EDITOR - save level : insert }
                    mnuEdDelete,      { EDITOR - delete level }
                    mnuEdMvForward,   { EDITOR - move level : forward }
                    mnuEdMvBackward); { EDITOR - move level : backward }

{$endif}
