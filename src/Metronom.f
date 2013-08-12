  \  ���������:  "��������"
  \  ������: 3.7
  \  �����:  VoidVolker
  \  ������ ���������������: ���������
  \  ���������: ��������
  \  ��������: MIT

\ DIS-OPT \ ��� ������ ���� 4.00 build 10
REQUIRE WINDOWS... ~yz/lib/winlib.f
REQUIRE button ~yz/lib/winctl.f
REQUIRE toolbar ~yz/lib/wincc.f
REQUIRE S>NUM ~nn\lib\s2num.f
lib\win\const.f
REQUIRE win-pos ~profit/lib/winlibex.f
REQUIRE ATTACH-LINE ~pinka/samples/2005/lib/append-file.f

\ SET-OPT
\ �����������:
\ $ - color, ����
\ -------------------------------------
\ Tools
1   CONSTANT VK_LBUTTON  \ � ��������� lib\win\const.f �������� ���� ����� ��������,
4   CONSTANT VK_MBUTTON  \ �������� ��� �������� �������� ���� VK_ WM_ EM_ � ��.
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
\ # ����������
\ ���� � ������
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

\ �����
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

\ ������
: ����������"   Z" ����������" ;
: �����"   Z" �����" ;
CREATE play/pause" ����������" , �����" ,
: options.f   S" options.f" ;

\ ���������
5 VALUE ���-�������
60 VALUE Hz
4 VALUE quads
QUAN quad#
1000 VALUE �����
QUAN play/pause?

CREATE �������  
  40 , 50 , 60 , 90 , 
  110 , 120 , 140 , 150 ,
  160 , 170 , 180 , 200 ,

QUAN hz-buf
QUAN cancel?

\ -------------------------------------
: force-redraw ( win -- )
  TRUE 0 ROT -hwnd@ InvalidateRect DROP
;

\ �������� ���������� �������� ����
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
  S>D <# 0 HOLD [CHAR] � HOLD [CHAR] � HOLD 32 HOLD #S #> DROP #Hz-lbl -text!
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

\ �������
: (�������!)  \ ( ������_�_������ -- )
  1 MAX 60000 MIN DUP TO Hz
  60000 SWAP /
  TO �����
;

: �������!  \ ( ������_�_������ -- )
  (�������!)
  Hz-draw
;

PROC: �������>  Hz ���-������� +  �������! PROC;
PROC: �������<  Hz ���-������� -  �������! PROC;

PROC: PF1   �������           @ �������! PROC;
PROC: PF2   ������� 1 CELLS + @ �������! PROC;
PROC: PF3   ������� 2 CELLS + @ �������! PROC;
PROC: PF4   ������� 3 CELLS + @ �������! PROC;

PROC: PF5   ������� 4 CELLS + @ �������! PROC;
PROC: PF6   ������� 5 CELLS + @ �������! PROC;
PROC: PF7   ������� 6 CELLS + @ �������! PROC;
PROC: PF8   ������� 7 CELLS + @ �������! PROC;

PROC: PF9   ������� 8 CELLS + @ �������! PROC;
PROC: PF10  ������� 9 CELLS + @ �������! PROC;
PROC: PF11  ������� 10 CELLS + @ �������! PROC;
PROC: PF12  ������� 11 CELLS + @ �������! PROC;

: 2BLHOLD BL HOLD BL HOLD ;
: N>2BL_STR_2DROP   S>D #S BL HOLD BL HOLD 2DROP ;
: �������"
  12 0 DO
    ������� I CELLS + @
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
  �������"  presets-lbl -text!
  $bg-win0 presets-lbl -bgcolor!
  $font-prs presets-lbl -color!
  \ 235 2  presets-lbl  ctlmove
  150 2  presets-lbl  ctlmove
  presets-lbl -xsize@ 24 presets-lbl ctlresize
  presets-lbl force-redraw
;

PROC: Hz>F1   Hz �������           ! presets-draw PROC;
PROC: Hz>F2   Hz ������� 1 CELLS + ! presets-draw PROC;
PROC: Hz>F3   Hz ������� 2 CELLS + ! presets-draw PROC;
PROC: Hz>F4   Hz ������� 3 CELLS + ! presets-draw PROC;

