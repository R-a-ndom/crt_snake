#!/bin/bash

# CRT_SNAKE building script

debug_key="-g -dDEBUG"
release_key="-o3"
bin_dir="../bin/"
ed_name="level_editor"

act_debug_build_game=1
act_debug_build_run_game=2
act_debug_build_editor=3
act_debug_build_run_editor=4
act_release_build_game=5
act_release_build_editor=6
act_release_build_all=6
act_remove_all_obj=0

write_promt() {
  echo "Please, choose a number:"
  echo "[    1    ] - DEBUG   - <    build    > GAME"
  echo "[    2    ] - DEBUG   - < build / run > GAME"
  echo
  echo "[    3    ] - DEBUG   - <    build    > EDITOR "
  echo "[    4    ] - DEBUG   - < build / run > EDITOR"
  echo
  echo "[    5    ] - RELEASE - <    build    > GAME"
  echo "[    6    ] - RELEASE - <    build    > EDITOR"
  echo
  echo "[    7    ] - RELEASE - <    build    > ALL"
  echo
  echo
  echo "[    0    ] - Deleting object files and binaries"
  echo
  echo '[ Any key ] - exit'
}

remove_all_obj() {
  rm $1/*.o $1/*.ppu
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
     fpc $debug_key crt_snake.pas
     ;;


  $act_debug_build_run_game)
     fpc $debug_key crt_snake.pas
     ./crt_snake
     ;;

# DEBUG - building a level editor

  $act_debug_build_editor)
     rm *.o *.ppu ./level_editor 2>/dev/null
     fpc $debug_key -o$bin_dir$ed_name editor_main.pas
     ;;


  $act_debug_build_run_editor)
     rm *.o *.ppu ./level_editor 2>/dev/null
     fpc $debug_key -o$bin_dir$ed_name editor_main.pas
     $bin_dir$ed_name
     ;;

# RELEASE - build

  $act_release_build_game)
     fpc $release_key crt_snake.pas
     ;;

  $act_release_build_editor)
     fpc $release_key -olevel_editor editor_main.pas
     ;;

  $act_release_build_all)
     fpc $release_key crt_snake.pas
     fpc $release_key -olevel_editor editor_main.pas
     ;;

# deleting .O and .PPU files

  $act_remove_all_obj)
    echo -e "Deleting following files:\n"
    echo $(ls -l *.o)
    echo $(ls -l *.ppu)
    echo $(ls -l $bin_dir*.o)
    echo $(ls -l $bin_dir*.ppu)
    remove_all_obj .
    remove_all_obj $bin_dir
    echo -e "\nReady!"
    echo
    ;;

# exit without actions

  *) echo "Exit from script..." ;;
esac
