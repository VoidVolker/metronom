  \  Программа:  "Метроном"
  \  Версия: 3.7
  \  Автор:  VoidVolker
  \  Способ распространения: бесплатно
  \  Исходники: открытые
  \  Лицензия: MIT

\ DIS-OPT \ для версий ниже 4.00 build 10
REQUIRE WINDOWS... ~yz/lib/winlib.f
REQUIRE button ~yz/lib/winctl.f
REQUIRE toolbar ~yz/lib/wincc.f
REQUIRE S>NUM ~nn\lib\s2num.f
lib\win\const.f
REQUIRE win-pos ~profit/lib/winlibex.f
REQUIRE ATTACH-LINE ~pinka/samples/2005/lib/append-file.f

\ SET-OPT
\ Обозначения:
\ $ - color, цвет
\ -------------------------------------
\ Tools
1   CONSTANT VK_LBUTTON  \ К сожалению lib\win\const.f содержит лишь часть констант,
4   CONSTANT VK_MBUTTON  \ например нет некторых констант типа VK_ WM_ EM_ и пр.
2   CONSTANT VK_RBUTTON

WINAPI: GetKeyState USER32.DLL
: KEY-PRESSED? ( n -- ? )
    GetKeyState 128 AND 0<>  ;
: WAIT-KUP ( VK -- )
  BEGIN DUP KEY-PRESSED? WHILE
  100 PAUSE
  REPEAT DROP
;
  
: QUAN   0 VALUE ;
: -TH   CELLS + ;

: 'SWAP  \ ( a: X  a1: Y -- a: Y  a1: X )
  OVER @ OVER @ >R
  SWAP ! R> SWAP !
;

: DOUBLE>S
  DUP >R DABS <# 0 HOLD #S R> SIGN #> 1- ;
: N>S S>D DOUBLE>S ;

: N>HEX
  BASE @ >R
  16 BASE ! 
  S>D <# 0 HOLD  # # # # # # [CHAR] x HOLD [CHAR] 0 HOLD #> 1-
  R> BASE !
;

: FWRITE ( a u a-filename u-filename -- )
    W/O CREATE-FILE-SHARED IF DROP 2DROP EXIT THEN
    >R
    R@ WRITE-FILE DROP
    R> CLOSE-FILE DROP
;

\  : $NEGATE 0xFFFFFF - ABS ;

\ -------------------------------------
\ # Переменные
\ Окна и кнопки
QUAN win0
QUAN win0-xpos
QUAN win0-ypos
850 VALUE win0-x
200 VALUE win0-y
0 VALUE maximize?

QUAN quad0
QUAN start-lbl
QUAN #Hz-lbl
QUAN presets-lbl

QUAN about-win

QUAN arial
QUAN arial1

\ Цвета
0x000000 VALUE $bg-win0
\  0xFFFFFF VALUE $font-win0
0x000000 VALUE $bg-Hz
0xFF8000 VALUE $font-Hz
\  0xFF8000 VALUE $border
0xFFFFFF VALUE $start
0xFF8000 VALUE $start-hl
0xFFFFFF VALUE $font-prs

CREATE quads-colors 0xFF0000 , 0x00FF00 , 0x00FF00 , 0x00FF00 ,
\  CREATE quads-colors 0xFFFFFF , 0xFFFFFF , 0xFFFFFF , 0xFFFFFF ,

\ Строки
: Продолжить"   Z" Продолжить" ;
: Пауза"   Z" Пауза" ;
CREATE play/pause" Продолжить" , Пауза" ,
: options.f   S" options.f" ;

\ Остальные
5 VALUE шаг-частоты
60 VALUE Hz
4 VALUE quads
QUAN quad#
1000 VALUE пауза
QUAN play/pause?

CREATE пресеты  
  40 , 50 , 60 , 90 , 
  110 , 120 , 140 , 150 ,
  160 , 170 , 180 , 200 ,

QUAN hz-buf
QUAN cancel?

\ -------------------------------------
: force-redraw ( win -- )
  TRUE 0 ROT -hwnd@ InvalidateRect DROP
;

\ Лексикон применения настроек окон
: win0-colred
  $bg-win0 win0 -bgcolor!
  \  $font-win0 win0 -color!
;

: start-colored
  $bg-win0 start-lbl -color!
  $start start-lbl -bgcolor!
;

: start-place
  1 1 start-lbl ctlmove
  130 24 start-lbl ctlresize
;

: start-draw
  start-colored
  start-place
  start-lbl force-redraw
;

: n>Hz-lbl
  S>D <# 0 HOLD [CHAR] ц HOLD [CHAR] Г HOLD 32 HOLD #S #> DROP #Hz-lbl -text!
;

