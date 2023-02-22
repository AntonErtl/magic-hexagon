\ Magic Hexagon by M. Anton Ertl 2023 (based on sendmore-ae.4th)

create occupationmap 20 allot
\ each entry is 0 if free, non-0 if occupied

: occupation! ( f u -- )
    occupationmap + c! ;

: occupy< ( u -- u )
    ]] dup >r occupationmap + c@ 0= if true r@ occupation! r@ [[ ; immediate

: >occupy ( -- )
    ]] false r@ occupation! then rdrop [[ ; immediate

: try< ( run-time: -- u )
    ]] 20 1 do i occupy< [[ ; immediate

: >try ( run-time: -- )
    ]] >occupy loop [[ ; immediate

: .. 4 .r ;

: mhex ( -- )
 \ SEND+MORE=MONEY
 occupationmap 20 erase
 try< {: A :}
  try< {: C :} A C < if
   38 A - C - occupy< {: B :}
    try< {: L :} A L < if
     38 C - L - occupy< {: G :}
      try< {: S :} A S < if
       38 L - S - occupy< {: P :}
        try< {: Q :} A Q < if
         38 S - Q - occupy< {: R :}
          try< {: H :} A H < if C H < if
           38 Q - H - occupy< {: M :}
            38 H - A - occupy< {: D :}
             try< {: E :}
              38 D - E - G - occupy< {: F :}
               38 B - F - P - occupy< {: K :}
                38 G - K - R - occupy< {: O :}
                 38 P - O - M - occupy< {: N :}
                  38 R - N - D - occupy< {: I :}
                   38 M - I - B - E = if
                    38 A - E - O - S - occupy< {: J :}
                     H I + J + K + L + 38 = if
                      C F + J + N + Q + 38 = if
                       cr ."     " A .. B .. C ..
                       cr ."   " D .. E .. F .. G ..
                       cr      H .. I .. J .. K .. L ..
                       cr ."   " M .. N .. O .. P ..
                       cr ."     " Q .. R .. S .. cr
                       \ uncomment the next four lines to stop after 1 solution
                       \ rdrop rdrop rdrop rdrop rdrop rdrop rdrop unloop
                       \ rdrop rdrop rdrop unloop rdrop rdrop unloop
                       \ rdrop rdrop unloop rdrop rdrop unloop
                       \ rdrop rdrop unloop rdrop unloop exit 
                      then
                     then
                    >occupy
                   then
                  >occupy
                 >occupy
                >occupy
               >occupy
              >occupy
             >try
            >occupy
           >occupy
          then then >try
         >occupy
        then >try
       >occupy
      then >try
     >occupy
    then >try
   >occupy
  then >try
 >try ;
