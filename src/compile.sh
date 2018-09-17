#!/bin/bash

# CRT_SNAKE building script

debug_key="-g -dDEBUG"

write_promt() {
  echo "Please, choose a number:"
  echo "[    1    ] - Building a game - DEBUG edition"
  echo "[    2    ] - Building a level editor - DEBUG edition"
  echo
  echo "[    3    ] - Building a game - RELEASE edition"
  echo "[    4    ] - Building a level editor - RELEASE edition"
  echo
  echo "[    5    ] - Deleting object files and binaries"
  echo
  echo '[ Any key ] - exit'
}

echo -e "\nCRT_SNAKE - building a project\n"
write_promt;
read -n 1 confirm
echo
case $confirm in

# DEBUG - building a game

  1) fpc $debug_key crt_snake.pas ;;

# DEBUG - building a level editor

  2) fpc $debug_key -olevel_editor editor_main.pas ;;

# RELEASE - building a game

  3) fpc crt_snake.pas ;;

# RELEASE - building a level editor

  4) fpc -olevel_editor editor_main.pas ;;

# deleting compilation results

  5)
    echo -e "Deleting following files:\n"
    echo $(ls *.o)
    echo $(ls *.ppu)
    rm *.o *.ppu
    echo -e "\nReady!"
    ;;

# exit without actions

  *) echo "Exit from script..." ;;
esac