: Hz-draw
  Hz n>Hz-lbl
  arial #Hz-lbl -font!
  $font-Hz #Hz-lbl -color!
  $bg-Hz #Hz-lbl -bgcolor!
  presets-lbl -xsize@ 180 + 2  #Hz-lbl  ctlmove
  \ 150 1 #Hz-lbl ctlmove
  \ 150 1 #Hz-lbl ctlmove
  #Hz-lbl force-redraw
;

: quad-draw
  quads-colors quad# -TH @ quad0 -bgcolor!
  win0 -xsize@  quads / DUP win0 -ysize@ 27 - quad0 ctlresize
  quad# * 27 quad0 ctlmove
  quad0 force-redraw
;

\ Пресеты
: (частота!)  \ ( ударов_в_минуту -- )
  1 MAX 60000 MIN DUP TO Hz
  60000 SWAP /
  TO пауза
;

: частота!  \ ( ударов_в_минуту -- )
  (частота!)
  Hz-draw
;

PROC: частота>  Hz шаг-частоты +  частота! PROC;
PROC: частота<  Hz шаг-частоты -  частота! PROC;

PROC: PF1   пресеты           @ частота! PROC;
PROC: PF2   пресеты 1 CELLS + @ частота! PROC;
PROC: PF3   пресеты 2 CELLS + @ частота! PROC;
PROC: PF4   пресеты 3 CELLS + @ частота! PROC;

PROC: PF5   пресеты 4 CELLS + @ частота! PROC;
PROC: PF6   пресеты 5 CELLS + @ частота! PROC;
PROC: PF7   пресеты 6 CELLS + @ частота! PROC;
PROC: PF8   пресеты 7 CELLS + @ частота! PROC;

PROC: PF9   пресеты 8 CELLS + @ частота! PROC;
PROC: PF10  пресеты 9 CELLS + @ частота! PROC;
PROC: PF11  пресеты 10 CELLS + @ частота! PROC;
PROC: PF12  пресеты 11 CELLS + @ частота! PROC;

: 2BLHOLD BL HOLD BL HOLD ;
: N>2BL_STR_2DROP   S>D #S BL HOLD BL HOLD 2DROP ;
: пресеты"
  12 0 DO
    пресеты I CELLS + @
  LOOP
  <#
    0 HOLD 
    N>2BL_STR_2DROP  N>2BL_STR_2DROP  N>2BL_STR_2DROP  N>2BL_STR_2DROP
    2BLHOLD 2BLHOLD
    N>2BL_STR_2DROP  N>2BL_STR_2DROP  N>2BL_STR_2DROP  N>2BL_STR_2DROP
    2BLHOLD 2BLHOLD
    N>2BL_STR_2DROP  N>2BL_STR_2DROP  N>2BL_STR_2DROP  S>D #S
  #>
  DROP
;

: presets-draw
  пресеты"  presets-lbl -text!
  $bg-win0 presets-lbl -bgcolor!
  $font-prs presets-lbl -color!
  \ 235 2  presets-lbl  ctlmove
  150 2  presets-lbl  ctlmove
  presets-lbl -xsize@ 24 presets-lbl ctlresize
  presets-lbl force-redraw
;

PROC: Hz>F1   Hz пресеты           ! presets-draw PROC;
PROC: Hz>F2   Hz пресеты 1 CELLS + ! presets-draw PROC;
PROC: Hz>F3   Hz пресеты 2 CELLS + ! presets-draw PROC;
PROC: Hz>F4   Hz пресеты 3 CELLS + ! presets-draw PROC;

PROC: Hz>F5   Hz пресеты 4 CELLS + ! presets-draw PROC;
PROC: Hz>F6   Hz пресеты 5 CELLS + ! presets-draw PROC;
PROC: Hz>F7   Hz пресеты 6 CELLS + ! presets-draw PROC;
PROC: Hz>F8   Hz пресеты 7 CELLS + ! presets-draw PROC;

PROC: Hz>F9   Hz пресеты 8 CELLS + ! presets-draw PROC;
PROC: Hz>F10  Hz пресеты 9 CELLS + ! presets-draw PROC;
PROC: Hz>F11  Hz пресеты 10 CELLS + ! presets-draw PROC;
PROC: Hz>F12  Hz пресеты 11 CELLS + ! presets-draw PROC;

: применить-параметры
  win0-colred
  start-draw
  presets-draw
  Hz-draw
  quad-draw
;

