
10 dim fl$(256):fp=0
4970 open8,8,0,"$":fori=1to6:get#8,a$:next:ifa$=""thena$=chr$(0)
4990 a$=str$(asc(a$)):a$=right$(a$,len(a$)-1):printa$;" ";
4995 fori=1to26:get#8,a$:printa$;:next:print
5010 get#8,a$,b$:get#8,a$,b$:ifa$<>""thenc=asc(a$)
5030 ifb$<>""thenc=c+asc(b$)*256
5050 d$=str$(c):d$=right$(d$,len(d$)-1):printd$;
5055 fori=4tolen(d$)step-1:print" ";:next
5070 get#8,b$:ifst<>0then5250
5090 ifb$<>chr$(34)then5070
5095 f$=""
5110 nm=0:d$="  ":printchr$(34);
5130 get#8,b$:ifb$<>chr$(34)thenprintb$;:nm=nm+1:f$=f$+b$:goto5130
5150 printchr$(34);:fori=1to((15-nm)+len(d$)):print" ";:next
5170 get#8,b$:ifb$=" "then5170
5190 ch$=b$
5210 get#8,a$:ch$=ch$+a$:ifa$<>""then5210
5230 printleft$(ch$,3)
5231 fl$(fp)=f$:fp=fp+1
5240 goto5010
5250 close8:print" blocks free":open15,8,15:input#15,a$:close15
5260 fori=0tofp-1
5265 open 1,8,0,fl$(i)
5266 get#1,x$,y$
5267 print asc(x$+chr$(0))+256*asc(y$+chr$(0));
5268 close1
5269 print "start address ";fl$(i)
5270 next


