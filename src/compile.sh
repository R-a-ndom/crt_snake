#!/bin/bash

# CRT_SNAKE building script

write_promt() {
  echo "Please, choose a number:"
  echo "[    1    ] - Building a game"
  echo "[    2    ] - Building a level editor"
  echo "[    3    ] - Deleting an object files and binaries"
  echo '[ Any key ] - exit'
}

echo -e "\nCRT_SNAKE - building a project\n"
write_promt;
read -n 1 confirm
echo
case $confirm in

# building a game

  1) fpc crt_snake.pas ;;

# building a level editor

  2) fpc -olevel_editor editor_main.pas ;;

# deleting compilation results

  3)
    echo -e "Deleting following files:\n"
    echo $(ls *.o)
    echo $(ls *.ppu)
    rm *.o *.ppu
    echo -e "\nReady!"
    ;;

# exit without actions

  *) echo "Exit from script..." ;;
esac