\ -------------------------------------
\ #  Сохранение опций в *.f файл  
\ ( Все, надоело возиться с этим сохранением/загрузкой опций! 
\  Нужно написать более удобные инструменты!
\  А именно: написать новые определения переменных, которые будут 
\ или определены в одном большом массиве, или будут сохранять свои адреса и имена в массив.
\ Пока неясно какой из подходов оптимальнее, необходимо опробовать оба.

: >options.f  options.f ATTACH ;
: line>options.f  options.f ATTACH-LINE ;
: \CRLF   " \r\n" 2 >options.f ;

: позиция-окна   TO win0-ypos  TO win0-xpos ;
: размеры-окна   TO win0-y  TO win0-x ;
: максимизировать?   TO maximize? ;
: шаг   TO шаг-частоты ;
: частота   частота! ;
: >пресеты  \ ( i*x -- )
  12 0 DO
    пресеты 11 I - -TH !
  LOOP
;
: основной-фон   TO $bg-win0 ;
: частота-фон   TO $bg-Hz ;
: частота-шрифт   TO $font-Hz ;
: старт   TO $start ;
: старт-подсветка   TO $start-hl ;
: пресеты-шрифт   TO $font-prs ;
: квадраты
  4 0 DO
    quads-colors 3 I - -TH !
  LOOP
;

\  : число-квадратов   TO quads ;
: сохранить-опции
  options.f EMPTY
  S" \ Настройки главного окна" line>options.f
  win0-x win0-y S>D <# 2BLHOLD #S 2BLHOLD 2DROP S>D #S #> >options.f  
    S" размеры-окна" line>options.f
  win0 win-pos S>D <# 2BLHOLD #S 2BLHOLD 2DROP S>D #S #> >options.f  
    S" позиция-окна" line>options.f
  maximize? N>S >options.f  S"     максимизировать?" line>options.f
  \CRLF
  S" \ Основные настройки" line>options.f
  шаг-частоты N>S >options.f  S"     шаг" line>options.f
  Hz N>S >options.f  S"     частота" line>options.f
  \CRLF
  S" \ Пресеты" line>options.f
  3 0 DO
    4 0 DO
    пресеты J 4 * I + -TH @ S>D <# 2BLHOLD #S #>  >options.f
    LOOP
    \CRLF
  LOOP
  S" >пресеты" line>options.f
  \CRLF
  S" \ Цвета" line>options.f
  $bg-win0 N>HEX >options.f S"    основной-фон" line>options.f
  \  $font-win0 N>S >options.f S"    шрифт" line>options.f
  $bg-Hz N>HEX >options.f S"    частота-фон" line>options.f
  $font-Hz N>HEX >options.f S"    частота-шрифт" line>options.f
  $start N>HEX >options.f S"    старт" line>options.f
  $start-hl N>HEX >options.f S"    старт-подсветка" line>options.f
  $font-prs N>HEX >options.f S"    пресеты-шрифт" line>options.f
  \CRLF
  4 0 DO 
    quads-colors I -TH @ N>HEX >options.f S"   " >options.f
  LOOP
  S"   квадраты" >options.f
;

\ -------------------------------------
\ # Разное
PROC: выход
  winmain W: wm_close ?send DROP
PROC;

\ -------------------------------------
: win-swap-colors  >R R@ -color@ R@ -bgcolor@ R@ -color! R>  -bgcolor! ;
PROC: about 
  0 tool-window TO about-win  \ Не знаю почему, но если это оно создать после основного, то весь вывод в него направляется :(
  " О программе" about-win -text!
  GRID
  "   Программа:  Метроном" 
  label DUP win-swap-colors 
  DUP -color@ about-win -color! 
  DUP -bgcolor@ about-win -bgcolor! |
  ===
  "   Версия: 3.7" label DUP win-swap-colors  |
  ===
  "   Автор:  VoidVolker" label DUP win-swap-colors  |
  ===
  "   Способ распространения: бесплатно" label DUP win-swap-colors  |
  ===
  "   Исходники: открытые" label DUP win-swap-colors  |
  ===
  "   Лицензия: MIT" label DUP win-swap-colors  |
  ===
  "   Связь с автором: voidvolker@gmail.com  " label DUP win-swap-colors  |
  GRID; about-win -grid!
  about-win winshow
PROC;

\ -------------------------------------
\ # Контекстное меню
MENU: my-contextmenu
  about MENUITEM О программе
MENU;

\ -------------------------------------
\ Потоки

:NONAME  \ Двигает окно quad
  play/pause? 
    IF 
      quad-draw
      пауза PAUSE
      quad# 1+ quads MOD TO quad#
    ELSE
      1000 PAUSE
    THEN
  RECURSE
; TASK: MoveQuad

:NONAME  \ Вспомогательный поток для обнуления буфера ввода чисел
  cancel? 0=
    IF
    0
    100 0 DO 
      100 PAUSE
      cancel? OR
    LOOP
    0= IF 0 TO hz-buf THEN
  THEN
; TASK: hz-buf-0!

\ Подсветка кнопки "старт"
:NONAME
  VK_LBUTTON WAIT-KUP
  start-draw
  1000 PAUSE
; TASK: un-hl-start


\ -------------------------------------
\ # Обработка сообщений

PROC: start-proc
  play/pause? 0= TO play/pause?
  play/pause" play/pause? ABS -TH @ start-lbl -text!
  $start-hl start-lbl -bgcolor!
  $start start-lbl -color!
  start-place
  start-lbl force-redraw
  un-hl-start START
PROC;

\ Основное окно

MESSAGES: wmain-proc

M: WM_CAPTURECHANGED
  применить-параметры
  TRUE
M;

M: WM_MDIRESTORE
  применить-параметры
  TRUE
M;

M: WM_ACTIVATE
  применить-параметры
  TRUE
M;

M: WM_SETFOCUS
  применить-параметры
  TRUE
M;

M: WM_CHAR
    wparam 48 58 WITHIN
      IF
        hz-buf 10 * wparam 48 - + 60000 MIN TO hz-buf
        hz-buf n>Hz-lbl
        TRUE TO cancel?
        hz-buf-0! START
      THEN
  TRUE
M;

M: WM_KEYDOWN
    wparam VK_BACK =  \ Backspace
    wparam VK_DELETE =  OR
      IF
        0 n>Hz-lbl
        0 TO hz-buf
      THEN
    wparam VK_RETURN =  \ Enter
      IF
        FALSE TO cancel?
        hz-buf частота!
        0 TO hz-buf
      THEN
    \  wparam VK_SPACE =
      \  IF
        
      \  THEN
  TRUE
M;

M: wm_contextmenu
  my-contextmenu lparam LOWORD lparam HIWORD show-menu
  TRUE
M;

MESSAGES;


\ -------------------------------------
\ # Таблица быстрых клавиш
KEYTABLE
  выход  ONKEY alt+X
  выход  ONKEY vk_escape

  PF1  ONKEY vk_f1
  PF2  ONKEY vk_f2
  PF3  ONKEY vk_f3
  PF4  ONKEY vk_f4

  PF5  ONKEY vk_f5
  PF6  ONKEY vk_f6
  PF7  ONKEY vk_f7
  PF8  ONKEY vk_f8

  PF9  ONKEY vk_f9
  PF10 ONKEY vk_f10
  PF11 ONKEY vk_f11
  PF12 ONKEY vk_f12

  Hz>F1  ONKEY ctrl+vk_f1
  Hz>F2  ONKEY ctrl+vk_f2
  Hz>F3  ONKEY ctrl+vk_f3
  Hz>F4  ONKEY ctrl+vk_f4

  Hz>F5  ONKEY ctrl+vk_f5
  Hz>F6  ONKEY ctrl+vk_f6
  Hz>F7  ONKEY ctrl+vk_f7
  Hz>F8  ONKEY ctrl+vk_f8

  Hz>F9  ONKEY ctrl+vk_f9
  Hz>F10 ONKEY ctrl+vk_f10
  Hz>F11 ONKEY ctrl+vk_f11
  Hz>F12 ONKEY ctrl+vk_f12

  частота> ONKEY vk_prior
  частота< ONKEY vk_next
  
  start-proc ONKEY VK_SPACE
KEYTABLE;

\ -------------------------------------

: run
  WINDOWS...
  " Arial" 12 bold create-font TO arial
  " Arial" 10 create-font TO arial1
  \ # Создаем основное окно   
    0 create-window TO win0
    win0 TO winmain
  \ # Создаем дочерние окна
    rectangle TO quad0
    " Старт" label TO start-lbl
    Hz N>S DROP label TO #Hz-lbl
    " Пресеты..." label TO presets-lbl
  \ # Применяем стартовые настройки
    " Метроном 3.6" win0 -text!
    options.f ['] INCLUDED CATCH IF сохранить-опции THEN
    win0-xpos win0-ypos win0 winmove
    win0-x win0-y win0 winresize
    maximize? 
      IF 
        win0 winmaximize
      THEN
    arial presets-lbl -font!
  \ # Выравниваем текст в надписях
    center start-lbl -align!
    center #Hz-lbl -align!
    center presets-lbl -align!
  \ # Ставим обработчики сообщений
    start-proc start-lbl -command!
    wmain-proc win0 -wndproc!
  \ # Применяем настройки
    применить-параметры
  \ # Активируем потоки
    MoveQuad START
  \ # Показываем окна
    win0 winshow
    quad0 winshow
    #Hz-lbl ctlshow
    start-lbl ctlshow
    presets-lbl ctlshow
  ...WINDOWS
  ." Программа завершилась" CR
  arial delete-font
  arial1 delete-font
  сохранить-опции
  BYE ;

REMOVE-ALL-CONSTANTS
0 TO SPF-INIT?
' ANSI>OEM TO ANSI><OEM
TRUE TO ?GUI
' run MAINX !
S" metronom.exe" SAVE  
\  run
BYE
