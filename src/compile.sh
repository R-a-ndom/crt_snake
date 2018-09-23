#!/bin/bash

# CRT_SNAKE building script

debug_key="-g -dDEBUG"
editor_key="-dEDITOR"
game_key="-dGAME"
release_key=''

act_debug_build_game=1
act_debug_build_run_game=2
act_debug_build_editor=3
act_debug_build_run_editor=4
act_release_build_game=5
act_release_build_editor=6
act_remove_all_obj=0

write_promt() {
  echo "Please, choose a number:"
  echo "[    1    ] - DEBUG  - <    BUILD    > GAME"
  echo "[    2    ] - DEBUG  - <BUILD AND RUN> GAME"
  echo
  echo "[    3    ] - DEBUG  - <    BUILD    > EDITOR "
  echo "[    4    ] - DEBUG  - <BUILD AND RUN> EDITOR"
  echo
  echo "[    5    ] - RELEASE - <    BUILD    > GAME"
  echo "[    6    ] - RELEASE - <    BUILD    > EDITOR"
  echo
  echo "[    6    ] - RELEASE - <    BUILD    > ALL"
  echo
  echo
  echo "[    0    ] - Deleting object files and binaries"
  echo
  echo '[ Any key ] - exit'
}

remove_all_obj()
{
  rm *.o *.ppu
}

# ------------------
# |  MAIN SCENERY  |
# ------------------

echo -e "\nCRT_SNAKE - building a project\n"
write_promt
read -n 1 action_num
echo
case $action_num in

# DEBUG - building a game

  $act_debug_build_game)
     fpc $game_key $debug_key crt_snake.pas
     ;;


  $act_debug_build_run_game)
     fpc $game_key $debug_key crt_snake.pas
     ./crt_snake
     ;;

# DEBUG - building a level editor

  $act_debug_build_editor)
     fpc $editor_key $debug_key -olevel_editor editor_main.pas
     ;;


  $act_debug_build_run_editor)
     fpc $editor_key $debug_key -olevel_editor editor_main.pas
     ./level_editor
     ;;

# RELEASE - build

  $act_release_build_game)
     fpc $game_key $release_key crt_snake.pas
     ;;

  $act_release_build_editor)
     fpc $editor $release_key -olevel_editor editor_main.pas
     ;;

  $act_release_build_all)
     fpc $game_key $release_key crt_snake.pas
     fpc $editor $release_key -olevel_editor editor_main.pas
     ;;

# deleting .O and .PPU files

  $act_remove_all_obj)
    echo -e "Deleting following files:\n"
    echo $(ls *.o)
    echo $(ls *.ppu)
    remove_all_obj
    echo -e "\nReady!"
    ;;

# exit without actions

  *) echo "Exit from script..." ;;
esac