PROC: Hz>F5   Hz ������� 4 CELLS + ! presets-draw PROC;
PROC: Hz>F6   Hz ������� 5 CELLS + ! presets-draw PROC;
PROC: Hz>F7   Hz ������� 6 CELLS + ! presets-draw PROC;
PROC: Hz>F8   Hz ������� 7 CELLS + ! presets-draw PROC;

PROC: Hz>F9   Hz ������� 8 CELLS + ! presets-draw PROC;
PROC: Hz>F10  Hz ������� 9 CELLS + ! presets-draw PROC;
PROC: Hz>F11  Hz ������� 10 CELLS + ! presets-draw PROC;
PROC: Hz>F12  Hz ������� 11 CELLS + ! presets-draw PROC;

: ���������-���������
  win0-colred
  start-draw
  presets-draw
  Hz-draw
  quad-draw
;

\ -------------------------------------
\ #  ���������� ����� � *.f ����  
\ ( ���, ������� �������� � ���� �����������/��������� �����! 
\  ����� �������� ����� ������� �����������!
\  � ������: �������� ����� ����������� ����������, ������� ����� 
\ ��� ���������� � ����� ������� �������, ��� ����� ��������� ���� ������ � ����� � ������.
\ ���� ������ ����� �� �������� �����������, ���������� ���������� ���.

: >options.f  options.f ATTACH ;
: line>options.f  options.f ATTACH-LINE ;
: \CRLF   " \r\n" 2 >options.f ;

: �������-����   TO win0-ypos  TO win0-xpos ;
: �������-����   TO win0-y  TO win0-x ;
: ���������������?   TO maximize? ;
: ���   TO ���-������� ;
: �������   �������! ;
: >�������  \ ( i*x -- )
  12 0 DO
    ������� 11 I - -TH !
  LOOP
;
: ��������-���   TO $bg-win0 ;
: �������-���   TO $bg-Hz ;
: �������-�����   TO $font-Hz ;
: �����   TO $start ;
: �����-���������   TO $start-hl ;
: �������-�����   TO $font-prs ;
: ��������
  4 0 DO
    quads-colors 3 I - -TH !
  LOOP
;

\  : �����-���������   TO quads ;
: ���������-�����
  options.f EMPTY
  S" \ ��������� �������� ����" line>options.f
  win0-x win0-y S>D <# 2BLHOLD #S 2BLHOLD 2DROP S>D #S #> >options.f  
    S" �������-����" line>options.f
  win0 win-pos S>D <# 2BLHOLD #S 2BLHOLD 2DROP S>D #S #> >options.f  
    S" �������-����" line>options.f
  maximize? N>S >options.f  S"     ���������������?" line>options.f
  \CRLF
  S" \ �������� ���������" line>options.f
  ���-������� N>S >options.f  S"     ���" line>options.f
  Hz N>S >options.f  S"     �������" line>options.f
  \CRLF
  S" \ �������" line>options.f
  3 0 DO
    4 0 DO
    ������� J 4 * I + -TH @ S>D <# 2BLHOLD #S #>  >options.f
    LOOP
    \CRLF
  LOOP
  S" >�������" line>options.f
  \CRLF
  S" \ �����" line>options.f
  $bg-win0 N>HEX >options.f S"    ��������-���" line>options.f
  \  $font-win0 N>S >options.f S"    �����" line>options.f
  $bg-Hz N>HEX >options.f S"    �������-���" line>options.f
  $font-Hz N>HEX >options.f S"    �������-�����" line>options.f
  $start N>HEX >options.f S"    �����" line>options.f
  $start-hl N>HEX >options.f S"    �����-���������" line>options.f
  $font-prs N>HEX >options.f S"    �������-�����" line>options.f
  \CRLF
  4 0 DO 
    quads-colors I -TH @ N>HEX >options.f S"   " >options.f
  LOOP
  S"   ��������" >options.f
;

\ -------------------------------------
\ # ������
PROC: �����
  winmain W: wm_close ?send DROP
PROC;

\ -------------------------------------
: win-swap-colors  >R R@ -color@ R@ -bgcolor@ R@ -color! R>  -bgcolor! ;
PROC: about 
  0 tool-window TO about-win  \ �� ���� ������, �� ���� ��� ��� ������� ����� ���������, �� ���� ����� � ���� ������������ :(
  " � ���������" about-win -text!
  GRID
  "   ���������:  ��������" 
  label DUP win-swap-colors 
  DUP -color@ about-win -color! 
  DUP -bgcolor@ about-win -bgcolor! |
  ===
  "   ������: 3.7" label DUP win-swap-colors  |
  ===
  "   �����:  VoidVolker" label DUP win-swap-colors  |
  ===
  "   ������ ���������������: ���������" label DUP win-swap-colors  |
  ===
  "   ���������: ��������" label DUP win-swap-colors  |
  ===
  "   ��������: MIT" label DUP win-swap-colors  |
  ===
  "   ����� � �������: voidvolker@gmail.com  " label DUP win-swap-colors  |
  GRID; about-win -grid!
  about-win winshow
PROC;

\ -------------------------------------
\ # ����������� ����
MENU: my-contextmenu
  about MENUITEM � ���������
MENU;

\ -------------------------------------
\ ������

:NONAME  \ ������� ���� quad
  play/pause? 
    IF 
      quad-draw
      ����� PAUSE
      quad# 1+ quads MOD TO quad#
    ELSE
      1000 PAUSE
    THEN
  RECURSE
; TASK: MoveQuad

:NONAME  \ ��������������� ����� ��� ��������� ������ ����� �����
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

\ ��������� ������ "�����"
:NONAME
  VK_LBUTTON WAIT-KUP
  start-draw
  1000 PAUSE
; TASK: un-hl-start


\ -------------------------------------
\ # ��������� ���������

PROC: start-proc
  play/pause? 0= TO play/pause?
  play/pause" play/pause? ABS -TH @ start-lbl -text!
  $start-hl start-lbl -bgcolor!
  $start start-lbl -color!
  start-place
  start-lbl force-redraw
  un-hl-start START
PROC;

\ �������� ����

MESSAGES: wmain-proc

M: WM_CAPTURECHANGED
  ���������-���������
  TRUE
M;

M: WM_MDIRESTORE
  ���������-���������
  TRUE
M;

M: WM_ACTIVATE
  ���������-���������
  TRUE
M;

M: WM_SETFOCUS
  ���������-���������
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
        hz-buf �������!
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
\ # ������� ������� ������
KEYTABLE
  �����  ONKEY alt+X
  �����  ONKEY vk_escape

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

  �������> ONKEY vk_prior
  �������< ONKEY vk_next
  
  start-proc ONKEY VK_SPACE
KEYTABLE;

\ -------------------------------------

: run
  WINDOWS...
  " Arial" 12 bold create-font TO arial
  " Arial" 10 create-font TO arial1
  \ # ������� �������� ����   
    0 create-window TO win0
    win0 TO winmain
  \ # ������� �������� ����
    rectangle TO quad0
    " �����" label TO start-lbl
    Hz N>S DROP label TO #Hz-lbl
    " �������..." label TO presets-lbl
  \ # ��������� ��������� ���������
    " �������� 3.6" win0 -text!
    options.f ['] INCLUDED CATCH IF ���������-����� THEN
    win0-xpos win0-ypos win0 winmove
    win0-x win0-y win0 winresize
    maximize? 
      IF 
        win0 winmaximize
      THEN
    arial presets-lbl -font!
  \ # ����������� ����� � ��������
    center start-lbl -align!
    center #Hz-lbl -align!
    center presets-lbl -align!
  \ # ������ ����������� ���������
    start-proc start-lbl -command!
    wmain-proc win0 -wndproc!
  \ # ��������� ���������
    ���������-���������
  \ # ���������� ������
    MoveQuad START
  \ # ���������� ����
    win0 winshow
    quad0 winshow
    #Hz-lbl ctlshow
    start-lbl ctlshow
    presets-lbl ctlshow
  ...WINDOWS
  ." ��������� �����������" CR
  arial delete-font
  arial1 delete-font
  ���������-�����
  BYE ;

REMOVE-ALL-CONSTANTS
0 TO SPF-INIT?
' ANSI>OEM TO ANSI><OEM
TRUE TO ?GUI
' run MAINX !
S" metronom.exe" SAVE  
\  run
BYE
