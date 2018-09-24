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
  kbdTAB=#9;
  kbdSPACE=#32;
  kbdENTER=#13;

TYPE

{ field cell values }

  CellValue = ( clEmpty,  {empty cell}
                clBrick,  {brick cell}
                clFriut,  {friut - for growing}
                clCoin,   {coin - for score}
                clBody,   {snake's body}
                clHead ); {snake's head}

{ game field array }

  GameField = array[0..FieldWidth,0..FieldHeight] of CellValue;

  LevelFile = file of GameField;

{ menu selection items }

  MenuSelection = ( mnuBeginGame,      { MAIN - begin game }
                    mnuShowHighScore,  { MAIN - show high score screen }
                    mnuResume,         { PAUSE,EDITOR - resume game/editing }
                    mnuConfirm,        { ALL - confirm }
                    mnuCancel,         { ALL - cancel }
                    mnuResumeNeedReset,{ ALL - need reset editor screen }
                    mnuExitToMainMenu, { PAUSE - exit to main menu}
                    mnuExitRequest,    { ALL - exit}
                    mnuEdNavForward,   { EDITOR - navigation : forward }
                    mnuEdNavBackward,  { EDITOR - navigation : backward }
                    mnuEdAddToEnd,     { EDITOR - add an empty level to the end }
                    mnuEdSave,         { EDITOR - save level : replace }
                    mnuEdDelete,       { EDITOR - delete level }
                    mnuEdMovForward,   { EDITOR - move level : forward }
                    mnuEdMovBackward); { EDITOR - move level : backward }

{$endif}
